module RegistryService

using ..RegistryPersistence

function getValidPorts(service_name)
    ps = RegistryPersistence.getValidPorts(service_name)
    return ps
end

function registerNew(name)
    r = RegistryPersistence.registerNew(name)
    println("registering $name on port: ", r)
    return r
end

end # module