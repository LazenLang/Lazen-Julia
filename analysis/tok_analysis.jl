module tok_analysis
    include("../text_util.jl")
    include("../info.jl")
    include("../errs/errors.jl")


    function go(tok_lst, line_n = -1, raw_toklst = []) # Returns a boolean if everything is OK on the provided token list.

        if !(check_litcl(raw_toklst))
            return
        end

        for (index, x) in enumerate(tok_lst)
            opnd_parn, line_num = 0, line_n

            if line_num == -1
                line_num = index
            end

            for (index_ln, x2) in enumerate(x)

                if !(string(x2) == " ") && !(string(x2) == "\t") && text_util.lst_contains(info.symb_lst, string(x2)) && index_ln == 1
                    errors.pup_err(errors.get_err("0003", [line_num, index_ln]))
                end

                if x2 == "("
                    opnd_parn += 1
                elseif x2 == ")"
                    opnd_parn -= 1
                end

            end

            ############################

            if opnd_parn != 0
                if opnd_parn < 0
                    amount_parn = opnd_parn * -1 # We convert from negative number to positive number
                    errors.pup_err(errors.get_err("0004", [line_num, amount_parn]))
                elseif opnd_parn > 0
                    amount_parn = opnd_parn
                    errors.pup_err(errors.get_err("0005", [line_num, amount_parn]))
                end
            end

            ############################



        end

        return true
    end

    function check_litcl(raw_tok_lst)
        for (index, x) in enumerate(raw_tok_lst)
            opnd_idx, idx_incr, opnd_str, opnd_chr = 1, 1, false, false

            for x2 in x
                if string(x2) == "\"" || string(x2) == "\'"
                    if string(x2) == "\"" && !(opnd_chr)
                        if !(opnd_str)
                            opnd_idx = idx_incr
                            opnd_str = true
                        else
                            opnd_str = false
                        end
                    elseif string(x2) == "\'" && !(opnd_str)
                        if !(opnd_chr)
                            opnd_idx = idx_incr
                            opnd_chr = true
                        else
                            opnd_chr = false
                        end
                    end
                end
                idx_incr += length(x2)
            end

            if opnd_str || opnd_chr
                lit_type = ""

                if opnd_chr
                    lit_type = "Char"
                else
                    lit_type = "String"
                end

                errors.pup_err(errors.get_err("0006", [lit_type, index, opnd_idx]))
            end
        end

        return true
    end

end
