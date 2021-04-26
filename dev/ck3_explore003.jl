
# Ok so the goal of this is to break open the XML type stuff via regex
using DataFrames

f = open("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//gamestate.ck3")

lines = readlines(f)

close(f)

# ok so here we are going to replace the brackets nd work off of tabs

# ok so lets loop through 

clean_lines = Array{String,1}(undef,length(lines))
depth = Array{Int,1}(undef,length(lines))

for i = 1:length(lines)

    clean_lines[i]= strip(replace(lines[i], ['{','}' ] => ""))
    depth[i] = count(i->(i=='\t'),lines[i] ) + 1

end

depth
clean_lines

# ok so now create a temp array that is the max length of the the depth
temp = Array{Union{Nothing, String},2}(nothing, 1,maximum(depth))
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
        temp[depth[i-1]] = nothing
    end
# cool, now we check if the print conditions are met
    if i !== length(lines) && i !== 1

        if depth[i] == depth[i+1] && depth[i] > depth[i-1]
            push!(table,deepcopy(temp))
        elseif  depth[i] == depth[i-1] && depth[i] > depth[i+1]
            push!(table,deepcopy(temp))
        end

    end

end

temp

x = vcat(table...)

# print(table)
# loop over 

df = DataFrame(x)

df
gdf = groupby(df,:x1)
unique(x[:,1])

# So I still have loads of non key values

