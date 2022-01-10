module SimulatorController

using HTTP, JSON3
using ..RegistryService

const ROUTER = HTTP.Router()


simulate(req) = SimulatorService.simulate(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "GET", "/simulator/*", simulate)
    
end