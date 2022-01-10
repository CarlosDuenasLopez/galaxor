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

            client_ports = split(String(getClient().body)[2:end-1], ", ")[1]

            address = "http://127.0.0.1:$(client_ports)/add_body"
            println(address)
            HTTP.post(address, [], json_str)
        end
    elseif occursin("m", x)
        println("What's the name of the system?")
        system_name = readline()
        println("Enter name for celestial body?")
        pname = readline()
        println("Enter position like *x, y, z* ex.: \"10, 0, 0\"")
    end
end


function getClient()
    HTTP.get("http://localhost:8080/registry/client")
end