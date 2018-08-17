module mainf

include("text_util.jl")
include("token.jl")

    function main()
        r_file = open("code.txt", "r") # Read the code.txt file
        code = readlines(r_file) # Save his lines (list of String)

        for x in token.go(code)
            for x2 in x[1 : length(x)-1] # We remove the last token that were added (.)
                println("[", x2.value, " / ", x2.vtype, "]")
            end
            println("----------")
        end
    end


    main()
end
