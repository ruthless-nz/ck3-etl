# This takes our parsed dataframe: ck3_raw_parse,
# amd puts it into a dataframe called province that creates 
# province data


println("Started Provinces Block...")
# create the grouping
gdf = groupby(ck3_raw_parse[ck3_raw_parse.x1 .== "provinces", :],:x2)

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

println("Finished Provinces Block!")
