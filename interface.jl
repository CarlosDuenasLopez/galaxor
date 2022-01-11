using JSON
using JSON3
using HTTP
include("utils.jl")

function main()
    println("Welcome to Galaxor!")
    while true
        println("Add system [a], simulate existing one [s], or change configuration [c]?")
        answer = readline()
        if occursin("a", answer)
            println("Enter path of .json file:")
            path = readline()
            json_str = read(path, String)

            client_port = getServicePort("client")

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
                d = Dict("system"=>sys, "iterations"=>iterations, "dt"=>dt)
                body = JSON3.write(d)
                JSON3.read(body)
                sim_port = getServicePort("simulator")
                println(sim_port)
                address = "http://127.0.0.1:$(sim_port)/simulator"
                println(body)
                println(address)
                HTTP.get(address, [], body)
            else
                # print existing systems
            end
        elseif occursin("c", answer)
            println("Enter name of parameter to be changed or added or press enter to view current config")
            port = getServicePort("config")
            address = "http://localhost:$port/config"
            param = readline()
            if length(param) > 0
                println("Enter value for $param")
                value = readline()
                d = Dict(param=>value)
                body = JSON3.write(d)
                HTTP.post(address, [], body)
            else
                params = HTTP.get(address).body |> String |> JSON3.read |> Dict
                for key in keys(params)
                    println("$key: $(params[key])")
                end
                println("\n")
            end
        end
    end
end