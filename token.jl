module token

include("text_util.jl")
include("info.jl")



struct _token
    value # Token's value (must be converted into String type if other type than String when using this struct)
    vtype # Token's type (string)
end

    function go(code) # This function will tokenize the code argument and return a list of list of tokens.
                      # the 'code' parameter should be a list of string representing the lines of a
                      # Lazen code.

        tok_res = [] # Here will be stored the result
                     # of the tokenizing of argument 'code'.

        for x in code

            ln_res = [] # Here will be stored the tokenizing
                        # result of the current line.

            (idx_save, x) = (1, string(x, "."))
            (opnd_str, opnd_chr, str_bld, chr_bld) = (false, false, "", "")


            for (index, x2) in enumerate(x)
                if x2 == '\"'
                    if opnd_str
                        push!(ln_res, _token(string(str_bld, "\""), "str")) # Note we append a last quote to str_bld.
                        str_bld, opnd_str, idx_save = "", false, index + 1
                        continue
                    else
                        opnd_str = true
                    end
                elseif x2 == '\''
                    if opnd_chr
                        push!(ln_res, _token(string(chr_bld, "\'"), "char")) # Note we append a last apostrophe to chr_bld.
                        chr_bld, opnd_chr, idx_save = "", false, index + 1
                        continue
                    else
                        opnd_chr = true
                    end
                end

                if opnd_str
                    str_bld = string(str_bld, x2) # Append the current character to str_bld
                    continue
                elseif opnd_chr
                    chr_bld = string(chr_bld, x2) # Append the current character to chr_bld
                    continue
                end

                if text_util.lst_contains(info.symb_lst, x2)# Check if the symbol list contains the current character.
                        v_tp = x[idx_save : index-1] # Value to add to ln_res

                        if !(strip(string(v_tp)) == "")
                            push!(ln_res, _token(v_tp, text_util.getType(v_tp)))
                        end
                        if !(strip(string(x2)) == "")
                            push!(ln_res, _token(x2, "psymb"))
                        end

                        idx_save = index + 1
                end

            end

            push!(tok_res, ln_res) # Yes, we do push a list in a list !


        end

        return tok_res

    end
end
