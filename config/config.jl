module Conifg
include("utils.jl")

include("config_service.jl")
using .ConfigService

include("config_controller.jl")
using .ConfigController

function run(port)
    ConfigController.run(port)
end

register("config")

end # module