module token

    #--------------------------#
        include("../text_util.jl")
        include("../info.jl")
    #--------------------------#


    @enum token_type begin          # Token Types

    # Basic Token Types
        L_PARN           # (
        R_PARN           # )
        L_BRACKET        # [
        R_BRACKET        # ]
        COMMA            # ,
        DOT              # .
        APOSTROPHE       # '
        QUOTE            # "
        EOL              # End-Of-Line
        NUMERIC          # Integer Literal
        KEYWORD          # Don't confuse KEYWORD and IDENTIFIER types
        IDENTIFIER       # Identifier
        STR_LIT          # String Literal
        CHAR_LIT         # Char Literal

    # Operators
        ASSIGN_OP        # =
        EQ_OP            # ==
        GREATER_OP       # >
        CONCAT_OP        # &
        LESS_OP          # <
        PLUS_OP          # +
        MINUS_OP         # -
        DIVIDE_OP        # /
        MULT_OP          # *
        POW_OP           # ^
        MOD_OP           # %
        DIFF_OP          # !=
        GREATER_EQ       # >=
        LESS_EQ          # <=
        PLUS_EQ          # +=
        MINUS_EQ         # -=
        DIVIDE_EQ        # /=
        MULT_EQ          # *=
        POW_EQ           # ^=
        MOD_EQ           # %=
        CONCAT_EQ        # &=

    # Other
        OTHER            # Unidentified Tokens

    end

    #----------------------------#
        struct position                 # Struct covering a token's position
            line :: Integer
            col  :: Integer
        end

        struct Token
            value :: String         # Token Value
            _type :: token_type     # Token Type
            # pos   :: position       # Attributes : col, line
        end

        mutable struct Opened_Symbs_Status
            opnd_str_lit        :: Bool
            opnd_char_lit       :: Bool
            opnd_paren_amount   :: Integer
            opnd_bracket_amount :: Integer
        end
    #----------------------------#

    function find_in_DblOpLst(str :: String) :: token_type
        double_ops_equivalents = [PLUS_EQ, MINUS_EQ,
                                  DIVIDE_EQ, MULT_EQ,
                                  POW_EQ, MOD_EQ,
                                  EQ_OP, DIFF_OP,
                                  GREATER_EQ, LESS_EQ]
        return double_ops_equivalents[findfirst(info.double_op_lst .== str)]
    end

    # Identifies the type of a token's value.
    #-------------------------------------------#
        function identify_tok_type(str :: String) :: token_type
            if str == "\n"                                    ; return EOL

            elseif str == "("                                 ; return L_PARN
            elseif str == ")"                                 ; return R_PARN
            elseif str == "["                                 ; return L_BRACKET
            elseif str == "]"                                 ; return R_BRACKET
            elseif str == "\t"                                ; return TABULATION
            elseif str == "."                                 ; return DOT
            elseif str == ","                                 ; return COMMA
            elseif str == "'"                                 ; return APOSTROPHE
            elseif str == "\""                                ; return QUOTE
            elseif lowercase(str) in info.keywords_lst        ; return KEYWORD
            elseif occursin(r"^[0-9]*$", str)                 ; return NUMERIC
            elseif occursin(r"^(?![0-9])[a-zA-Z_0-9]*$", str) ; return IDENTIFIER
            elseif str in info.double_op_lst                  ; return find_in_DblOpLst(str)
            else                                              ; return OTHER

            end
        end
    #-------------------------------------------#



    function go(code::String) :: Array{Token} # Converts a code into a list of lexemes called 'Tokens'.
                                              # Takes a string, returns an array of tokens.

        symbs_status = Opened_Symbs_Status(false, false, 0, 0)
        """
            symbs_status indicates if
            a String or Char literal is
            actually opened.
        """

        build_literal = ""
        fn_res = [] # Final result of the lexer (Array{Token})
        counter, last_idx = 1, 1
        line_counter = 1

        """
            Here we will use the text_util.get_slice function because
            Julia is "special" in the indexing of some UTF-8 characters.
        """

        for _ in code
            if counter > length(code)
                break
            end

            #--------------------------#

                still_code = text_util.get_slice(code, counter, length(code))
                curr_char  = text_util.get_slice(code, counter)   # String representing the current character
                next_char  = ""                                   # String representing the next character

            #--------------------------#


            if counter < length(code)
                next_char = text_util.get_slice(code, counter + 1)         # Get the next character in the code
            end

            #---------------------------------------------------#

                """
                    This part constructs String and Char literals.
                """

                if curr_char == "\"" || curr_char == "'"

                    if curr_char == "\"" && !(symbs_status.opnd_char_lit)

                        if symbs_status.opnd_str_lit

                            push!(fn_res, Token(string(build_literal, "\""), STR_LIT))
                            counter += 1
                            last_idx = counter
                            build_literal, symbs_status.opnd_str_lit = "", false
                            continue

                        else

                            if occursin("\"", text_util.get_slice(still_code, 2, length(still_code)))
                                symbs_status.opnd_str_lit = true
                            else
                                push!(fn_res, Token("\"", QUOTE))
                                counter += 1
                                last_idx = counter
                                continue
                            end

                        end

                    elseif curr_char == "'" && !(symbs_status.opnd_str_lit)

                        if symbs_status.opnd_char_lit
                            push!(fn_res, Token(string(build_literal, "'"), CHAR_LIT))
                            counter += 1
                            last_idx = counter
                            build_literal, symbs_status.opnd_char_lit = "", false
                            continue

                        else
                            if occursin("'", text_util.get_slice(still_code, 2, length(still_code)))
                                symbs_status.opnd_char_lit = true
                            else
                                push!(fn_res, Token("'", APOSTROPHE))
                                counter += 1
                                last_idx = counter
                                continue
                            end
                        end

                    end

                end

            #---------------------------------------------------#


            #-------------------------------#

                """
                    Push coming characters to 'build_literal' variable if
                    a String or Char literal is actually opened.
                """

                if symbs_status.opnd_str_lit || symbs_status.opnd_char_lit
                    if counter < length(code)
                        build_literal = string(build_literal, curr_char)
                        counter += 1
                        continue
                    end
                end
            #-------------------------------#

            if curr_char == "("
                symbs_status.opnd_paren_amount += 1
            elseif curr_char == ")"
                symbs_status.opnd_paren_amount -= 1
            elseif curr_char == "["
                symbs_status.opnd_bracket_amount += 1
            elseif curr_char == "]"
                symbs_status.opnd_bracket_amount -= 1
            end

            #-------------------------------#

                """
                    This part checks if the combination of the current character and
                    the next character or only the current character is in the Lazen symbols list
                    or the Lazen operators list.
                """

                found_symb_or_op = Nothing
                vcat_lsts        = vcat(info.op_lst[2 : length(info.op_lst)],
                                        info.op_lst[1], info.symb_lst)

                """
                    Notice that we skip the first
                    element of the list here. The reason
                    of doing this is that we have to check in
                    the double operators first to avoid
                    taking the PLUS operator in PLUS ASSIGN
                    instead of taking the PLUS ASSIGN
                    operator (example).
                """

                if string(curr_char, next_char) in vcat_lsts
                    found_symb_or_op = string(curr_char, next_char)
                elseif curr_char in vcat_lsts
                    found_symb_or_op = curr_char
                end

            #-------------------------------#


            if found_symb_or_op != Nothing
                idOrNum_toPut = text_util.get_slice(code, last_idx, counter - 1)

                if strip(idOrNum_toPut) != ""
                    push!(fn_res, Token(idOrNum_toPut, identify_tok_type(idOrNum_toPut)))
                end

                if strip(found_symb_or_op) != "" || found_symb_or_op == "\n"

                    if found_symb_or_op == "\n"
                        get_symbs_status = [symbs_status.opnd_str_lit,
                                            symbs_status.opnd_char_lit,
                                            symbs_status.opnd_paren_amount > 0,
                                            symbs_status.opnd_bracket_amount > 0]

                        if length(findall(get_symbs_status)) == 0
                            push!(fn_res, Token(found_symb_or_op, identify_tok_type(found_symb_or_op)))
                        end

                        line_counter += 1
                    else
                        push!(fn_res, Token(found_symb_or_op, identify_tok_type(found_symb_or_op)))
                    end

                end

                counter += length(found_symb_or_op) - 1
                last_idx = counter + 1
            end

            counter += 1
        end

        return fn_res
    end

end
