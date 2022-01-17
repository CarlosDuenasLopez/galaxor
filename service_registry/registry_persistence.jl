module RegistryPersistence

using Redis: include
using HTTP
using Redis
include("utils.jl")

CON = connect_redis()


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