# Client_service.jl

module ClientService
using Base: String
using ..ClientPersistence


function stdResp()
    return "This route is not enabled"
end

function addBody(req)
    system_str = (String(req.body))
    ClientPersistence.addBody(system_str)
end

function getBodies()
    return ClientPersistence.getSystems()
end

function system_list()
    return ClientPersistence.getSystems()
end


end # module