module tok_preprocess
    include("../text_util.jl")

    function go(tok_lst)
        res, counter, clsingparns_toput = [], 1, 0
        for (index, i) in enumerate(tok_lst)
            if counter > length(tok_lst)
                break
            end

            element = string(tok_lst[counter])
            if element == "#"; break; end

            after_me, double_op_lst = "", ["+=", "-=", "*=", "/=", "^=", "%=",
                                           "!=", "==", ">=", "<=", "&=", "&&", "||", ":¨", "§§"]

            en_keywords, spcial_keywords = ["or", "in", "not", "and", "is", "isnt"],
                                           [
                                                "if",
                                                "for",
                                                "while",
                                                "switch",
                                                "func",
                                                "else",
                                                "elif",
                                                "case",
                                                "return",
                                                "goto",
                                                "label",
                                                "end",
                                                "continue",
                                                "import",
                                                "print",
                                                "new",
                                                "var"
                                           ]

            keywords_match = ["||", "§§", ":¨", "&&", "==", "!="]

            if counter < length(tok_lst)
                after_me = string(tok_lst[counter + 1])
            end

            if text_util.lst_contains(double_op_lst, string(element, after_me)) && !(text_util.lst_contains(double_op_lst, string(element)))
                push!(res, string(element, after_me))
                counter += 2
                continue
            end

            if text_util.lst_contains(en_keywords, lowercase(element))
                push!(res, keywords_match[text_util.lst_find(en_keywords, lowercase(element))])
                counter += 1
                continue
            end

            if text_util.check_if_type(element, "identifier") && after_me == "(" && element != "@"
                push!(res, element)
                push!(res, "@")
                counter += 1
                continue
            end

            if text_util.lst_contains(spcial_keywords, lowercase(element)) && after_me != "("
                push!(res, element)
                push!(res, "@")
                push!(res, "(")
                clsingparns_toput += 1
                counter += 1
                continue
            end

            if strip(element) != ""
                push!(res, element)
            end

            counter += 1
        end

        for x = 1:clsingparns_toput
            push!(res, ")")
        end

        return res
    end

end
