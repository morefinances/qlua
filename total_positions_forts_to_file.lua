-- позиции на всех счетах на срочном рынке

function main()

	message(string.rep('~',20))
	message("¬ывод текущих позиций срочного рынка:") 

	positionlimit_file = "posiotions"
	DATE = tonumber(os.date("%Y%m%d"))
	TIME = tonumber(os.date("%H%M%S"))
	folder_id = "C:\\files\\"
	
	number_of_position = getNumberOf("futures_client_holding")
	
		DirectionSaveFile = tostring(folder_id .. positionlimit_file .. "_" .. tostring(DATE) .. "_" .. tostring(TIME) .. ".csv") 
		forts_positions_csv=io.open(DirectionSaveFile,"w") 
	
		title_txt = "тикер;вход€щие длинные позиции;вход€щие короткие позиции;вход€щие чистые позиции;текущие длинные позиции;текущие короткие позиции;текущие чистые позиции;активные на покупку;активные на продажу;эффективна€ цена позиций;торговый счет;\n" 
		
		forts_positions_csv:write(title_txt)
	
		for i = 0, number_of_position - 1 do
		
			forts_position = getItem("futures_client_holding",i)
			
			txt_string_limits = forts_position.sec_code .. ";" .. forts_position.startbuy .. ";" .. forts_position.startsell .. ";" ..  forts_position.startnet .. ";" .. forts_position.todaybuy .. ";" .. forts_position.todaysell .. ";" .. forts_position.totalnet .. ";" .. forts_position.openbuys  .. ";" .. forts_position.opensells .. ";" .. forts_position.avrposnprice ..  ";" .. forts_position.trdaccid .. ";\n"
			
			message(txt_string_limits)
			
			forts_positions_csv:write(txt_string_limits)

		
		end
	
		forts_positions_csv:flush()  
		forts_positions_csv:close() 
	
 end