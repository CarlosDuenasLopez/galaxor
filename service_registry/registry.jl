module Registry

include("registry_persistence.jl")
using .RegistryPersistence
RegistryPersistence.init()

include("registry_service.jl")
using .RegistryService

include("registry_controller.jl")
using .RegistryController

RegistryController.run()

end # module