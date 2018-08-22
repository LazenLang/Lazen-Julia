module start_modules
    include("../tokenizing/token.jl")
    include("../analysis/tok_analysis.jl")
    include("../text_util.jl")

    function go(code)
        tokens = token.go(code)

        if !(tok_analysis.go(tokens[1], -1, tokens[2]))
            return
        end

        for (index, x) in enumerate(tokens[1])
            for x2 in x
                println(x2)
            end
            println("---------")
        end

    end

end
