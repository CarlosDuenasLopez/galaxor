module AnimatorController
using HTTP, JSON3
using ..AnimatorService

const ROUTER = HTTP.Router()

animate(req) = AnimatorService.animate(req.body)
HTTP.@register(ROUTER, "POST", "/animator", animate)

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