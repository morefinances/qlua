function OnInit()

	folder_id = "C:\\files\\"
	file_name = "test.csv"
	
end

function main()

	if FileSize(folder_id .. file_name) == nil then
		message("Файл " .. file_name .. " не найден") 
	else
		message("Размер файла " .. file_name .. " равен " .. FileSize(folder_id .. file_name) .. " байт")
		FileStatus()
	end
	
end

-- проверка наличия файла
-- если есть, то вернет размер файла в байтах
function FileSize(file)

   local size
 
   if type(file) == "string" then
      local f,err = io.open(file,"r")
      if not f then return nil,err end
      size = FileSize(f)
      f:close()
   else
      local current_position = file:seek() 
      size = file:seek("end")
      file:seek("set", current_position)
   end
   return size
   
end

-- статус файла
function FileStatus()

	-- открываем файл для чтения
	DirectionOpenFile=tostring(folder_id .. file_name) 
	FileStatus = io.open(DirectionOpenFile, "a+");

	string_file = {}

	if FileStatus ~= nil then

		--проходим построчно
		index_for_string_file = 1
		string_file[index_for_string_file] = FileStatus:read("*l")
		
		if string_file[index_for_string_file] ~= nil then

			while string_file[index_for_string_file] ~= nil do
				index_for_string_file = index_for_string_file + 1
				string_file[index_for_string_file] = FileStatus:read("*l")
			end
		
		end
		
		-- если массив строк не заполнен и первое значение нулевое, то файл пуст
		if #string_file == 1 and string_file[1] == "" then
			message("Файл " .. folder_id .. file_name .. " пуст")
			status_file = 0
		end
		
		FileStatus:close()
	else
		message("Файл "..folder_id .. file_name.." открыт другой программой.")
	end
	
end