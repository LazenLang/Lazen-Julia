module tok_preprocess
    include("../text_util.jl")

    function go(tok_lst)
        res, counter = [], 1
        for (index, i) in enumerate(tok_lst)
            if counter > length(tok_lst)
                break
            end

            element = tok_lst[counter]
            after_me, double_op_lst = "", ["+=", "-=", "*=", "/=", "^=", "%=",
                                           "!=", "==", ">=", "<=", "&=", "&&", "||", ":¨", "§§"]
            if counter < length(tok_lst)
                after_me = tok_lst[counter + 1]
            end

            if text_util.lst_contains(double_op_lst, string(element, after_me)) && !(text_util.lst_contains(double_op_lst, string(element)))
                push!(res, string(element, after_me))
                counter += 2
                continue
            end

            push!(res, element)
            counter += 1
        end

        return res
    end

end
