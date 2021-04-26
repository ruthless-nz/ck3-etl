


# df2 = ck3_raw_parse[ck3_raw_parse.x1 .== "landed_titles", :]
# gdf_title = groupby(df2[df2.x2 .== "landed_titles", :],:x3)



# blocks = unique(ck3_raw_parse.x1)

# blocks[12:16]

# # stdout

# # 12439
# landed_title_index
# gdf_title[12441]

# println(provinces[1:5,:])

# temp = Array{ String,2}(undef, 1,maximum(depth))
# fill!(temp, "")
# table =  Array{Array,1}()

using Profile
using StatProfilerHTML
using BenchmarkTools

@btime include("core.jl")

Profile.clear()

@profile include("core.jl")

statprofilehtml()



