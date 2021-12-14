# calc_service.jl

module CalcService
using Revise
using ..CalcPersistence


function getFormula(req)
    if tryparse(Int, req) !== nothing
        return CalcPersistence.getFormula(parse(Int, req))
    else
        return CalcPersistence.getFormula(req)
    end
end

function getAll()
    CalcPersistence.getAllFormulas()
end

function test(req)
    return "jo"
end


function getAllFormulas()
    return CalcPersistence.getAllFormulas()
end

function stdResp()
    return "This route is not enabled"
end

# function callF()
    
# end

# function f()
#     return 2
# end

end # module