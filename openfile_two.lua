DirectionFile=tostring("C:\\files\\save_one.csv") 

t = {}

for line in io.lines(DirectionFile) do
	t[#t+1]=line
	message(t[#t])
end

 
 