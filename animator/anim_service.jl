module AnimatorService
using JSON3
using JSON
using GLMakie
using GeometryBasics

function animate(body)
    println("ANIMATING")
    posis = extract_posis(body)
    vis(Vector.(posis), length(posis[1]))
end

function extract_posis(body)
    posi_str = String(body)
    posis = JSON.parse(posi_str)
    for planet in posis
        for ps in 1:length(planet)
            planet[ps] = Point(planet[ps]...)
        end
    end
    posis
end


function vis(posis, frames)
    println(posis)
    println(typeof(posis[1][1]))
    set_theme!(theme_black())
    fig = Figure(resolution = (1000, 1000))
    ax = Axis3(fig[1, 1], aspect = (1, 1, 1),
    limits = (-10f11/4, 10f11/4, -10f11/4, 10f11/4, -10f11/4, 10f11/4,))

    start_posis = [i[1] for i in posis]
    planets = Node(start_posis)
    colors = [:yellow, :blue, :white, :red, :orange]
    scatter!(ax, planets, color=colors, markersize=5000)
    tails = Vector{Node}()
    for (i, p) in enumerate(posis)
        push!(tails, Node([p[1]]))
        lines!(ax, tails[end], color=colors[i])
    end
    record(fig, "example.gif", 1:frames, framerate = 50) do frame
        for planet_idx in 1:length(posis)
            current_tail = tails[Int(planet_idx)][]
            push!(current_tail, posis[Int(planet_idx)][Int(frame)])
            if length(current_tail) > 50
                deleteat!(current_tail, 1)
            end
            start_posis[Int(planet_idx)] = posis[Int(planet_idx)][Int(frame)]
        end
        notify(planets)
        notify.(tails)
    end
end

end # module