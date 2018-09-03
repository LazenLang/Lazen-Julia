module start_modules
    include("../tokenizing/token.jl")
    include("../analysis/tok_analysis.jl")
    include("../analysis/ast_analysis.jl")
    include("../text_util.jl")
    include("../parsing/ast_build.jl")

    function go(code)
        tokens = token.go(code) # tokens[1] = modified token list | tokens[2] = raw token list
        if !(tok_analysis.go(tokens[1], -1, tokens[2])); return; end

        for (index, x) in enumerate(tokens[1])
            println("tok: ", x)
            build_ast = ast_build.go(x)
            println("ln ", index, "\n", build_ast)
            println("---------")
        end

    end
end
