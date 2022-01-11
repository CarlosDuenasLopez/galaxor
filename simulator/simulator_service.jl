module SimulatorService
using ..SimulatorPersistence
using JSON3
using JSON

function simulate(body)
    println("yo")
    sys_name, iterations, dt = extract(body)
    bodies = SimulatorPersistence.getBodies(sys_name)
    posis = run_sim(iterations, bodies, dt)
    println(posis)
    return posis
end


function extract(body)
    body_str = String(body)
    read_json = JSON.parse(body_str)
    sys_name = read_json["system"]
    iterations = read_json["iterations"]
    dt = read_json["dt"]
    return sys_name, iterations, dt
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
    
end