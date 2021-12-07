module CalcPersistence

using SQLite: sqlserialize
using SQLite
using DataFrames

# function detectCount()
#     r = DBInterface.execute(DB, "SELECT id FROM formulas") |> DataFrame
#     return maximum(r.id) + 1
# end

DB = SQLite.DB("test_db.db")
# counter = detectCount()

function init()
    global DB
    DBInterface.execute(DB, """
        CREATE TABLE IF NOT EXISTS formulas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            formula_str TEXT
        )
    """)
    # DBInterface.execute(DB, "INSERT INTO formulas (formula_str) VALUES ('x squared')")
    # r = DBInterface.execute(DB, "SELECT * FROM formulas") |> DataFrame
    # println(r[!, 2][end])
end

function getFormula(id::Int)
    r = DBInterface.execute(DB, "SELECT formula_str FROM FORMULAS WHERE id = ?", (id,)) |> DataFrame
    return r[!, 1][1]
end

function getFormula(formula::String)
    r = DBInterface.execute(DB, "SELECT formula_str FROM FORMULAS WHERE formula_str = ?", (formula,)) |> DataFrame
    return r[!, 1][1]
end


function getAllFormulas()
    r = DBInterface.execute(DB, "SELECT formula_str FROM formulas") |> DataFrame
    return r[!, 1]
end

function insertFormula(formula)
    if formula in getAllFormulas()
        return false
    end
    DBInterface.execute(DB, "INSERT INTO formulas (formula_str) VALUES (?)", (formula,))
    true
end

function removeFormula(formula::String)
    DBInterface.execute(DB, "DELETE FROM formulas WHERE formula_str = ?", (formula,))
end

function removeFormula(id::Int)
    DBInterface.execute(DB, "DELETE FROM formulas WHERE id = ?", (id,))
end


# init()
# println(getFormula("x squared"))
# println(detectCount())

end #module