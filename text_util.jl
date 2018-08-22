module text_util

    function lst_contains(lst, elem)
        for x in lst
            if string(x) == string(elem)
                return true
            end
        end

        return false
    end

    function str_contains(str, char)
        for x in str
            if string(x) == string(char)
                return true
            end
        end
        return false
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

end
