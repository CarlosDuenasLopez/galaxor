module  SimulatorModel

using GeometryBasics
mutable struct Body
    posi::Point
    velocity::Point
    mass::Float64
end

end