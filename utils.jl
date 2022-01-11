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

function getServicePort(name)
    split(String(HTTP.get("http://localhost:8080/registry/$name").body)[2:end-1], ",")[1][2:end-1]
end