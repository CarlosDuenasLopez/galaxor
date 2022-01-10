module RegistryService

using ..RegistryPersistence

function getValidPorts(service_name)
    ps = RegistryPersistence.getValidPorts(service_name)
    println("Ports: ", ps)
    return ps
end

function registerNew(name)
    println("REGISTERING $name")
    return RegistryPersistence.registerNew(name)
end

end # module