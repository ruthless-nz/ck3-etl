
using DataFrames

f = open("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//gamestate.ck3")

lines = readlines(f)

close(f)

lines

# ok so here we are going to replace the brackets nd work off of tabs

# ok so lets loop through 

clean_lines = Array{String,1}(undef,length(lines))
depth = Array{Int,1}(undef,length(lines))

Tab_depth = 1

for i = 1:length(lines)

    clean_lines[i]= strip(replace(lines[i], ['\t','{','}'] => ""))  
    if length(clean_lines[i]) != 0
        if clean_lines[i][end] == '='
            clean_lines[i] =  clean_lines[i][1:end-1]
        end
    end  
    # depth[i] = count(i->(i=='\t'),lines[i] ) + 1
    depth[i] = Tab_depth

    # now check for brackets
    global Tab_depth = Tab_depth + count(i->(i=='{'),lines[i])
    global Tab_depth = Tab_depth - count(i->(i=='}'),lines[i])
end

unique(depth)
clean_lines
maximum(depth)
depth

clean_lines[504:509]
depth[504:509]



# ok so now create a temp array that is the max length of the the depth
temp = Array{ String,2}(undef, 1,maximum(depth))
fill!(temp, "")
table =  Array{Array,1}()

# now we do over the length  

for i = 1:length(lines)
    # check for null
    if clean_lines[i] !== ""
        temp[depth[i]] = clean_lines[i]
        # println(depth[i],temp[depth[i]])
    end

    # remove the entry prior if depth is descending
    if i != 1 && depth[i-1] > depth[i] 
        temp[depth[i-1]] = ""
    end
# cool, now we check if the print conditions are met
    if i !== length(lines) && i !== 1

        if depth[i] == depth[i+1] && depth[i] > depth[i-1] && clean_lines[i] !== ""
            push!(table,deepcopy(temp))
        elseif  depth[i] == depth[i-1] && depth[i] > depth[i+1] && clean_lines[i] !== ""
            push!(table,deepcopy(temp))
        elseif  depth[i] == depth[i+1] && clean_lines[i] !== ""
            push!(table,deepcopy(temp))
        end

    end

end

temp
table

x = vcat(table...)
unique(x[:,1])

# make dataframe 
df = DataFrame(x)

df

# First up, lets look at provinces and get them into a tabular form


gdf = groupby(df[df.x1 .== "provinces", :],:x2)

gdf2 = groupby(df,:x1)
gdf2[5]

# Init the dataframe
provinces = DataFrame(
    province_id = Int[]
    ,holding_type = String[]
    ,building_1 = String[]
    ,building_2 = String[]    
    ,building_3 = String[]
    ,building_4 = String[]    
    ,building_5 = String[]
    ,special_building_type = String[]
    ,fort_level = Int[]
    ,levy = Int[]
    ,garrison = Int[]
    ,income = Float64[]
)

allowmissing!(provinces)

for i = 1:length(gdf)

# init the values
holding_type = ""
building_1= ""
building_2= ""
building_3= ""
building_4= ""
building_5= ""
special_building_type = ""
fort_level = missing
levy = missing
garrison = missing
income = missing

# We want to loop over the rows and pop them into the DF
# *****
# province_id is pretty easy,
province_id = parse(Int,gdf[i].x2[1])

# Get the string that fort_level is in and parse it
x =findall( x -> occursin("fort_level", x), gdf[i].x3 )
if length(x) != 0
    fort_level=parse(Int,split(gdf[i].x3[x[1]],"=")[end])
end

# lets get income
x = findall( x -> occursin("income", x), gdf[i].x4 )
if length(x) != 0
    income=parse(Float64,split(gdf[i].x4[x[1]],"=")[end])
end

# Now lets look at the holding type
x = findall( x -> occursin("type=", x), gdf[i].x4 )
if length(x) != 0
    holding_type = replace(split(gdf[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# Now lets look at the levies
x = findall( x -> occursin("levy", x), gdf[i].x4 )
if length(x) != 0
    levy=parse(Int,split(gdf[i].x4[x[1]],"=")[end])
end

# And garrison
x = findall( x -> occursin("garrison", x), gdf[i].x4 )
if length(x) != 0
    garrison=parse(Int,split(gdf[i].x4[x[1]],"=")[end])
end

# Buildings is manual now but yolo 
x = findall( x -> occursin("buildings", x), gdf[i].x4 )
buildings = Array{String,1}(undef,length(x))

for j = 1:length(x)
    buildings[j] = replace(split(gdf[i].x6[x[j]],'=')[end], ['\"'] => "")
end

if length(buildings) >= 1
    building_1 = buildings[1]
end
if length(buildings) >= 2
    building_2 = buildings[2]
end
if length(buildings) >= 3
    building_3 = buildings[3]
end
if length(buildings) >= 4
    building_4 = buildings[4]
end
if length(buildings) >= 5
    building_5 = buildings[5]
end

# finally, special building type
x = findall( x -> occursin("special_building_type=", x), gdf[i].x4 )
if length(x) != 0
    special_building_type = replace(split(gdf[i].x4[x[1]],'=')[end], ['\"'] => "")
end

# And now we push to the DF

push!(provinces,(
    province_id
    ,holding_type
    ,building_1
    ,building_2
    ,building_3
    ,building_4
    ,building_5
    ,special_building_type
    ,fort_level
    ,levy
    ,garrison
    ,income
))

end

provinces

# ok cool! We have our first block! Exciting

# Lets look at landed titles now

df2 = df[df.x1 .== "landed_titles", :]

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


# Get the title names
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


# gdf_title[445]
i = 5004
# k =split(split(gdf_title[i].x4[x[1]],"history=")[end])
    x = findall( x -> occursin("history=", x), gdf_title[i].x4 )
    if length(x) > 0
        for k in split(split(gdf_title[i].x4[x[1]],"history=")[end])

        date = split(k,"=")[1]
        event_id = parse(Int,split(k,"=")[end])

        push!(Landed_title_history,(
        landed_title_index
        ,landed_title_key
        ,date
        ,event_id
        ))

        end    
    end

end

# landed_titles
# Landed_title_claims
# Landed_title_history


gdf = groupby(df[df.x1 .== "wars", :],:x2)


