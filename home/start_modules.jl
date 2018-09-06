module start_modules
    include("../tokenizing/token.jl")
    include("../tokenizing/tok_preprocess.jl")
    include("../analysis/tok_analysis.jl")
    include("../analysis/ast_analysis.jl")
    include("../text_util.jl")
    include("../parsing/ast_build.jl")

    function go(code)
        t0 = time_ns()
        println("Compilation started...")

        tokens = token.go(code)
        if !(tok_analysis.go(tokens[1], -1, tokens[2])); return; end

        for (index, x) in enumerate(tokens[3])
            println("tok: ", x)
            build_ast = ast_build.go(x)
            println("ln ", index, "\n", build_ast)
            println("---------")
        end

        t1 = time_ns()
        println("Compilation ended. Time taken in second is ", (t1 - t0) / 1000000000)
        println("parsed")

        println("finished")
    end
end
