module tok_modif
    include("../info.jl")
    include("../text_util.jl")
    # This module will modify the token list to extend the syntax possibilities of the language. #

    function go(tok_lst) # In this function we're modifying the token list. (The function returns the modified token list)

        fn_res = [] # Final result

        for x in tok_lst # x = the token list of the current line

            current_res = [] # The current result of the line's tokenizing (can support multiple tokenizing lists).
            line, brk_nxt, idx_save = [], false, 1 # Idx_save is used at line ~30

            if length(x) > 0
                if string(x[length(x)-1].value) == "."
                     x = x[1 : length(x)-2] # We remove the two last elements from x (list)
                     push!(x, info._token("\n", "unk")) # We add a new line to x
                end
            end

            index = 1 # I declare this as a variable because we will need to increment it on the for-loop.

            for x2_useless in enumerate(x)
                x2 = info._token("", "unk") # When I put "unk" intentionally on a variable of
                                            # type _token, it means it's value isn't initialized
                                            # yet.
                println("hey, i'm ", x2_useless)

                try
                    x2 = x[index]
                catch ex
                    if isa(ex, BoundsError) # Bounds error, it means the index integer
                        println("bounds")
                        break               # is greater than the size of x. Then
                    end                     # we have to break immediately.
                end

                nxt_elem = info._token("", "unk")
                try
                    nxt_elem = x[index + 1] # We try to save the next element
                                            # in a try catch (to avoid errors),
                                            # I know it is not a very elegant way to do this...
                catch ex
                end

                ########################################################################################

                if string(nxt_elem.value) == "=" # While x2 is the current element
                    usable_symb, continue_yn = ["+", "-", "*", "/", "=", "!", "^", "%", "&", "<", ">"], false
                    # 'usable_symb' = the symbols that are usable for this situation

                    for browse_usymb in usable_symb
                        if string(x2.value) == browse_usymb

                            push!(line, info._token(string(string(x2.value), string(nxt_elem.value)), "psymb"))
                            # We push (x2 & nxt_elem) to the line token's list.

                            index += 2
                            continue_yn = true
                        end
                    end

                    if continue_yn
                        continue
                    end
                else
                    en_keywords = ["not", "in", "or", "and"] # List of Lazen's english keywords used for conditions
                    symb_match = [":¨", "§§", "||", "&&"] # Lazen programmers will be unable to use symbols to reference
                                                          # keywords : not, in

                                                          # But they will be able to use symbols to reference
                                                          # keywords : and, or

                    if text_util.lst_contains(en_keywords, string(x2.value))
                        symb_idx = text_util.lst_find(en_keywords, string(x2.value))
                        # The corresponding index in symb_match list.

                        push!(line, info._token(string(symb_match[symb_idx]), "psymb")) # Here we're pushing
                                                                                        # the symbol corresponding the keyword.

                        index += 1
                        continue
                    end

                end

                ########################################################################################

                if string(x2.value) == "#"
                    brk_nxt = true # Break on the next round, because comment symbol detected.
                                   # Then we stop tokenizing the line.
                    continue
                elseif string(x2.value) == ";"
                    push!(line, info._token("\n", "unk")) # Semicolon detected, we replace it with a new line.
                                                          # this will allow some things like that in Lazen :

                                                          # print("Hello, ");print("world !")

                                                          # This is a pretty good detail.
                                                          # It permits to reduce the amount of code lines of the source code.
                else
                    push!(line, info._token(x2.value, x2.vtype)) # Else, we just push the token to the line token's list.
                end

                if brk_nxt
                    break
                end

                index += 1
            end

            for (index, x3) in enumerate(line) # Here we convert every line's token list that contains
                                               # a newline token to multiple lines. Read lines 48 to 54.
                if string(x3.value) == "\n"
                    push!(fn_res, line[idx_save : index])
                    idx_save = index + 1
                end
            end

        end

        return fn_res
    end

end
