module ClientPersistence

using Redis
using JSON3

CON = RedisConnection()

function addBody(body_str)
    json = JSON3.read(body_str)
    sys_name = JSON3.write(json["sys_name"])[2:end-1]
    bodies = JSON3.write(json["bodies"])
    println(sys_name)
    all_systems = lrange(CON, "systems", 0, -1)
    sys_name ∉ all_systems && lpush(CON, "systems", sys_name)
    set(CON, sys_name, bodies)
end


function getSystems()
    return lrange(CON, "systems", 0, -1)
end


end #module