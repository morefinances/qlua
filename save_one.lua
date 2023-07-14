filename = "save_one"
DirectionSaveFile=tostring("C:\\files\\"..filename..".csv") 
my_csv=io.open(DirectionSaveFile,"a+") 

abc = "Проба записи в файл" 
my_csv:write(abc..";\n") 

for i = 1, 10 do
	my_csv:write(i..";\n")
end

my_csv:flush()  
my_csv:close() 

message(DirectionSaveFile)