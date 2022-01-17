module Simulator
using HTTP


include("utils.jl")

include("simulator_model.jl")
using .SimulatorModel

include("simulator_persistence.jl")
using .SimulatorPersistence

include("simulator_service.jl")
using .SimulatorService

include("simulator_controller.jl")
using .SimulatorController

function run(port)
    SimulatorController.run(port)
end

register("simulator")

end # module