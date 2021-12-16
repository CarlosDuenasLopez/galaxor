# calc_controller.jl

module CalcController
using HTTP: @register
using Revise

using HTTP, JSON3
using ..CalcService

const ROUTER = HTTP.Router()

getFormula(req) = CalcService.getFormula(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "GET", "/formula/*", getFormula)

newFormula(req) = CalcService.newFormua(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "POST", "/formula/*", newFormula)

getAll(req) =  CalcService.getAllFormulas()
HTTP.@register(ROUTER, "GET", "/formula/", getAll)

standard_resp(req) = CalcService.stdResp()
HTTP.@register(ROUTER, "GET", "/*", standard_resp)

alive(req) = amAlive()
HTTP.@register(ROUTER, "GET", "/alive", alive)

function amAlive()
    println("livin")
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