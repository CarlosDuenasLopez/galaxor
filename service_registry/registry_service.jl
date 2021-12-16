module RegistryService

using ..RegistryPersistence

function getPorts(service_name)
    return RegistryPersistence.getPorts(service_name)
end

function registerNew(name)
    println("REGISTERING $name")
    return RegistryPersistence.registerNew(name)
end

end # module