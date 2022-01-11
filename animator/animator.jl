module Animator
using HTTP

include("../utils.jl")

include("anim_model.jl")
using .AnimatorModel

include("anim_persistence.jl")
using .AnimatorPersistence

include("anim_service.jl")
using .AnimatorService

include("anim_controller.jl")
using .AnimatorController

function run(port)
    AnimatorController.run(port)
end

register("animator")

end # module