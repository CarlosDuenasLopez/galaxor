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
            add_sys()
        elseif occursin("s", answer)
            simulate()
        elseif occursin("c", answer)
            configure()
        end
    end
end

function simulate()
    println("Enter name of desired system or press enter to see available systems")
    sys = readline()
    if length(sys)>0
        d = Dict{Any, Any}("system"=>sys)
        println("Enter number of iterations")
        iterations = readline()
        if length(iterations)>0
            d["iterations"] = iterations
        end
        println("Enter time step size")
        dt = readline()
        if length(dt) >0
            d["dt"] = dt
        end
        body = JSON3.write(d)
        JSON3.read(body)
        address = get_address("simulator", "simulator")
        println(body)
        println(address)
        try
            HTTP.get(address, [], body)
        catch
            println("That did not work. Maybe check if system exists.")
        end
    else
        # print existing systems
        port = getServicePort("client")
        x = HTTP.get("http://127.0.0.1:$port/client")
        println("Systems currently registered:\n")
        println.(JSON3.read(String(x.body)))
        println("\n")
    end
end

function configure()
    println("Enter name of parameter to be changed or added or press enter to view current config")
    address = get_address("config", "config")
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

function add_sys()
    println("Enter path of .json file:")
    path = readline()
    try
        json_str = read(path, String)
    catch
        println("specified file not found.")
    end
    if verify_json(json_str)
        address = get_address("client", "add_body")
        println(json_str)
        HTTP.post(address, [], json_str, retries=0)
    else
        println("invalid json!\n")
    end
end


function verify_json(json_str)
    json = JSON3.read(json_str)
    if Set(keys(json)) != Set([:sys_name, :bodies])
        println(Set(keys(json)))
        return false
    end
    for b in json["bodies"]
        if Set(keys(b)) != Set([:posi, :velocity, :mass])
            return false
        end
    end
    true
end