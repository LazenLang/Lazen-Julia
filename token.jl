module token

include("../text_util.jl")
include("../info.jl")
include("tok_preprocess.jl")
include("../analysis/tok_analysis.jl")
include("../errs/errors.jl")

    function go(code) # This function will tokenize the ptokenizingrovided code parameter and return a list of list of tokens.
                      # The 'code' parameter should be a list of string representing the lines of a
                      # Lazen code.

        fn_res = []
        fn_res_raw = []

        for x in code
            ln_res, ln_res_raw, idx_save, opnd_chr, opnd_str, build_str, x = [], [], 1, false, false, "", string(x, ".")


            for (index, x2) in enumerate(x)
                if text_util.lst_contains(info.symb_lst, string(x2))
                        if length(text_util.get_slice_safe(x, idx_save, index)) > 1
                            push!(ln_res_raw, text_util.get_slice_safe(x, idx_save, index-1))
                        end

                        push!(ln_res_raw, x2)

                        idx_save = index + 1
                end
            end

            for (index, x3) in enumerate(text_util.get_slice_safe(ln_res_raw, 1, length(ln_res_raw)-1, true))
                if string(x3) == "\"" || string(x3) == "\'"

                    if !(opnd_str) && !(opnd_str)
                        if index != length(text_util.get_slice_safe(ln_res_raw, 1, length(ln_res_raw)-1))
                             if !(text_util.lst_contains(ln_res_raw[1:length(ln_res_raw)-1][index:length(ln_res_raw[1:length(ln_res_raw)-1])], string(x3)))
                                push!(ln_res, string(x3))
                                continue
                            end
                        else
                            push!(ln_res, string(x3))
                            continue
                        end
                    end

                    if string(x3) == "\"" && !(opnd_chr)
                        if opnd_str
                            build_str = string(build_str, "\"")
                            push!(ln_res, build_str)
                            opnd_str, build_str = false, ""
                            continue
                        else
                            opnd_str = true
                        end
                    elseif string(x3) == "\'" && !(opnd_str)
                        if opnd_chr
                            build_str = string(build_str, "\'")
                            push!(ln_res, build_str)
                            opnd_chr, build_str = false, ""
                            continue
                        else
                            opnd_chr = true
                        end
                    end
                end

                if opnd_str || opnd_chr
                    build_str = string(build_str, x3)
                    continue
                end

                push!(ln_res, x3)
            end

            push!(fn_res_raw, text_util.get_slice_safe(ln_res_raw, 1, length(ln_res_raw)-1, true))
            push!(fn_res, ln_res)
        end

        return [fn_res, fn_res_raw]
    end

end
