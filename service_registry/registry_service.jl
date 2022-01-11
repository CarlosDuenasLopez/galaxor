module RegistryService

using ..RegistryPersistence

function getValidPorts(service_name)
    ps = RegistryPersistence.getValidPorts(service_name)
    return ps
end

function registerNew(name)
    println("REGISTERING $name")
    r = RegistryPersistence.registerNew(name)
    println("PORT: ", r)
    return r
end

end # module