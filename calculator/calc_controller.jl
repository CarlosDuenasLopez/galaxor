# calc_controller.jl

module CalcController
using Revise

using HTTP, JSON3
using ..CalcService

const ROUTER = HTTP.Router()

getFormula(req) = CalcService.getFormula(HTTP.URIs.splitpath(req.target)[2])
HTTP.@register(ROUTER, "GET", "/formula/*", getFormula)


function requestHandler(req)
    obj = HTTP.handle(ROUTER, req)
    return HTTP.Response(200, JSON3.write(obj))
end

function run()
    HTTP.serve(requestHandler, "0.0.0.0", 8080)
end

end # module