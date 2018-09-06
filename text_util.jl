module text_util
    include("info.jl")

    function lst_contains(lst, elem)
        for x in lst
            if string(x) == string(elem)
                return true
            end
        end

        return false
    end

    function lst_find(lst, elem) # Argument 'lst' can be anything that can be iterated
        for (index, x) in enumerate(lst)
            if string(x) == string(elem)
                return index
            end
        end

        return -1
    end

    function get_len_since(list, elem_n)
        accumulator = 1
        for (index, x) in enumerate(list)
            if index == elem_n
                return accumulator
            end
            accumulator += length(x)
        end
        return -1
    end

    function str_contains(str, elem)
        past = ""
        for x in str
            past = string(past, x)
            if endswith(past, elem)
                return true
            end
        end
        return false
    end

    function str_find(str, elem)
        past = ""
        for (index, x) in enumerate(str)
            if endswith(past, elem)
                return index - length(elem)
            end
            past = string(past, x)
        end
        return -1
    end

    function conv_to_str(input, mul_lst = false)
        res, res_lst = "", []
        if mul_lst
            for x in input
                for x2 in x
                    res = string(res, x2)
                end
                push!(res_lst, res)
                res = ""
            end
        else
            for x in input
                res = string(res, x)
            end
        end
        if mul_lst
            return res_lst
        end
        return res
    end

    function get_slice_safe(input, slicebeg, sliceend=-1, list_ret = false) # This function permits to carefully get the slice of a String.
                                                                            # It is made to avoid StringIndexError when indexing over utf8 strings.
            res, res_lst = "", []

            if sliceend == -1; sliceend = slicebeg; end

            for (index, x) in enumerate(input)
                if index >= slicebeg && index <= sliceend
                    if list_ret
                        push!(res_lst, x)
                    else
                        res = string(res, x)
                    end
                end
                if index == sliceend
                    break
                end
            end

            if list_ret
                return res_lst
            else
                return res
            end
    end

    function rem_empty_elems(lst)
        fn_res = []
        for x in lst
            if strip(string(x)) != ""
                push!(fn_res, x)
            end
        end
        return fn_res
    end

    function erase_btwn_parn(input, ret_lst = false) # This function
                                    # will erase the text between every parenthesis, including the parenthesis themselves.
                                    #'input' can be of  types String or List.
        res, opnd_parn_amount = [], 0

        for x in input
            if string(x) == "("
                opnd_parn_amount += 1
            elseif string(x) == ")"
                opnd_parn_amount -= 1
                push!(res, " ")
                continue
            end
            if opnd_parn_amount <= 0
                push!(res, x)
            else
                push!(res, " ")
            end
        end

        if ret_lst
            return res
        else
            return conv_to_str(res)
        end
    end

    function count_occurences(input, char)
        occurences = 0
        for x in input
            if string(x) == string(char)
                occurences += 1
            end
        end
        return occurences
    end

    function repeat_char(char, times)
        res = ""
        for x in 1:times
            res = string(res, string(times))
        end
        return res
    end

    function rem_sp_from_lst(lst)
        res = []
        for x in lst
            if string(x) != " "
                push!(res, string(x))
            end
        end
        return res
    end

    function remove_parn(input, ret_lst = false)
        beg_sp_amount = 0
        if count_occurences(input, "(") != count_occurences(input, ")")
            if count_occurences(input, "(") > count_occurences(input, ")")
                substract = count_occurences(input, "(") - count_occurences(input, ")")
                for x in 1:substract
                    splice!(input, length(input), ")")
                end
            else
                substract = count_occurences(input, ")") - count_occurences(input, "(")
                for x in 1:substract
                    splice!(input, 1, "(")
                end
            end
        end

        for x in input
            if string(x) == "("
                beg_sp_amount += 1
            else
                break
            end
        end

        for i in 1:beg_sp_amount
            if string(strip(erase_btwn_parn(input))) == ""
                input = get_slice_safe(input, 2, length(input)-1, ret_lst)
            else
                break
            end
        end

        if ret_lst
            return input
        else
            return conv_to_str(input)
        end
    end

    function str_to_lst(input)
        res = []
        for x in input
            push!(res, string(x))
        end
        return res
    end

    function check_if_type(input, _type = "str_lit")
        input = string(input)

        if _type == "str_lit" && startswith(input, "\"") && endswith(input, "\"")
            return true

        elseif _type == "char_lit" && startswith(input, "\'") && endswith(input,
            "\'") && length(input) >= 2 && length(input) <= 3
            return true

        elseif _type == "numeric" && occursin(r"^(0|[1-9][0-9]*)$", input)
            return true

        elseif _type == "identifier" && occursin(r"^(?![0-9])[a-zA-Z_0-9]*$", input)
            return true

        elseif _type == "operator" && lst_contains(info.op_lst, input)
            return true

        end

        return false
    end

    function find_type(input) # This function returns the type of the input

        if check_if_type(input, "str_lit"); return "str_lit"
        elseif check_if_type(input, "char_lit"); return "char_lit"
        elseif check_if_type(input, "numeric"); return "numeric"
        elseif check_if_type(input, "identifier"); return "identifier"
        elseif check_if_type(input, "operator"); return "operator"
        else; return "unk"; end

    end

end
