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


### Painter
Visualizes the results of the Simulation and displays the results to the user via gifs or on a webpage.


---
## Current status
Thus far there is a working service registry and a single microservice.
The Calculator Microservice has no functionality as of now, aside from entering new entries into a database.

The registry always runs on port 8080

Each Microservice registers at the Registry with the following function:
```Julia
function register()
    try
        resp = HTTP.post("http://localhost:8080/registry/calculator")
        port = parse(Int, String(resp.body))
        run(port)
    catch
        println("NO SERVICE REGISTRY FOUND, starting Microservice on port 8081")
        run(8081)
    end
end
```

On the registry side, for any POST request to /registry/*some_name*
*some_name* is passed to this function:

```Julia
function registerNew(name)
    registered = DBInterface.execute(REG_DB, """
        SELECT port FROM services
    """) |> DataFrame
    registered = registered.port
    port = 0
    for i in 10_000:60_000
        if i ∉ registered
            port = i
            break
        end
    end
    DBInterface.execute(REG_DB, """
    INSERT INTO services VALUES (?, ?);
    """, (name, port))
    return port
end
```
which returns a port that is currently available.

---
GET requests to /registry/*some_name* return all ports on which a microservice with *some_name* runs. What name a microservice has is determined by its ```register``` function. ("calculator" in the above example)

## The Database
All data is stored in redis.

### Structure:
- LIST "ports": A list of all ports
- LISTS *serviceName*_services ports on which a *serviceName* runs
- LIST "systems" list of all registered systems of celestial bodies