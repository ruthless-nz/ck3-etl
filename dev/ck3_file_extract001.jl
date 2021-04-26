using FileWatching
using Dates
using ZipFile
using StringEncodings

# poll_file("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//test.txt",1,10) 

# watch_file("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//test.txt",10)

# x = watch_folder("Duke_Ramon Berenguer_of_Barcelona_1066_09_19",10)

# unwatch_folder("Duke_Ramon Berenguer_of_Barcelona_1066_09_19")


# ok so this little devil will pool the file until there is a changex

# it will check every 10 seconds and timeout after a minute


timeout = 0

while (timeout == 0)

# first up, check to see if the control file wants us to keep running
f = open("control.txt")
    ctrl = readlines(f)
close(f)

# look at the folder for 10 secs
x = watch_folder("C://Users//Tims PC//OneDrive//Documents//Paradox Interactive//Crusader Kings III//save games",10)

println(Dates.format(now(), "HH:MM:SS:ss"),"   ",x)
    if x[1] == "autosave.ck3"

        
    end

    if ctrl[1] == "stop" 
        global timeout = 1
        unwatch_folder("C://Users//Tims PC//OneDrive//Documents//Paradox Interactive//Crusader Kings III//save games")
    end
end

file = "C://Users//Tims PC//OneDrive//Documents//Paradox Interactive//Crusader Kings III//save games//Duke_Ramon Berenguer_of_Barcelona_1070_10_10.ck3"
# We need to see if we can unzip some stuff

# first lets copy it to our local

typeof(x[1])



# cp(file,"temp_files//autosave.zip")
cp(file,"temp_files//Duke_Ramon Berenguer_of_Barcelona_1070_10_10.zip")

# So we will read this into another zipfile that we will create via this func





pk_key = 0
zip_file = "temp_files//Duke_Ramon Berenguer_of_Barcelona_1070_10_10.zip"
(tmppath, tmpio) = mktemp()

# open("temp_files//Duke_Ramon Berenguer_of_Barcelona_1070_10_10.zip") do io
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
mv(tmppath, zip_file, force=true)



unzip=ZipFile.Reader("temp_files//Duke_Ramon Berenguer_of_Barcelona_1070_10_10.zip")

lines2 = readlines(unzip.files[1])







encodings()

for enc in encodings()

        coded = 1
    try
        x = read(split(lines[2],"\0")[1]*"\0",enc)
    catch
        coded = 0
    end

    if coded == 1
        println(enc)
        println(x)
    end
end





y = "Duke_Ramon Berenguer_of_Barcelona_1070_11_19.ck3.tmp"

y[end-2:end]

z = ""

(@isdefined z) == false



for i in 1:10
    if (@isdefined next_file) == false
        next_file = ""
    end

    if iseven(i)
        next_file = string(i)
    end

    if next_file != ""
        println(next_file)
        next_file = ""
    end
end


length("autosave")

x = "autosave    0"

x[1:8]

