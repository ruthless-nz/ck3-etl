

f = open("Duke_Ramon Berenguer_of_Barcelona_1066_09_19//test.ck3")

fat_lines = read(f,String)

close(f)

typeof(fat_lines)

line= replace(fat_lines, ['\t','\r','\n', ] => " ")
# line = fat_lines


line
fat_lines

# we can fix the types later
aofa = []
row = []

length(line) 


leftBracket=0
rightBracket=0
prev_position = 0
string_start = 0
counter = 0


for i in line
    global counter = counter + 1
    if i == '{' 

        global leftBracket = leftBracket + 1
        # println(leftBracket)

    end;
    if i == '}'

        global rightBracket = rightBracket + 1
        # println(rightBracket)

    end

if  (leftBracket-rightBracket) > prev_position 


    
push!(row,line[string_start+1:counter-1])
global string_start = counter
end;
# println(position)
# println(leftBracket- rightBracket)
global prev_position = leftBracket- rightBracket
println(leftBracket- rightBracket)
end

row


