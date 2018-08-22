module errors # This module will manage Lazen programs' errors.

    function get_err(id, provinfo = []) # 'provinfo' argument = provided information
        if id == "0001"
            return string("Unable to open file \"", provinfo[1], "\"...")
        elseif id == "0002"
            return string("File-path excepted.\nPlease provide a code-file's path as an argument for 'home/main.jl'...")
        elseif id == "0003"
            return string("Code line cannot start with a symbol. (Line : ", provinfo[1], ", Column : ", provinfo[2], ")")
        elseif id == "0004"
            return string("Unexcepted closing parenthesis. (Line : ", provinfo[1], ", Column : unspecified)\n",
            "There are/is ", provinfo[2], " useless closing parenthesis in the line.")
        elseif id == "0005"
            return string("Unexcepted opening parenthesis. (Line : ", provinfo[1], ", Column : unspecified)\n",
            "There are/is ", provinfo[2], " useless opening parenthesis in the line.")
        elseif id == "0006"
            return string("Unclosed ", provinfo[1], " literal. (Line : ", provinfo[2], ", Column : ", provinfo[3], ")")
        end
    end

    function pup_err(msg)
        println("\n\t\tAn error occured\n----------------------------------------------------\n\n", msg,
        "\n\n----------------------------------------------------\n")
        exit()
    end

end
