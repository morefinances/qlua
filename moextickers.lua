-- To read comments, use the encoding:: Windows-1251

--[[
Скрипт делает выгрузку всех торгуемых акций на Московской Бирже (иногда встречаются варианты с нулевыми объемами, но с индикативными ценами). 
Сохраняет результат в файл C:\files\tickers.csv. Параллельно выводит список с разбивкой по 5 бумаг в строку в терминале.
]]--

function main()

	message('[ = = = = = = = = = = start = = = = = = = = = = ]')
	
	datetime = os.date("!*t",os.time())
	message('')
	message(os.date("%d.%m.%Y"))
	message('Начало работы скрипта '..os.date("%X",os.time()))
	

	DirectionSaveFile=tostring("C:\\files\\tickers.csv") 
	my_csv=io.open(DirectionSaveFile,"w") 
	
	sec_list = getClassSecurities("TQBR") -- тикеры в одну строчку
	
	ind = 1 -- индекс подсчета количество бумаг
	sprint = "" -- склейка массивов для вывода
	
	-- разбивка строки с тикерами
	for TIKER in string.gmatch(sec_list, "[^,]+") do
		-- запись в файл
		my_csv:write(TIKER.."\n")
		sprint = sprint..tostring(ind).."/ "..TIKER.."  "
		ind = ind + 1 -- индекс бумаги
		if ind%5 == 1 then 
			message(sprint)
			sprint = ""
		end
		sleep(5)
	end
	
	if sprint ~= "" then message(sprint) end 
	
	-- -- закрытие файла
	my_csv:flush()  
	my_csv:close() 

	message('Завершение работы скрипта '.. os.date("%X",os.time()))
	message('Общее количество торгуемых бумаг : '..tostring(ind - 1))
	message("[ = = = = = = = = = = end = = = = = = = = = =  ]")
	
end
