module RegistryPersistence

using SQLite: register
using SQLite
using DataFrames
using HTTP

REG_DB = SQLite.DB("regsitry_db.db")


function init()
    DBInterface.execute(REG_DB, """
    CREATE TABLE IF NOT EXISTS services (name varchar(30), port integer)
    """)
    # DBInterface.execute(REG_DB, """
    # INSERT INTO services VALUES ('test_service', 10400);
    # """)
    # regsiterNew("another_test")
end

function getPorts(name)
    result = DBInterface.execute(REG_DB, """
    SELECT port FROM services
    WHERE name = ?
    """, (name,)) |> DataFrame
    valid_ports = []
    for p in result.port
        try
            x = HTTP.get("http://localhost:$p/alive", retries=0)
            push!(valid_ports, p)
        catch
            del_row(p)
        end
    end
    valid_ports
end

function del_row(port)
    DBInterface.execute(REG_DB, """
    DELETE FROM services WHERE port = ?
    """, (port,))
end

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

end # module