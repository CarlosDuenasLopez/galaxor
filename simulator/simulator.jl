module Simulator
using HTTP

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

function register()
    try
        println("hi")
        resp = HTTP.post("http://localhost:8080/registry/simulator")
        port = parse(Int, String(resp.body))
        run(port)
    catch
        println("NO SERVICE REGISRY FOUND, starting Microservice on port 8081")
        run(8081)
    end
end

register()

end # module