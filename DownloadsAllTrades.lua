function OnInit()
	do_it 				= true
	all_trades_file 	= "alltrades"
	folder_id 			= "C:\\files\\"
	last_time 			= tonumber(os.date("%H%M%S"))
	progname 			= "downloads_all_trades : "
end


function OnStop()
	do_it = false
	message(progname .. "завершение работы" )
end 


function plus_zero(data_number)
	
	if data_number and tonumber(data_number) < 10 then
		return "0"..data_number
	elseif data_number then
		return data_number
	else
		return ""
	end
	
end


function DownloadsAllTrades()

	
	local index_active = 0

	number_of_trades = getNumberOf("trades")

	if number_of_trades == 0 then
	
		message("Сделок не было.")
		
	else
	
		DATE = tonumber(os.date("%Y%m%d"))
		TIME = tonumber(os.date("%H%M%S"))

		DirectionSaveFile = tostring(folder_id .. all_trades_file .. "_" .. tostring(DATE) .. "_" .. tostring(TIME) .. ".csv") 
		alltrades_csv=io.open(DirectionSaveFile,"a+") 

		message("Всего сделок : " .. number_of_trades .. " шт.")

		for ii = 0, number_of_trades - 1 do
			
			table_all_trades = getItem("trades", ii)
			
			if ii == 0 then
				alltrades_csv:write("N;date;time;trans_id;order_num;trade_num;class;tiker;operation;volume;price;value;brokerref;\n")
			end

			if bit.test(tonumber(table_all_trades.flags), 2) then
				txt_operation = "продажа"
			else
				txt_operation = "покупка"
			end

			date_trade = plus_zero(table_all_trades.datetime.day) .. "." .. plus_zero(table_all_trades.datetime.month) .. "." .. table_all_trades.datetime.year
			
			time_trade = plus_zero(table_all_trades.datetime.hour) .. ":" .. plus_zero(table_all_trades.datetime.min) .. ":" .. plus_zero(table_all_trades.datetime.sec) .. "." .. table_all_trades.datetime.ms

			txt_for_trades	= (ii + 1) .. ";" .. date_trade .. ";" .. time_trade .. ";" .. table_all_trades.trans_id .. ";" .. table_all_trades.order_num .. ";" .. table_all_trades.trade_num .. ";" .. table_all_trades.class_code .. ";" .. table_all_trades.sec_code .. ";" ..txt_operation .. ";" .. table_all_trades.qty .. ";" .. table_all_trades.price .. ";" .. table_all_trades.value .. ";" .. table_all_trades.brokerref .. ";\n"
			
			alltrades_csv:write(txt_for_trades)
		 
		end
	
		alltrades_csv:flush()  
		alltrades_csv:close() 
	
	end
	
end


function main()

	message(string.rep('-', 25))
	message("Сохранение таблицы сделок")
	DownloadsAllTrades()

end

