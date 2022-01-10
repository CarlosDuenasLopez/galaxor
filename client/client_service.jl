# Client_service.jl

module ClientService
using Base: String
using Revise
using ..ClientPersistence


function getFormula(req)
    if tryparse(Int, req) !== nothing
        return ClientPersistence.getFormula(parse(Int, req))
    else
        return ClientPersistence.getFormula(req)
    end
end

function getAll()
    ClientPersistence.getAllFormulas()
end

function test(req)
    return "jo"
end


function getAllFormulas()
    return ClientPersistence.getAllFormulas()
end

function stdResp()
    return "This route is not enabled"
end



end # module