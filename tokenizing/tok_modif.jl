module tok_modif
    include("../text_util.jl")

    function go(tok_lst)
        fn_res = [] # Final result
        for x in tok_lst

            ln_res = [] # Line result
            counter = 1

            for x2_raw in x
                x2 = ""

                try
                    x2 = string(x[counter])
                catch ex
                    if isa(ex, BoundsError)
                        break
                    end
                end

                after_me = ""
                if counter < length(x)
                    after_me = string(x[counter + 1])
                end

                if after_me != ""
                    if after_me == "="

                        # +=, -=, &=, /=, *=, ^=, %=, !=, ==...
                        op_compt = ["+", "-", "/", "*", "^", "%", "&", "!", "="]
                        if text_util.lst_contains(op_compt, x2)
                            push!(ln_res, string(x2, "="))
                            counter += 2
                            continue
                        end

                    elseif string(x2) == "&" && after_me == "&"
                        push!(ln_res, "&&")
                        counter += 2
                        continue
                    elseif string(x2) == "|" && after_me == "|"
                        push!(ln_res, "||")
                        counter += 2
                        continue
                    end
                end

                if strip(string(x2)) != ""
                    push!(ln_res, string(x2))
                end

                counter += 1
            end

            push!(fn_res, ln_res)
        end

        return fn_res
    end

end
