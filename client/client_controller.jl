# client_controller.jl

module ClientController
using HTTP: @register
using Revise

using HTTP, JSON3
using ..ClientService

const ROUTER = HTTP.Router()

standard_resp(req) = ClientService.stdResp()
HTTP.@register(ROUTER, "GET", "/*", standard_resp)

add_body(req) = ClientService.addBody(req)
HTTP.@register(ROUTER, "POST", "/add_body", add_body)

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

end # module