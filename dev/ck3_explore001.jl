# ok so we want to try read in all this xml type stuff
# there is a set of how the file is formatted

# it goes like this:
# meta_data
# ironman_manager
# (various variables)
# variables
# game_rules
# provinces
# landed_titles
# dynasties
# deleted_characters
# living
# dead_unprunable
# characters
# character_lookup
# units
# activities
# opinions
# relations
# schemes
# stories
# pending_character_interactions
# secrets
# armies
# religion
# wars
# sieges
# raid
# succession
# holdings
# ai
# county_manager
# fleet_manager
# council_task_manager
# important_action_manager
# faction_manager
# culture_manager
# mercenary_company_manager
# holy_orders
# coat_of_arms
# triggered event=
# next_player_event_id=
# played_character
# currently_played_characters=



f = open("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//gamestate.ck3")

lines = readlines(f)

close(f)

# ok so now we have the save as an array

# We want to break this out into the blocks
# lines[414][1]

function check_str2(a)
    try parse(Int, a) !== nothing
    return true
    catch 
    return false
end
end


blocks = Array{String,1}()
position = Array{Int,1}()

for i = 1:length(lines)
    if lines[i] != "" 
        # exclude other leading characters
        if lines[i][1] != '\t' && lines[i][1] != ' ' && lines[i][1] != '}' && lines[i][1] != '{' && check_str2(lines[i][1]) != true

            push!(blocks,lines[i])
            push!(position,i)

        end
    end
end

blocks
position

# uniqe = unique(blocks)
# table = Array{Array{String,1},1}

check_str2(lines[176970][1])

# ok so now we will loop through the following.

# I want to split the data out into the following structure:
# for each 'block' create a new table that is the name of the block
# if there is no '{' then create value like:
# save_game_version | 3
# if there is a '{} then extract them out
# colored_emblem || color1 || red
# colored_emblem || color2 || blue

# This will probably be the easiest to do as array of arrays? unsure

# for i = 2:length(position)
for i = 2:10

    # First up, find the name of the block
    block = blocks[i-1][1:findnext("=",blocks[i-1],1)[1]-1]
    table =  Array{Array,1}()

    # now loop over the values that are on the top level
        for j = position[i+1]+1:position[i]-1
            println(position[i+1],"-",(position[i]-1))
            println(j)
            if findnext("{",blocks[j],1) == nothing
                println(j)
                # push!(table,rsplit(blocks[j],"="))
            end    

        end

    # println(position[i-1]," - ", position[i]-1)

end



print(table)


findnext("{",blocks[3],1) == nothing