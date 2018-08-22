module mainf
    include("../errs/errors.jl")
    include("start_modules.jl")

    function main()
        stop_append = false
        code_file = ""

        for (index, x) in enumerate(ARGS)
            if startswith(x, "-")
                stop_append = true
            end
            if !(stop_append)
                code_file = string(code_file, x)
                if index < length(ARGS)
                    code_file = string(code_file, " ")
                end
            end
        end

        if strip(string(code_file)) == ""
            errors.pup_err(errors.get_err("0002"))
        end

        read_file = []
        try
            o_file = open(code_file, "r")
            read_file = readlines(o_file)
        catch
            errors.pup_err(errors.get_err("0001", [code_file]))
        end

        start_modules.go(read_file)
    end


    main()
end
