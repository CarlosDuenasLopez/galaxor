# clientulator.jl

module Client

using HTTP

export ClientService, ClientController

include("client_persistence.jl")
using .ClientPersistence
ClientPersistence.init()

include("client_service.jl")
using .ClientService

include("client_controller.jl")
using .ClientController

function run(port)
    ClientController.run(port)
end

function register()
    try
        resp = HTTP.post("http://localhost:8080/registry/client")
        port = parse(Int, String(resp.body))
        run(port)
    catch
        println("NO SERVICE REGISRY FOUND, starting Microservice on port 8081")
        run(8081)
    end
end

register()
end