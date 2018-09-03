module errors

    function get_err(id, provinfo = [])
        if id == "0001"
            return string("Unable to open file \"", provinfo[1], "\"...")
        elseif id == "0002"
            return string("File-path excepted.\nPlease provide a code-file's path as an argument for 'home/main.jl'...")
        elseif id == "0003"
            return string("Code line cannot start with a symbol. (Line : ", provinfo[1], ", Column : ", provinfo[2], ")")
        elseif id == "0004"
            return string("Unexcepted ", provinfo[1], " parenthesis. (Line : ", provinfo[2], ", Column : ", provinfo[3], ")\n",
            "There are/is ", provinfo[4], " useless ", provinfo[1], " parenthesis in the line.")
        elseif id == "0005"
            return string("Unclosed ", provinfo[1], " literal. (Line : ", provinfo[2], ", Column : ", provinfo[3], ")")
        elseif id == "0006"
            return string("Unauthorized symbol '", provinfo[1], "'. (Line: ", provinfo[2], ", Column : ", provinfo[3], ")")
        end
    end

    function pup_err(msg)
        println("\n\t\tAn error occured\n----------------------------------------------------\n\n", msg,
        "\n\n----------------------------------------------------\n")
        exit()
    end

end
