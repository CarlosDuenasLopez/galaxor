module RegistryController

using HTTP: @register
using HTTP, JSON3
using ..RegistryService

const ROUTER = HTTP.Router()

getPorts(req) = RegistryService.getValidPorts(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "GET", "/registry/*", getPorts)

registerNew(req) = RegistryService.registerNew(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "POST", "registry/*", registerNew)

function requestHandler(req)
    obj = HTTP.handle(ROUTER, req)
    try
        return HTTP.Response(200, JSON3.write(obj))
    catch
        return HTTP.Response(400, "request failed")
    end
end

function run()
    println("starting registry on port 8080")
    HTTP.serve(requestHandler, "0.0.0.0", 8080)
end
end # module