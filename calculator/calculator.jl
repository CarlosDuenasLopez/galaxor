# calculator.jl

module Calculator

using HTTP

export CalcService, CalcController

include("calc_persistence.jl")
using .CalcPersistence
CalcPersistence.init()

include("calc_service.jl")
using .CalcService

include("calc_controller.jl")
using .CalcController

function run(port)
    CalcController.run(port)
end

function register()
    try
        resp = HTTP.post("http://localhost:8080/registry/calculator")
        port = parse(Int, String(resp.body))
        run(port)
    catch
        println("NO SERVICE REGISRY FOUND, starting Microservice on port 8081")
        run(8081)
    end
end

register()
end