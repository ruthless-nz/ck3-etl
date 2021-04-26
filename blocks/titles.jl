# Takes in our ck3_raw_parse dataframe and does the magic on it
# spits out three tables:
#     Landed titles, unique by landed_title_index
#     Landed_title_histor, a measure based thing based o nthe history events
#     Landed_title_claims, the claim type and the heirs to any title


println("Started titles Block...")
df2 = ck3_raw_parse[ck3_raw_parse.x1 .== "landed_titles", :]

gdf_title = groupby(df2[df2.x2 .== "landed_titles", :],:x3)

# due to grain types we will split this into three tables

# basic_info
landed_titles = DataFrame(
    landed_title_index = Int[]
    ,landed_title_key = String[]
    ,de_facto_liege = Int[]
    ,de_jure_liege = Int[]
    # ,de_jure_vassals = Int[]
    ,holder_char_id = Int[]
    ,name = String[]
    ,adjective = String[]
    ,prefix = String[]
    ,article = String[]
    ,date = String[]
    ,capital = String[]
    ,capital_barony = String[]
    ,theocratic_lease = String[]
    ,history_government = String[]
    ,coat_of_arms_id = Int[]
)
allowmissing!(landed_titles)

# The history
Landed_title_history =  DataFrame(
    landed_title_index = Int[]
    ,landed_title_key = String[]
    ,date = String[]
    ,event_id = Int[]
    ,event_type = String[]
)
allowmissing!(Landed_title_history)

# and the claimaints and heirs
Landed_title_claims = DataFrame(
    landed_title_index = Int[]
    ,landed_title_key = String[]
    ,claim_type = String[]
    ,character_id = Int[]
)
allowmissing!(Landed_title_claims)


for i = 1:length(gdf_title)
# We will need to Init the values here

# println(i)

de_facto_liege = missing
de_jure_liege = missing
# de_jure_vassals = missing
holder_char_id = missing
name = ""
adjective = ""
prefix = ""
article = ""
date =""
capital = ""
capital_barony = ""
theocratic_lease = ""
history_government = ""
coat_of_arms_id = missing
claim_type = ""
character_id = missing
event_type = ""
event_id = missing


# Get the title names
x = findall( x -> occursin("=", x), gdf_title[i].x3 )
if (length(x) == 1) == false

landed_title_index = parse(Int,gdf_title[i].x3[1])

# and the key
x = findall( x -> occursin("key=", x), gdf_title[i].x4 )
if length(x) != 0
    landed_title_key = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# de_facto_liege
x = findall( x -> occursin("de_facto_liege=", x), gdf_title[i].x4 )
if length(x) != 0
    de_facto_liege = parse(Int,split(gdf_title[i].x4[x[1]],"=")[end])
end

# de_jure_liege
x = findall( x -> occursin("de_jure_liege=", x), gdf_title[i].x4 )
if length(x) != 0
    de_jure_liege = parse(Int,split(gdf_title[i].x4[x[1]],"=")[end])
end

# holder_char_id
x = findall( x -> occursin("holder=", x), gdf_title[i].x4 )
if length(x) != 0
    # holder_char_id = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
    holder_char_id =parse(Int,split(gdf_title[i].x4[x[1]],"=")[end])
end

# name
x = findall( x -> occursin("name=", x), gdf_title[i].x4 )
if length(x) != 0
    name = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# adjective
x = findall( x -> occursin("adjective=", x), gdf_title[i].x4 )
if length(x) != 0
    adjective = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# prefix
x = findall( x -> occursin("prefix=", x), gdf_title[i].x4 )
if length(x) != 0
    prefix = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# article
x = findall( x -> occursin("article=", x), gdf_title[i].x4 )
if length(x) != 0
    article = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# date
x = findall( x -> occursin("date=", x), gdf_title[i].x4 )
if length(x) != 0
    date = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# capital
x = findall( x -> occursin("capital=", x), gdf_title[i].x4 )
if length(x) != 0
    capital = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# capital_barony
x = findall( x -> occursin("capital_barony=", x), gdf_title[i].x4 )
if length(x) != 0
    capital_barony = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# theocratic_lease
x = findall( x -> occursin("theocratic_lease=", x), gdf_title[i].x4 )
if length(x) != 0
    theocratic_lease = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# history_government
x = findall( x -> occursin("history_government=", x), gdf_title[i].x4 )
if length(x) != 0
    history_government = replace(split(gdf_title[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# coat_of_arms_id
x = findall( x -> occursin("coat_of_arms_id=", x), gdf_title[i].x4 )
if length(x) != 0
    coat_of_arms_id = parse(Int,split(gdf_title[i].x4[x[1]],"=")[end])
end

push!(landed_titles,(
    landed_title_index
    ,landed_title_key
    ,de_facto_liege
    ,de_jure_liege
    # ,de_jure_vassals
    ,holder_char_id
    ,name 
    ,adjective 
    ,prefix 
    ,article
    ,date
    ,capital
    ,capital_barony
    ,theocratic_lease
    ,history_government
    ,coat_of_arms_id
))



# ok so we we want to look at Heirs
    x = findall( x -> occursin("heir=", x), gdf_title[i].x4 )

    claim_type = "heir"
    if length(x) > 0
        for k in split(split(gdf_title[i].x4[x[1]],"=")[end])

            if tryparse(Int, k) !== nothing
                character_id = parse(Int,k)
                push!(Landed_title_claims,(
                    landed_title_index
                    ,landed_title_key
                    ,claim_type
                    ,character_id
                ))
            end

        end
    end


# ok so we we want to look at and now claimaints
    x = findall( x -> occursin("claim=", x), gdf_title[i].x4 )
    claim_type = "claim"
    if length(x) > 0 
        for k in split(split(gdf_title[i].x4[x[1]],"=")[end])

            character_id = parse(Int,k)
            push!(Landed_title_claims,(
                landed_title_index
                ,landed_title_key
                ,claim_type
                ,character_id
            ))

        end
    end
end

# and now we look at history! Huzzah! 

# and now we look at history! Huzzah! 
hist = findall( x -> occursin("history=", x), gdf_title[i].x4 )
if length(x) > 0
    for x in hist
        for k in split(split(gdf_title[i].x4[x],"history=")[end])

        date = split(k,"=")[1]
        # println(k)
        if occursin("=", k) == true
            event_id = parse(Int,split(k,"=")[end])
        else 
            event_type = split(gdf_title[i].x6[x],"=")[end]
        end

        push!(Landed_title_history,(
        landed_title_index
        ,landed_title_key
        ,date
        ,event_id
        ,event_type
        ))

        end   
    end 
end


end

println("Finished Titles Block!")
# landed_titles
# Landed_title_claims
# Landed_title_history