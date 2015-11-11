-- Zack Hixon 2015
-- superfish is an implementation of deadfish, but with many more commands
-- think of an accumulator as a variable without a name
-- old stuff - originally in deadfish
--    i - increment current accumulator
--	  d - decrement current accumulator
--	  s - square current accumulator
--	  o - output current accumulator
-- new stuff
--    dual accumulators
--       p - swap values of accumulators
--		 g - increment current accumulator by value of other accumulator
--		 h - decrement current accumulator by value of other accumulator
-- 	  r - take the root of the current accumulator
--    a - swap between numerical output (default) and ascii output
--	  n - input a numerical value into the current accumulator
--	  j - jump to the number character of the other accumulator
-- derpy bugs
--    the mechanics of j need to be smoothed out, it's pretty buggy right now
-- syntax
--    list commands one after the other
--	     oioopigopgopgopgo
--    j cannot be the first command, nor can it be fed a negative number
--       jnogood
--       dddj
--    other than that, there are no rules
sflist = assert(io.open(arg[1], "r"):read("*a"), "Not a valid filename")
if arg[2] == "-debug" or arg[2] == "-d" or arg[2] == "/debug" or arg[2] == "/d" then
debugMode = true end
acc1 = 0 --dual accumulators
acc2 = 0
jump = false
outputAscii = false
accumulator = true
currentChar = sflist:sub(1, 1) --control variables
j = 1
i = 1
if debugMode then
	print("debug mode: #s are accumulators, j is command#, c is current command")
	print("\t1\t| 2\t| j\t| c")
	print("\t---------------------------")
end
function eval(je)
	if debugMode then print("\t"..acc1.."\t| "..acc2.."\t| "..je.."\t| "..currentChar) end
	--standard deadfish commands
	if currentChar == "i" then --increment
		acc1 = acc1 + 1
	end
	if currentChar == "d" then --decrement
		acc1 = acc1 - 1
	end
	if currentChar == "s" then --square
		acc1 = acc1^2
	end
	if currentChar == "o" then --output
		if not outputAscii then
			print(acc1)
		end
		if outputAscii then
			io.write(string.char(acc1))
		end
	end
	--new superfish commands
	if currentChar == "r" then --root
		acc1 = math.floor(math.sqrt(math.abs(acc1)))
	end
	if currentChar == "n" then --input
		acc1 = tonumber(io.read())
	end
	if currentChar == "a" then --ascii/numerical output
		if outputAscii then outputAscii = false
		else outputAscii = true end
	end
	if currentChar == "j" then --jump not quite yet
		--jump = true
		je = acc1
	end
	if currentChar == "p" then --swap values of accumulators
		 local buffer = acc1
		 acc1 = acc2
		 acc2 = buffer
	end
	if currentChar == "g" then --increment by value in opposite accumulator
		acc1 = acc1 + acc2
	end
	if currentChar == "h" then --decrement by value in opposite accumulator
		acc1 = acc1 - acc2
	end
	if currentChar == "\n" then
		je = sflist:len() + 1
	end
	return je
end
--as long as i is less than the length of the command list
--the current character is set equal to the i-th character in the command list
--j is set to the return value of eval
--   j would not be changed under normal circumstances, but if a jump is made
--   eval would return a different value than i, which is the command to jump to
--   i is set to j to accomodate jumps
while i <= sflist:len() do
	currentChar = sflist:sub(i,i)
	j = eval(i)
	i = j
	i = i+1
end
