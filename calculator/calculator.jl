# calculator.jl

module Calculator

export CalcService, CalcController

include("calc_persistence.jl")
using .CalcPersistence

include("calc_service.jl")
using .CalcService

include("calc_controller.jl")
using .CalcController

function run()
    CalcController.run()
end

run()
end