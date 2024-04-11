function OnInit()
	do_it 				= true
	all_trades_file 	= "alltrades"
	all_orders_file 	= "allorders"
	folder_id 			= "C:\\files\\"
	time_for_downloads 	= 185100
	indexdownloads 		= 0
	last_time 			= tonumber(os.date("%H%M%S"))
	progname 			= "downloads_all_orders_and_trades : "
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



function DownloadsAllOrders()

	local index_active = 0

	number_of_order = getNumberOf("orders")

	if number_of_order == 0 then
	
		message("Заявок не было.")
		
	else

		DirectionSaveFile = tostring(folder_id .. all_orders_file .. "_" .. tostring(DATE) .. "_" .. tostring(TIME) .. ".csv") 
		allorder_csv=io.open(DirectionSaveFile,"w") 

		message("Всего заявок : " .. number_of_order .. " шт.")

		for ii = 0, number_of_order - 1 do
			
			if ii == 0 then
				allorder_csv:write("N;date;time;trans_id;order_num;class;tiker;operation;volume;price;value;brokerref;\n")
			end
			
			table_all_order = getItem("orders", ii)

			if bit.test(tonumber(table_all_order.flags), 2) then
				txt_operation = "продажа"
			else
				txt_operation = "покупка"
			end
			
			date_order = plus_zero(table_all_order.datetime.day) .. "." .. plus_zero(table_all_order.datetime.month) .. "." .. table_all_order.datetime.year
			
			time_order = plus_zero(table_all_order.datetime.hour) .. ":" .. plus_zero(table_all_order.datetime.min) .. ":" .. plus_zero(table_all_order.datetime.sec) .. "." .. table_all_order.datetime.ms

			order_status = ""
			
			if table_all_order.balance == 0 then
				order_status = "заявка исполнена полностью"
			end

			if table_all_order.balance ~= table_all_order.qty and table_all_order.balance ~= 0 then
				order_status = "заявка исполнена частично"
			end
			
			if not bit.test(tonumber(table_all_order.flags), 0) and bit.test(tonumber(table_all_order.flags), 1) then
				if order_status == "" then
					order_status = order_status .. "заявка снята"
				else
					order_status = order_status .. " / снята"
				end
			end
			
			txt_for_allorders	= (ii + 1) .. ";" .. date_order .. ";" ..time_order .. ";" .. table_all_order.trans_id .. ";" .. table_all_order.order_num .. ";" ..  table_all_order.class_code .. ";" .. table_all_order.sec_code .. ";" ..txt_operation .. ";" .. table_all_order.qty .. ";" .. table_all_order.price .. ";" .. table_all_order.value .. ";" .. table_all_order.brokerref .. ";" .. order_status .. ";\n"
			
			allorder_csv:write(txt_for_allorders)
			
		end
	
		allorder_csv:flush()  
		allorder_csv:close() 
	
	end
	
end




function DownloadsAllTrades()

	
	local index_active = 0

	number_of_trades = getNumberOf("trades")

	if number_of_trades == 0 then
	
		message("Сделок не было.")
		
	else

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

	message(progname .. "старт работы" )

	while do_it do

	current_time = tonumber(os.date("%H%M%S"))
	
		if indexdownloads == 0 and current_time >= time_for_downloads then
			
			message(string.rep('-', 25))
			
			DATE = tonumber(os.date("%Y%m%d"))
			TIME = tonumber(os.date("%H%M%S"))
			
			message("Сохранение таблицы заявок")
			DownloadsAllOrders()
			
			message(string.rep('-', 15))
			
			message("Сохранение таблицы сделок")
			DownloadsAllTrades()

			indexdownloads = 1 
			
		end

		if last_time ~= current_time and last_time > current_time then

			indexdownloads = 0
			
		else
		
			last_time = current_time
			
		end

		sleep(1000)

	end	

end