module RegistryPersistence

using HTTP
using Redis

function connect_redis()
    println("connecting")
    if "MYREDIS" in keys(ENV)
        try
            add, port = split(ENV["MYREDIS"], ":")
        catch
            println(ENV["MYREDIS"])
            return RedisConnection(host=ENV["MYREDIS"])
        end
        println(add)
        return RedisConnection(host=add, port=port)
    end
    return RedisConnection()
end

CON = RedisConnection(host="redis")


function registerNew(name)
    ports = parse.(Int, hkeys(CON, "ports"))
    port = 0
    for i in 10_000:60_000
        if i ∉ ports
            port = i
            break
        end
    end
    hset(CON, "ports", port, name)
    return port
end


function getValidPorts(name)
    ports = hkeys(CON, "ports")
    valids = []
    for p in ports
        if hget(CON, "ports", p) == name
            try
                HTTP.get("http://localhost:$p/alive", retries=0)
                push!(valids, p)
            catch
                hdel(CON, "ports", p)
            end
        end
    end
    return valids
end

end # module