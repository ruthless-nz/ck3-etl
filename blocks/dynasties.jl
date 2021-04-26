
print(unique(ck3_raw_parse[:,1]))

gdf = groupby(ck3_raw_parse[ck3_raw_parse.x1 .== "dynasties", :],:x3)

# Need to ensure that x3 is not missing

gdf[6239]

# Ok so I might come back to Dynasties later