# clientulator.jl

module Client

using HTTP

export ClientService, ClientController

include("../utils.jl")

include("client_persistence.jl")
using .ClientPersistence

include("client_service.jl")
using .ClientService

include("client_controller.jl")
using .ClientController

function run(port)
    ClientController.run(port)
end

register("client")
end