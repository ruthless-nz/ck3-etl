# This will run the entire project


# run the inital extract code
include("ck3_extract.jl")

# Now lets look at the blocks
# would be super cool if we looked at trying to make this like, multithreaded?

# provinces
include("provinces.jl")

# titles
include("titles.jl")

# living characters
include("living_characters.jl")

