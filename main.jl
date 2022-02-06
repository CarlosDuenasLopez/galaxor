using Mongoc

## Setup

function main()
    println("starting")
    client = Mongoc.Client("mongo")
    Mongoc.ping(client)
    println("done")
    # database = client["optional_topics"]
    
    # all_topics = database["topics"]
    # terms = database["terms"]
    # students = database["students"]
    
    # topics_document = Mongoc.BSON()
    # topics_document["topics"] = ["Deutsch", "Englisch", "Mathe"]
    # push!(all_topics, topics_document)
end
client = Mongoc.Client("mongodb://mongo:27017")
database = client["optional_topics"]

all_topics = database["topics"]
terms = database["terms"]
students = database["students"]

topics_document = Mongoc.BSON()
topics_document["topics"] = ["Deutsch", "Englisch", "Mathe"]
push!(all_topics, topics_document)
