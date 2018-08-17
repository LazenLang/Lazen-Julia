module text_util
    include("info.jl")

    function lst_contains(lst, elem)
        for x in lst
            if x == elem
                return true
            end
        end

        return false
    end

    function getType(input) # This function returns the actual type of input (represented as a String).
        types_lst = ["str", "char", "num", "psymb", "id"] # psymb = parsing symbol
        for x in types_lst
            if check_type(input, x)
                return x
            end
        end
        return "unk"
    end

    function check_type(input, _type) # This function returns true is the type of argument 'input'
                                      # is corresponding to the given type in argument '_type'.
        digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        if _type == "str" && startswith(string(input), "\"") && endswith(string(input), "\"")
            return true

        elseif _type == "char" && startswith(string(input), "\'") && endswith(string(input), "\'")
            return true # Here, notice we don't check the length of the char already,
                        # we're going to analyze it while parsing.

        elseif _type == "num"

            for x in input
                if !(lst_contains(digits, x))
                    return false
                end
            end

            return true

        elseif _type == "id"

            if length(input) > 0
                if (lst_contains(digits, input[1])) || (lst_contains(info.symb_lst, input[1]))
                    # The first character of the input mustn't be a digit or a symbol.
                    return false
                end
                if length(input) > 1
                    for x in input[1 : length(input)]
                        if lst_contains(info.symb_lst, x)
                            return false
                        end
                    end
                end
                return true
            end

        elseif _type == "psymb"
            if lst_contains(info.symb_lst, input)
                return true
            end
        end

        return false
    end

end
