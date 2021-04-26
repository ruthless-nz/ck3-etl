# living

println("Starting Living Character Block.....")

gdf_char = groupby(ck3_raw_parse[ck3_raw_parse.x1 .== "living", :],:x2)

# print(gdf_char[1])
# so we want to init the dataframe

# Right now I will not include much landed data. This is because I want to try keep one value per row 



living_person = DataFrame(
character_id = Int[]
,character_name = String[]
,birth_date = String[]
,female = Int[]
,culture = Int[]
,faith = Int[]
,skill_diplomacy = Int[]
,skill_stewardship = Int[]
,skill_martial = Int[]
,skill_intrigue = Int[]
,skill_learning = Int[]
,skill_prowess = Int[]
,sexuality = String[]
,dna = String[]
,mass = Int[]
,gold = Float64[]
,gold_income = Float64[]
,location = Int[]
,fertility = Float64[]
,health = Float64[]
,piety = Float64[]
,piety_income = Float64[]
,prestige = Float64[]
,prestige_income = Float64[]
,employer = Int[]
,council_task = Int[]
,regiment = Int[]
,knight = Int[]
# ,domain = Int[]
,became_ruler_date = String[]
,strength = Float64[]
,strength_for_liege = Float64[]
,liege_tax = Float64[]
,dread = Float64[]
,is_powerful_vassal = Int[]
,vassal_power_value = Float64[]
,domain_limit = Int[]
,vassal_limit = Int[]
,government = String[]
,realm_capital = Int[]
)
allowmissing!(living_person)

for i = 1:length(gdf_char)

# Need to Init Missing
character_id = missing
character_name =  ""
birth_date =  ""
female = missing
culture = missing
faith = missing
skill_diplomacy = missing
skill_stewardship = missing
skill_martial = missing
skill_intrigue = missing
skill_learning = missing
skill_prowess = missing
sexuality = ""
dna =  ""
mass = missing
gold = missing
gold_income = missing
location = missing
fertility = missing
health = missing
piety = missing
piety_income = missing
prestige = missing
prestige_income = missing
employer = missing
council_task = missing
regiment = missing
knight = 0
# domain = missing
became_ruler_date =  ""
strength = missing
strength_for_liege = missing
liege_tax = missing
dread = missing
is_powerful_vassal = missing
vassal_power_value = missing
domain_limit = missing
vassal_limit = missing
government = ""
realm_capital = missing

# i = 1



# Get the character_id names
character_id = parse(Int,gdf_char[i].x2[1])
# and the key
x = findall( x -> occursin("first_name=", x), gdf_char[i].x3 )
if length(x) != 0
    character_name = replace(split(gdf_char[i].x3[x[1]],'=')[end], ['\"'] => "")
end

# Birth date
x = findall( x -> occursin("birth=", x), gdf_char[i].x3 )
if length(x) != 0
    birth_date = replace(split(gdf_char[i].x3[x[1]],'=')[end], ['\"'] => "")
end

# female
x = findall( x -> occursin("female=", x), gdf_char[i].x3 )
if length(x) != 0
    if occursin("yes",gdf_char[i].x3[x[1]])
        female = 1
    end
end

# sexuality
x = findall( x -> occursin("sexuality=", x), gdf_char[i].x3 )
if length(x) != 0
    sexuality = replace(split(gdf_char[i].x3[x[1]],'=')[end], ['\"'] => "")
else     
    sexuality = "het"
end

# culture
x = findall( x -> occursin("culture=", x), gdf_char[i].x3 )
if length(x) != 0
    culture = parse(Int,split(gdf_char[i].x3[x[1]],"=")[end])
end

# faith
x = findall( x -> occursin("faith=", x), gdf_char[i].x3 )
if length(x) != 0
    faith = parse(Int,split(gdf_char[i].x3[x[1]],"=")[end])
end

faith

# skills
x = findall( x -> occursin("skill=", x), gdf_char[i].x3 )
if length(x) != 0
    skills = split(strip(split(gdf_char[i].x3[x[1]],"=")[end])," ")
# and parse them one by one
    skill_diplomacy = parse(Int,skills[1])
    skill_stewardship = parse(Int,skills[2])
    skill_martial = parse(Int,skills[3])
    skill_intrigue = parse(Int,skills[4])
    skill_learning = parse(Int,skills[5])
    skill_prowess = parse(Int,skills[6])
end

# sexuality
# x = findall( x -> occursin("birth=", x), gdf_char[i].x3 )
# if length(x) != 0
#     sexuality = replace(split(gdf_char[i].x3[x[1]],'=')[end], ['\"'] => "")
# end

