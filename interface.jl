using JSON3
using HTTP

function main()
    println("Welcome to Galaxor!")
    println("Do you want to enter a new system via a .json file [j] or manually [m]?")
    x = readline()
    if occursin("j", x)
        while true
            println("Enter path of json file:")
            path = readline()
            json_str = read(path, String)
            json = JSON3.read(json_str)
            println(json[1])
        end
    elseif occursin("m", x)
        println("What's the name of the system?")
        system_name = readline()
        println("Enter name for celestial body?")
        pname = readline()
        println("Enter position like *x, y, z* ex.: \"10, 0, 0\"")
    end
end