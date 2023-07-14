DirectionFile=tostring("C:\\files\\save_one.csv") 
f = io.open(DirectionFile, "r");

t = f:read("*all")

f:close()

message(t)

s = {}
a = 1
for i in string.gmatch(t, "[^;]+") do
	s[a] = tonumber(i)
	message(tostring(s[a]))
	a = a + 1
end 

message(""..#s)