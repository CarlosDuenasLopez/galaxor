module SimulatorPersistence

using JSON3
using Redis
using GeometryBasics
using ..SimulatorModel
CON = RedisConnection()

function getBodies(sys_name)
    json_str = get(CON, sys_name)
    println(json_str)
    json = JSON3.read(json_str)
    println(typeof(json), " TYPE")
    bodies = [json_to_body(body) for body in json]
    return bodies
end

function json_to_body(json)
    mass = json["mass"]
    velocity = json["velocity"]
    posi = json["posi"]
    return SimulatorModel.Body(Point(posi[1], posi[2], posi[3]), Point(velocity[1], velocity[2], velocity[3]), mass) # maybe splat...
end

end # module