module ast_build
    include("../text_util.jl")
    include("../info.jl")
    include("../tokenizing/tok_preprocess.jl")
    include("../tokenizing/token.jl")

    declared_id = []

    function go(tok_lst) # This function will parse the token
                         # list and return the result as a String.

        (multiplication, addition, substraction, division, modulo, power, ampersand, comma, factorial, setvalue, greater,
    	smaller, compare, different, less_equal, greater_equal, plus_equal, divide_equal, mul_equal, minus_equal, pow_equal,
    	mod_equal, concatenate, func, and_op, or_op, not_op, in_op, func_first) = ([],[],[],[],[],[],[],[],[],[],[],[],[],[],
        [],[],[],[],[],[],[],[],[],[],[],[],[],[],[]) # Here we define every single list of operators indexes.
                                                      # (each list will contain the indexes where
                                                      # the concerned operator is on the line)

        res, tok_lst = "", tok_preprocess.go(text_util.rem_sp_from_lst(token.go([text_util.conv_to_str(text_util.remove_parn(tok_lst))])[1][1]))
        counter_compl, opnd_parn = 1, 0

        println("tok_lst: ", tok_lst, " / original: ", text_util.remove_parn(tok_lst, true))

        for (index, x) in enumerate(tok_lst)
            counter_compl += length(x)
            find_idx = text_util.lst_find(info.op_lst, string(x))

            if string(x) == "("
                opnd_parn += 1
            elseif string(x) == ")"
                opnd_parn -= 1
            end

            if opnd_parn > 0
                continue
            end

            if find_idx != (-1) # If 'matching_op' (list of operators) contains the current token
                op, countcompl_rem = string(x), length(string(x))
                res_idx = counter_compl-countcompl_rem

                if op == "*"     ; push!(multiplication, res_idx)
                elseif op == "+" ; push!(addition, res_idx)
                elseif op == "-" ; push!(substraction, res_idx)
                elseif op == "/" ; push!(division, res_idx)
                elseif op == "%" ; push!(modulo, res_idx)
                elseif op == "^" ; push!(power, res_idx)
                elseif op == "&" ; push!(ampersand, res_idx)
                elseif op == "," ; push!(comma, res_idx)
                elseif op == "!" ; push!(factorial, res_idx)
                elseif op == "=" ; push!(setvalue, res_idx)
                elseif op == ">" ; push!(greater, res_idx)
                elseif op == "<" ; push!(smaller, res_idx)
                elseif op == "=="; push!(compare, res_idx)
                elseif op == "!="; push!(different, res_idx)
                elseif op == "<="; push!(less_equal, res_idx)
                elseif op == ">="; push!(greater_equal, res_idx)
                elseif op == "+="; push!(plus_equal, res_idx)
                elseif op == "/="; push!(divide_equal, res_idx)
                elseif op == "*="; push!(mul_equal, res_idx)
                elseif op == "-="; push!(minus_equal, res_idx)
                elseif op == "^="; push!(pow_equal, res_idx)
                elseif op == "%="; push!(mod_equal, res_idx)
                elseif op == "&="; push!(concatenate, res_idx)
                elseif op == "@" ; push!(func, res_idx)
                elseif op == "&&"; push!(and_op, res_idx)
                elseif op == "||"; push!(or_op, res_idx)
                elseif op == ":¨"; push!(not_op, res_idx)
                elseif op == "§§"; push!(in_op, res_idx)
                elseif op == "\$"; push!(func_first, res_idx)
                end

            end
        end

        sorted_op_lst, found_op, reParse = [ "\$", "=", ",", "&&", "||",
        ":¨", "==", "§§", "&=", "!=", "<=", ">=", "+=", "/=", "*=",
        "-=", "^=", "%=", ">", "<", "&", "+", "-", "%", "/", "*",
        "^", "@", "!" ], false, ""

        sorted_op_idx_lists = [ func_first, setvalue, comma, and_op,
            or_op, not_op, compare, in_op, concatenate, different,
            less_equal, greater_equal, plus_equal, divide_equal,
            mul_equal, minus_equal, pow_equal, mod_equal, greater,
            smaller, ampersand, addition, substraction, modulo,
            division, multiplication, power, func, factorial ]

        for (counter, x) in enumerate(sorted_op_lst)
            operator = string(x)
            erase_parn_preprcs = tok_preprocess.go(token.go([text_util.erase_btwn_parn(text_util.conv_to_str(tok_lst), false)])[1][1])
            if text_util.get_len_since(erase_parn_preprcs, text_util.lst_find(erase_parn_preprcs, operator)) in sorted_op_idx_lists[counter]
                if operator == "\$"; operator = "@"; end
                reParse, found_op = parse_expr(text_util.conv_to_str(tok_lst), operator, sorted_op_idx_lists[counter]), true
                break
            end
        end

        if !(found_op) && length(tok_lst) > 0
            reParse = text_util.conv_to_str(text_util.remove_parn(tok_lst, true))
        end

        return reParse
    end

    function parse_expr(expr, operator, operator_indexes)
        res, idx_save = string(operator, "\n"), 1
        ast_parents = []
        push!(operator_indexes, length(expr))

        for (index, x) in enumerate(operator_indexes)
            x_modif = x
            if index != length(operator_indexes); x_modif -= 1; end
            operand = text_util.get_slice_safe(expr, idx_save, x_modif)

            if length(operator) > 1 && index != 1; operand = text_util.get_slice_safe(operand, length(operator), length(operand)); end

            if check_trigger(operand)
                push!(ast_parents, [go(operand), true])
            else
                push!(ast_parents, [string(operand), false])
            end

            idx_save = x+1
        end

        for x in ast_parents
            if x[2]
                for x2 in split(x[1], "\n")
                    res = string(res, "\t", x2, "\n")
                end
            else
                res = string(res, "\t", x[1], "\n")
            end
        end

        if text_util.get_slice_safe(res, length(res)) == "\n"
            res = text_util.get_slice_safe(res, 1, length(res)-1)
        end

        return res
    end

    function check_trigger(operand)
        trigger_operators =  ["\$", "||", ":¨", "§§", "&&", "==",
                             "&=", "!=", "<=", ">=", "+=", "/=",
                             "*=", "-=", "^=", "%=" ,"=", ">",
                             "<", ",", "&", "^", "*", "/", "%",
                             "-", "+", "!", "(", ")", "@"]

        if text_util.find_type(operand) != "str_lit" && text_util.find_type(operand) != "char_lit"
            for x in trigger_operators
                if text_util.str_contains(operand, x); return true; end
            end
        end

        return false
    end
end
