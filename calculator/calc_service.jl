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

end # module