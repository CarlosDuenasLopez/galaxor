using HTTP

function register(name)
    println("registering $name")
    if "ISDOCKER" not in keys(ENV)
        for i in 1:2
            try
                address = get_address("registry", "registry", name)
                println(address)
                resp = HTTP.post(address)
                port = parse(Int, String(resp.body))
                run(port)
            catch
            end
        end
        println("NO SERVICE REGISRY FOUND, starting Microservice on port 8081")
        run(8081)
    else
        run(80)
    end
end

function getServicePort(name)
    address = get_address("registry", "registry", name)
    split(String(HTTP.get(address).body)[2:end-1], ",")[1][2:end-1]
end

function connect_redis()
    println("connecting")
    if "INDOCKER" in keys(ENV)
        return RedisConnection(host="redis")
    end
    return RedisConnection()
end

function get_address(name, slashs...)
    if "INDOCKER" in keys(ENV)
        return name * join(slashs, "/")
    end
    port = getServicePort(name)
    return "http://localhost:$port/" * join(slashs, "/")
end