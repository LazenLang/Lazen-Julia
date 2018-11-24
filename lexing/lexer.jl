module lexer

    include("token.jl")
    include("../text_util.jl")
    include("../info.jl")

    mutable struct lexer_state_machine
        opnd_paren_amount   :: Integer  # Indicates the amount of opened parenthesis
        opnd_bracket_amount :: Integer  # Indicates the amount of opened brackets
    end

    function identify_tok_type(token_val :: String) :: token.TokenType
        if     occursin(r"^(?![0-9])[a-zA-Z_0-9]*$", token_val) ; return token.IDENTIFIER
        elseif occursin(r"^[0-9]*$", token_val)                 ; return token.INTEGER
        else                                                    ; return token.OTHER
        end
    end

    function find_in_tupleLst(tuple_lst :: Array{}, element) :: Integer
        for (index, (left_elem, _)) in enumerate(tuple_lst)
            if left_elem == element
                return index
            end
        end

        return -1
    end

    function go(code :: Array{Char}) :: Tuple{Array{token.Token}, Array{String}}
        fn_res               = []
        counter, last_idx    = 1, 1
        code_len             = length(code)
        state_machine        = lexer_state_machine(0, 0)
        ln_counter           = 1
        ln_accum             = ""
        raw_lines_lst        = []
        lines_colsAmnt_accum = 0

        for _ in code
            if counter > code_len; break; end

            last_char, next_char = "", ""
            curr_char            = code[counter]
            curr_pos             = token.Position(ln_counter, (counter - lines_colsAmnt_accum, 
                                                               counter - lines_colsAmnt_accum))

            if counter > 1
                last_char = code[counter - 1]
            end

            if counter < code_len
                next_char = code[counter + 1]
            end

            if curr_char in ['\'', '\"']
                if curr_char in code[counter + 1 : end]

                    next_quote   = counter + findfirst(code[counter + 1 : end] .== curr_char)[1]
                    get_lit      = text_util.conv_to_str(code[counter + 1 : next_quote - 1])
                    ln_accum     = string(ln_accum, curr_char, get_lit, curr_char)

                    pos_to_put = token.Position(curr_pos.line,
                                               (curr_pos.start_end_cols[1], curr_pos.start_end_cols[1] + length(get_lit) + 1))

                    push!(fn_res, token.Token(get_lit, curr_char == '\'' ? token.CHAR_LIT : token.STR_LIT, pos_to_put))
                    counter  += length(get_lit) + 2
                    last_idx = counter

                    continue

                else

                    push!(fn_res, token.Token(string(curr_char),
                                              curr_char == '\'' ? token.APOSTROPHE : token.QUOTE, curr_pos))
                    
                    ln_accum = string(ln_accum, curr_char)                        
                    counter  += 1
                    last_idx =  counter

                    continue

                end
            end

            if curr_char     == '('; state_machine.opnd_paren_amount   += 1
            elseif curr_char == ')'; state_machine.opnd_paren_amount   -= 1
            elseif curr_char == '['; state_machine.opnd_bracket_amount += 1
            elseif curr_char == ']'; state_machine.opnd_bracket_amount -= 1
            end

            if curr_char == '#'
                still_code = text_util.conv_to_str(code[counter : code_len])
                counter += findfirst("\n", still_code)[1]
                last_idx = counter
            else
                if curr_char != '\n'
                    ln_accum = string(ln_accum, curr_char)
                end

                eventual = [
                                string(curr_char, next_char) in info.concat_lsts,
                                string(curr_char) in info.concat_lsts
                           ]

                if eventual[1] || eventual[2]

                    # Determine the found operator

                    found_op = ""

                    if eventual[1]
                        found_op = string(curr_char, next_char)
                    elseif eventual[2]
                        found_op = string(curr_char)
                    end

                    to_put      = text_util.conv_to_str(code[last_idx : counter - length(found_op)])
                    to_put_type = identify_tok_type(to_put)

                    if strip(to_put) != ""

                        try_find_keyword = find_in_tupleLst(token.keywords_lst, to_put)

                        if try_find_keyword == (-1)

                            if length(fn_res) < 3
                                @goto failed_conds
                            end

                            conds = [
                                        to_put_type == token.INTEGER,
                                        text_util.enum_compare(fn_res[length(fn_res)].type_, token.DOT),
                                        text_util.enum_compare(fn_res[length(fn_res) - 1].type_, token.INTEGER)
                                    ]

                            if conds[1] && conds[2] && conds[3]

                                double_to_put = string(fn_res[length(fn_res) - 1].value,
                                                       fn_res[length(fn_res)].value,
                                                       to_put)

                                pos_to_put    = token.Position(curr_pos.line,
                                                (fn_res[length(fn_res) - 1].pos.start_end_cols[1],
                                                fn_res[length(fn_res) - 1].pos.start_end_cols[1] +
                                                length(fn_res[length(fn_res) - 1].value) + 1 + length(to_put) - 1))

                                push!(fn_res, token.Token(double_to_put, token.DOUBLE,
                                                          pos_to_put))

                                deleteat!(fn_res, length(fn_res) - 2)
                                deleteat!(fn_res, length(fn_res) - 1)

                            else

                                @label failed_conds

                                pos_to_put = token.Position(ln_counter,
                                    (counter - lines_colsAmnt_accum - length(to_put),
                                     counter - lines_colsAmnt_accum - 1)
                                )

                                push!(fn_res, token.Token(to_put, to_put_type, pos_to_put))
                            end

                        else
                            pos_to_put = token.Position(ln_counter,
                                (counter - lines_colsAmnt_accum - length(to_put),
                                 counter - lines_colsAmnt_accum - 1)
                            )

                            push!(fn_res, token.Token(to_put, token.keywords_lst[try_find_keyword][2], pos_to_put))
                        end

                    end

                    if strip(found_op) != "" || found_op == "\n"
                        tok_type = token.Tok_Types_Defs[find_in_tupleLst(token.Tok_Types_Defs,
                                                                         found_op)][2]

                        if !(tok_type in [token.LINE_CONTINUATION, token.SEMI_COLUMN])

                            if tok_type == token.EOL

                                special_last_chars = [',', '\\']
                                other_conds        = [state_machine.opnd_paren_amount   <= 0,
                                                      state_machine.opnd_bracket_amount <= 0]

                                push!(raw_lines_lst, ln_accum)
                                ln_accum = ""

                                if !(last_char in special_last_chars) && other_conds[1] && other_conds[2]
                                    push!(fn_res, token.Token("\n", token.EOL, token.Position(-1, (-1, -1))))
                                                                # No Position attribute is needed
                                                                # for EOL token.
                                end

                                ln_counter           += 1
                                lines_colsAmnt_accum += counter - lines_colsAmnt_accum

                            else
                                push!(fn_res, token.Token(found_op, tok_type,
                                                          token.Position(curr_pos.line,
                                                          (curr_pos.start_end_cols[1],
                                                           curr_pos.start_end_cols[1] + length(found_op) - 1))))
                            end

                        elseif tok_type == token.SEMI_COLUMN
                            push!(fn_res, token.Token("\n", token.EOL, token.Position(-1, (-1, -1))))
                        end

                    end

                    counter += length(found_op) - 1
                    last_idx = counter + length(found_op)
                end
            end

            counter += 1
        end

        return (fn_res, raw_lines_lst)
    end

end
