module SimulatorService

using ..SimulatorPersistence
using JSON3
using HTTP
using Redis
using LinearAlgebra:norm

include("utils.jl")
CON = connect_redis()

function simulate(body)
    sys_name, iterations, dt = extract(body)
    bodies = SimulatorPersistence.getBodies(sys_name)
    posis = run_sim(iterations, bodies, dt)
    sendToAnimation(posis)
    return posis
end


function extract(body)
    body_str = String(body)
    read_json = JSON3.read(body_str)
    sys_name = getParam("system", read_json, "")
    iterations = parse(Int, getParam("iterations", read_json, "500"))
    dt = parse(Int, getParam("dt", read_json, "10000"))
    return sys_name, iterations, dt
end

function getParam(param, json, default)
    if param in keys(json)
        r = json[param]
    else
        r = hget(CON, "configuration", param)
        if r == nothing
            r = default
        end
    end
    return r
end


function sendToAnimation(posis)
    body = JSON3.write(posis)
    address = get_address("animator", "animator")
    try
        HTTP.post(address, [], body, retries=0)
    catch
        println("no animator online")
    end
end


function calc_f(particle, other)
    G = 6.67408f-11
    r = dist(particle, other)
    F = G * (particle.mass * other.mass) / r^2
    return F
end

function update_velocitiy!(particle, all_particles, dt)
    a_vec = [0, 0, 0]
    G = 6.67408f-11
    for other in all_particles
        if other != particle
            F = calc_f(particle, other)
            a = F / particle.mass
            connection_vector =  other.posi - particle.posi
            normed = connection_vector ./ norm(connection_vector)
            a_vec += normed .* a
        end
    end
    particle.velocity += a_vec .* dt
end


function step!(all_particles, dt)
    for p in all_particles
        update_velocitiy!(p, all_particles, dt)
    end
    for p in all_particles
        p.posi += p.velocity * dt
    end
end

function run_sim(iterations, bodies, dt)
    all_posis = [[] for _ in 1:length(bodies)]
    for i in 1:iterations
        for (i, a) in enumerate(bodies)
            push!(all_posis[i], a.posi)
        end
        step!(bodies, dt)
    end

    all_posis
end
   
function dist(p1, p2)
    ???sum((big.(p2.posi-p1.posi) .^ 2))
end


end # module