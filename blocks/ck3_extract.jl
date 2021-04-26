# input vars:
    # file_to_slurp
    # data_location

    println("Starting Extract.....")

# ok so we need to take the file and copy it to a temp location. 
temp_space=tempdir()
zip_file = temp_space*"//ck3_save.zip"
cp(file_to_slurp,zip_file; force = true)

# Now we need to blitz the ck3 file down to the PK key
pk_key = 0
(tmppath, tmpio) = mktemp()

open(zip_file) do io
    for line in eachline(io, keep = true)
        if pk_key == 0
            if occursin("PK",line)
                global pk_key = 1
            end
        end

        if pk_key == 1
            write(tmpio, line)
        end

    end
end
close(tmpio)
# and force the new one back over original
mv(tmppath, zip_file, force=true)

# cool now we can unzip the file to get the text file

fileToParse=ZipFile.Reader(zip_file)

# The input of this is to take the file, parse it in and
# create our general datframe that it used later
# Output = ck3_raw_parse

println("Reading Lines.....")
lines = readlines(fileToParse.files[1])

close(fileToParse)

# length(lines)
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
ck3_raw_parse = DataFrame(x)

println("Finished Extract!")