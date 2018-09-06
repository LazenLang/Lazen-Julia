module tok_analysis
    include("../text_util.jl")
    include("../info.jl")
    include("../errs/errors.jl")


    function go(tok_lst, line_n = -1, raw_toklst = [])
        if !(check_lit_cl(raw_toklst)); return false; end
        if !(check_parn_cl(tok_lst)); return false; end
        if !(check_inv_symbs(tok_lst)); return false; end
        return true
    end

    function check_lit_cl(raw_tok_lst)
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
                lit_type = "String"
                if opnd_chr; lit_type = "Char"; end

                errors.pup_err(errors.get_err("0005", [lit_type, index, opnd_idx]))
            end
        end

        return true
    end

    function check_parn_cl(tok_lst)
        for (index, x) in enumerate(tok_lst)
            opnd_parn, triggered_col, lens_accum, triggered = 0, [1, 1], 1, [false, false]
            for x2 in x
                if string(x2) == "(" || string(x2) == ")"
                    if string(x2) == "("
                        opnd_parn += 1
                        if !(triggered[1]) && opnd_parn != 0
                            triggered[1] = true
                            triggered_col[1] = lens_accum
                        end
                    elseif string(x2) == ")"
                        opnd_parn -= 1
                        if !(triggered[2]) && opnd_parn != 0
                            triggered[2] = true
                            triggered_col[2] = lens_accum
                        end
                    end
                end
                lens_accum += length(x2)
            end

            if opnd_parn != 0
                parn_type, amount, trigger_col = "closing", -1, -1

                if opnd_parn > 0
                    parn_type, amount = "opening", opnd_parn
                    trigger_col = triggered_col[1]
                else
                    amount = opnd_parn*-1
                    trigger_col = triggered_col[2]
                end

                errors.pup_err(errors.get_err("0004", [parn_type, index, trigger_col, amount]))
            end
        end

        return true
    end

    function check_inv_symbs(tok_lst)
        invalid_symbs, lens_accum = ["§", "¨", "\$", "@"], 1

        for (index, x) in enumerate(tok_lst)
            for x2 in x
                if !(text_util.check_if_type(x2, "str_lit")) && !(text_util.check_if_type(x2, "char_lit"))
                    for (index_x3, x3) in enumerate(x2)
                        if text_util.lst_contains(invalid_symbs, x3)
                            errors.pup_err(errors.get_err("0006", [x3, index, lens_accum]))
                        end
                        lens_accum += length(x3)
                    end
                else
                    lens_accum += length(x2)
                end
            end
        end

        return true
    end
end
