module ConfigService

using JSON3: include
using JSON3
using Redis

include("utils.jl")

CON = connect_redis()

function configure(body)
    json = JSON3.read(body)
    println(body)
    for key in keys(json)
        hset(CON, "configuration", key, json[key])
    end
end

function get_config()
    hgetall(CON, "configuration")
end

end # module