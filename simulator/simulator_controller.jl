module SimulatorController

using HTTP, JSON3
using ..SimulatorService

const ROUTER = HTTP.Router()


simulate(req) = SimulatorService.simulate(req.body)
HTTP.@register(ROUTER, "GET", "/simulator", simulate)

alive(req) = amAlive()
HTTP.@register(ROUTER, "GET", "/alive", alive)

function amAlive()
    true
end

function requestHandler(req)
    obj = HTTP.handle(ROUTER, req)
    return HTTP.Response(200, JSON3.write(obj))
end

function run(port)
    HTTP.serve(requestHandler, "0.0.0.0", port)
end
    
end