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
        # println("default tok lst: ", tok_lst)
        res, tok_lst = "", text_util.remove_parn(tok_lst, true) # tok_preprocess.go(text_util.rem_sp_from_lst(token.go([text_util.conv_to_str(text_util.remove_parn(tok_lst))])[1][1]))
        counter_compl, opnd_parn = 1, 0

        # println("tok_lst: ", tok_lst, " / original: ", text_util.remove_parn(tok_lst, true))

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

            if find_idx != (-1)
                op, c_cpl_rem = string(x), length(string(x))
                res_idx = index

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
            if text_util.lst_find(tok_lst, operator) in sorted_op_idx_lists[counter]
                if operator == "\$"; operator = "@"; end
                reParse, found_op = parse_expr(tok_lst, operator, sorted_op_idx_lists[counter]), true
                break
            end

        end
        # println("found_op: ", found_op)


        if !(found_op) && length(tok_lst) > 0
            reParse = text_util.conv_to_str(text_util.remove_parn(tok_lst, true))
        end

        return reParse
    end

    function parse_expr(expr, operator, operator_indexes) # 'expr' argument must be the token list
        res, idx_save = string(operator, "\n"), 1
        ast_parents = []
        push!(operator_indexes, length(expr))

        for (index, x) in enumerate(operator_indexes)
            x_modif = x
            # println("x_modif: ", x_modif)
            if index != length(operator_indexes); x_modif -= 1; end
            operand = text_util.get_slice_safe(expr, idx_save, x_modif, true)
            # println("operand: ", operand)
            # if length(operator) > 1 && index != 1 && length(operand) > 1; operand = text_util.get_slice_safe(operand, length(operator), length(operand), true); end

            if check_trigger(text_util.conv_to_str(operand))
                push!(ast_parents, [go(operand), true])
            else
                push!(ast_parents, [text_util.conv_to_str(operand), false])
            end

            idx_save = x + 1
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
                             "-", "+", "!", "@"]
        # println("operand to find type: ", operand, " / ", text_util.find_type(operand))
        if text_util.find_type(operand) != "str_lit" && text_util.find_type(operand) != "char_lit"
            # println("ok")
            if startswith(strip(operand), "(") && endswith(strip(operand), ")")
                return true
            end
            for x in trigger_operators
                # println("contains : ", x, " in ", operand)
                if text_util.str_contains(operand, x)
                    # println("found ", x)
                    return true
                end
            end
            # println("returned false, cannot find in ", operand)
        end

        return false
    end
end
