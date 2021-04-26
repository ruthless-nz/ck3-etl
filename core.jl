using FileWatching
using ZipFile
using Dates
using DataFrames

# vars 
playthrough_name = "Barcelona_1"
ck3_save_location = "C://Users//Tims PC//OneDrive//Documents//Paradox Interactive//Crusader Kings III//save games"
file_to_slurp = ""
data_location = "data//"*playthrough_name

# Run some startup processes
# Check to see if there is a folder our current playthrough
if isdir(data_location) == false
    mkdir(data_location)
end


# ok so we want to  query the save file location for any changes to the files in there
timeout = 0
while (timeout == 0)


    global file_to_slurp
    if (@isdefined file_to_slurp) == false
        file_to_slurp = ""
    end


# first up, check to see if the control file wants us to keep running
f = open("control.txt")
    ctrl = readlines(f)
close(f)

# look at the folder for 2 secs
    x = watch_folder(ck3_save_location,1)
# println(Dates.format(now(), "HH:MM:SS:ss"),"   ",x)
# println(file_to_slurp)

# check to see if we have files we care about.
    if x[1] != ""
        if x[1][1:8] != "autosave" && x[1][end-2:end] != "tmp"
            # set the next file to be slurped up
            file_to_slurp = ck3_save_location*"//"*x[1]
            println("ready_to_slurp: ",file_to_slurp)

        end
    end

    # check if we have a file ready to slurp up
    if x[1] == "" && file_to_slurp != ""
            println("Ingesting file:  ",file_to_slurp)
            # Now we do the thing!
            include("blocks//process_blocks.jl")
            println("File has been Slurped!")
            file_to_slurp =""
    end 

# And once the loop is done, stop listening
    if ctrl[1] == "stop" 
        global timeout = 1
        unwatch_folder(ck3_save_location)
    end
end

# and print this boyo

# println(provinces[1,:])
# println(landed_titles[1,:])
# println(Landed_title_claims[1,:])
# println(Landed_title_history[1,:])
# println(living_person[1,:])

