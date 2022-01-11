module ConfigController

using HTTP: @register
using HTTP, JSON3
using ..ConfigService

const ROUTER = HTTP.Router()

configure(req) = ConfigService.configure(String(req.body))
HTTP.@register(ROUTER, "POST", "/config", configure)

get_config(req) = ConfigService.get_config()
HTTP.@register(ROUTER, "GET", "/config", get_config)

alive(req) = true
HTTP.@register(ROUTER, "GET", "/alive", alive)

function requestHandler(req)
    obj = HTTP.handle(ROUTER, req)
    return HTTP.Response(200, JSON3.write(obj))
end

function run(port)
    HTTP.serve(requestHandler, "0.0.0.0", port)
end

end # module