# DNA
# x = findall( x -> occursin("birth=", x), gdf_char[i].x3 )
# if length(x) != 0
#     DNA = replace(split(gdf_char[i].x3[x[1]],'=')[end], ['\"'] => "")
# end

# Mass
x = findall( x -> occursin("mass=", x), gdf_char[i].x3 )
if length(x) != 0
    mass = parse(Int,split(gdf_char[i].x3[x[1]],"=")[end])
end


# Alive data traits
x = findall( x -> occursin("alive_data", x), gdf_char[i].x3 )

for j in x
    y = split(gdf_char[i].x4[j],"=")

    if length(y) != 0
        if y[1] == "gold"
            gold = parse(Float64,y[2])

        elseif y[1] == "income"
            gold_income = parse(Float64,y[2])

        elseif y[1] == "location"
            location = parse(Int,y[2])

        elseif y[1] == "fertility"
            fertility = parse(Float64,y[2])

        elseif y[1] == "health"
            health = parse(Float64,y[2])

        end
    end
end

# and get the piety and prestige values. 
# get the index of these first
x = findall( x -> length(x) != 0, gdf_char[i].x5 )

for j in x
    if gdf_char[i].x4[j] == "piety"
        if occursin("currency",gdf_char[i].x5[j])
           piety_income = parse(Float64,split(gdf_char[i].x5[j],"=")[end])
        elseif occursin("accumulated",gdf_char[i].x5[j])
            piety  = parse(Float64,split(gdf_char[i].x5[j],"=")[end])
        end
    elseif gdf_char[i].x4[j] == "prestige"
        if occursin("currency",gdf_char[i].x5[j])
            prestige_income = parse(Float64,split(gdf_char[i].x5[j],"=")[end])
        elseif occursin("accumulated",gdf_char[i].x5[j])
             prestige  = parse(Float64,split(gdf_char[i].x5[j],"=")[end])
        end
    end

end

x = findall( x -> occursin("court_data", x), gdf_char[i].x3 )
for j in x
    y = split(gdf_char[i].x4[j],"=")

    if length(y) != 0
        if y[1] == "council_task"
            council_task = parse(Int,y[2])

        elseif y[1] == "knight"
            if y[2] == "yes" 
                knight = 1
            end
        end
    end
end



x = findall( x -> occursin("landed_data", x), gdf_char[i].x3 )
for j in x
    y = split(gdf_char[i].x4[j],"=")

    if length(y) != 0
        # if y[1] == "domain"
        #     global domain = parse(Int,y[2])

        if y[1] == "became_ruler_date"
            became_ruler_date = y[2]

        elseif y[1] == "strength"
            strength = parse(Float64,y[2])

        elseif y[1] == "strength_for_liege"
            strength_for_liege = parse(Float64,y[2])
            
        elseif y[1] == "liege_tax"
            liege_tax = parse(Float64,y[2])
            
        elseif y[1] == "dread"
            dread = parse(Float64,y[2])

        elseif y[1] == "is_powerful_vassal"
            if y[2] == "yes" 
                is_powerful_vassal = 1
            end

        elseif y[1] == "vassal_power_value"
            became_ruler_date = parse(Float64,y[2])

        elseif y[1] == "domain_limit"
            domain_limit = parse(Int,y[2])

        elseif y[1] == "vassal_limit "
            vassal_limit  = parse(Int,y[2])

        elseif y[1] == "government"
            became_ruler_date = y[2]

        elseif y[1] == "realm_capital  "
            realm_capital  = parse(Int,y[2])
            
        end
    end
end


    # domain

# And now we push to the DF
 
push!(living_person,(
    character_id
    ,character_name
    ,birth_date
    ,female      
    ,culture      
    ,faith      
    ,skill_diplomacy      
    ,skill_stewardship      
    ,skill_martial      
    ,skill_intrigue      
    ,skill_learning      
    ,skill_prowess      
    ,sexuality      
    ,dna      
    ,mass      
    ,gold      
    ,gold_income      
    ,location      
    ,fertility      
    ,health      
    ,piety      
    ,piety_income      
    ,prestige      
    ,prestige_income      
    ,employer      
    ,council_task      
    ,regiment      
    ,knight      
    # ,domain      
    ,became_ruler_date      
    ,strength
    ,strength_for_liege
    ,liege_tax
    ,dread 
    ,is_powerful_vassal 
    ,vassal_power_value
    ,domain_limit 
    ,vassal_limit
    ,government
    ,realm_capital
))

end

# living_person

# unique(ck3_raw_parse[ck3_raw_parse.x1 .== "living", :].x3)
# unique(living_person.female)

println("Finished Living Character Block!")