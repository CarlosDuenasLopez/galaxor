# MVM - Galaxor



## About
---
Galaxor is an application for simulating and visuaizig dynamic systems of planets and stars such aus our solar system.

## How to run
- Install Julia from www.julialang.org
- Add julia to path (https://julialang.org/downloads/platform/)
- Enter the julia REPL by typing "julia" in the terminal
- Paste the following Script to install required depndencies:
```Julia
deps = ["HTTP", "JSON3", "Revise", "SQLite", "DataFrames"]
using Pkg
Pkg.add(deps)
```
- go to the 'service_registry' directory and run the registry by typing ```julia registry.jl```in the terminal
- navigate to the microservices you want to start and type ```julia *name_of_microservice*``` in the terminal

---

## The Microservices
### Client:

Lets the user enter configuration for different objects, such as planets and stars along with their position, velocity and mass


### Simulator
Reads planet configurations from the database and simulates their behaviour using Newton's law of general gravitation.


### Animator
Visualizes the results of the Simulation and displays the results to the user via gifs or on a webpage.


---
## Current status

The registry always runs on port 8080

Each Microservice registers at the Registry with the following function:
```Julia
function register(name)
    for i in 1:2
        try
            resp = HTTP.post("http://localhost:8080/registry/$name")
            port = parse(Int, String(resp.body))
            run(port)
        catch
        end
    end
    println("NO SERVICE REGISRY FOUND, starting Microservice on port 8081")
    run(8081)
end
```

On the registry side, for any POST request to /registry/*some_name*
*some_name* is passed to this function:

```Julia
function registerNew(name)
    ports = parse.(Int, hkeys(CON, "ports"))
    port = 0
    for i in 10_000:60_000
        if i ∉ ports
            port = i
            break
        end
    end
    hset(CON, "ports", port, name)
    return port
end
```
which returns a port that is currently available.

GET requests to /registry/*some_name* return all ports on which a microservice with *some_name* runs. What name a Microservice is registered as is determined by the paramter used when calling the register function. Client initializes with the following:
```Julia
include("../utils.jl")
register("client")
```

---

### **FUNCTIONALITY**

The user starts out using the ```interface.jl``` program. Upon running they are asked whether they wish to add a new system or run the simulation for one of the existing ones.

**Add a new system:**

The user is asked to provide the path to a json describing the new system. These JSONS has to be structured the following way:
```Json
{
    "sys_name":"solar",
    "bodies": [
        {"posi": [1, 1, 1], "velocity": [0, 0, 0], "mass":10}
        ]
}
```
When this is done successfully a POST request with the json as its body is sent to the client microservice. Here it is stored in the database accordingly


**Simulate an existing system:**

If the user wishes to run the simulation for an existing system they are asked to specify the following parameters:
- Name of the system to be simulated
- Number of iterations for simulation
- Timedelta

Once these have been provided, they are stored in a json-like string and sent to a simulator microservice via a REST call. Here the system is simulated within the given parameters. 

This simply generates the positions of the given bodies at the desired timesteps. 

Once this is finished, these positions are once again stored in a json-like string and sent to an animator microservice via another HTTP request.

This microservice then renders an animation of the simulation and stores it as a gif.

---

## The Database
All data is stored in redis.

### Structure:
- HASH "ports": Hashmap of KEY VALUE pairs like: port: service_name
- KEY VALUE pairs like: system_name: string_description_of_system
- LIST "systems": List of all system names