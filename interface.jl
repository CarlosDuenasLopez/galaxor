using JSON3
using JSON
using HTTP

function main()
    println("Welcome to Galaxor!")
    while true
        println("Add system [a] or simulate existing one [s]?")
        answer = readline()
        if occursin("a", answer)
            println("Enter path of .json file:")
            path = readline()
            json_str = read(path, String)

            client_port = getClient()

            address = "http://127.0.0.1:$(client_port)/add_body"
            println(json_str)
            HTTP.post(address, [], json_str)
        elseif occursin("s", answer)
            println("Enter name of desired system or press enter to see available systems")
            sys = readline()
            if length(sys)>0
                println("Enter number of iterations")
                iterations = parse(Int, readline())
                println("Enter time step size")
                dt = parse(Int, readline())
                body = string(JSON.json(Dict("system"=>sys, "iterations"=>iterations, "dt"=>dt)))
                JSON3.read(body)
                sim_port = getSimulator()

                address = "http://127.0.0.1:$(sim_port)/simulator"
                println(body)
                HTTP.get(address, [], body)
            else
                # print existing systems
            end
        end
    end
end


function getSimulator()
    println(String(HTTP.get("http://localhost:8080/registry/simulator").body))
    split(String(HTTP.get("http://localhost:8080/registry/simulator").body)[2:end-1], ",")[1]
end


function getClient()
    split(String(HTTP.get("http://localhost:8080/registry/client").body)[2:end-1], ",")[1]
end