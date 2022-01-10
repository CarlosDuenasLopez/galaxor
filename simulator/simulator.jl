module Simulator

include("simulator_model.jl")
using .SimulatorModel

include("simulator_persistence.jl")
using .SimulatorPersitence

include("simulator_service.jl")
using .simulator_service

include("simulator_controller.jl")
using .Simulator_controller

SimulatorController.run()

end # module