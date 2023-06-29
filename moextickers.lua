-- To read comments, use the encoding:: Windows-1251

--[[
Скрипт делает выгрузку всех торгуемых акций на Московской Бирже (иногда встречаются варианты с нулевыми объемами, но с индикативными ценами). 
Сохраняет результат в файл C:\files\tickers.csv. Параллельно выводит список с разбивкой по 5 бумаг в строку в терминале.
]]--

function main()

	message('[ = = = = = = = = = = start = = = = = = = = = = ]')
	
	datetime = os.date("!*t",os.time())
	message('Îïðåäåëåíèå òèêåðîâ òîðãóåìûõ áóìàã íà ôîíäîâîé ñåêöèè')
	message(os.date("%d.%m.%Y"))
	message('Íà÷àëî ðàáîòû ñêðèïòà '..os.date("%X",os.time()))
	

	DirectionSaveFile=tostring("C:\\files\\tickers.csv") 
	my_csv=io.open(DirectionSaveFile,"w") 
	
	sec_list = getClassSecurities("TQBR") -- òèêåðû â îäíó ñòðî÷êó
	
	ind = 1 -- èíäåêñ ïîäñ÷åòà êîëè÷åñòâî áóìàã
	sprint = "" -- ñêëåéêà ìàññèâîâ äëÿ âûâîäà
	
	-- ðàçáèâêà ñòðîêè ñ òèêåðàìè
	for TIKER in string.gmatch(sec_list, "[^,]+") do
		-- çàïèñü â ôàéë
		my_csv:write(TIKER.."\n")
		sprint = sprint..tostring(ind).."/ "..TIKER.."  "
		ind = ind + 1 -- èíäåêñ áóìàãè
		if ind%5 == 1 then 
			message(sprint)
			sprint = ""
		end
		sleep(5)
	end
	
	if sprint ~= "" then message(sprint) end 
	
	-- -- çàêðûòèå ôàéëà
	my_csv:flush()  
	my_csv:close() 

	message('Çàâåðøåíèå ðàáîòû ñêðèïòà '.. os.date("%X",os.time()))
	message('Îáùåå êîëè÷åñòâî òîðãóåìûõ áóìàã : '..tostring(ind - 1))
	message("[ = = = = = = = = = = end = = = = = = = = = =  ]")
	
end
