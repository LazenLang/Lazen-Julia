module parser
    include("../text_util.jl")
    include("../info.jl")
    declared_id = []

    function go(tok_lst) # This function will parse the token
                         # list and return the result as a String.

        (multiplication, addition, substraction, division, modulo, power, ampersand, comma, factorial, setvalue, greater,
    	smaller, compare, different, less_equal, greater_equal, plus_equal, divide_equal, mul_equal, minus_equal, pow_equal,
    	mod_equal, concatenate, func, and_op, or_op, not_op, in_op, func_first) = ([],[],[],[],[],[],[],[],[],[],[],[],[],[],
        [],[],[],[],[],[],[],[],[],[],[],[],[],[],[]) # Here we define every single list of operators indexes.
                                                      # (each list will contain the indexes where
                                                      # the concerned operator is on the line)

        for (index, x) in enumerate(tok_lst)
            find_idx = text_util.lst_find(info.op_lst, x) # We gonna get the index where the operator is located
            if find_idx != (-1) # If 'matching_op' (list of operators) contains the current token
                op = string(x)
                if op == "*"
                    push!(multiplication, index-1)
                end
            end
        end


    end

    go(["5", "+", "5"])

end
