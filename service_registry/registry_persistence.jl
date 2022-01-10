module RegistryPersistence

using DataFrames
using HTTP
using Redis

CON = RedisConnection()


function getValidPorts(name)
    ports = getPorts(name)
    valid_ports = []
    for p in ports
        try
            x = HTTP.get("http://localhost:$p/alive", retries=0)
            push!(valid_ports, p)
        catch
            lrem(CON, "ports", 0, p) # delete invalid port
        end
    end
    return valid_ports
end


function getPorts(name)
    clear_db(name)
    ports = parse.(Int, lrange(CON, name * "_services", 0, -1))
    return ports
end

function registerNew(name)
    clear_db(name)
    println("registering ", name)
    key = name * "_services"
    registered_ports = lrange(CON, "ports", 0, -1)
    port = 0
    for i in 10_000:60_000
        if string(i) ∉ registered_ports
            port = i
            break
        end
    end
    println("yo")
    rpush(CON, "ports", port)
    rpush(CON, key, port)
    return port
end


function clear_db(name)
    # remove database entries of services that are no longer active
    all_ports = lrange(CON, "ports", 0, -1)
    service_ports = lrange(CON, name * "_services", 0, -1)
    for p in all_ports
        try
            x = HTTP.get("http://localhost:$p/alive", retries=0)
        catch
            lrem(CON, "ports", 0, p) # delete invalid port
            lrem(CON, name * "_services", 0, p)
        end
    end
end

end # module