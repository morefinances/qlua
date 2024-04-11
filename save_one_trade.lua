function OnInit()
	do_it 				= true
	txt_trade_string 	= ""
	DATE 				= tonumber(os.date("%Y%m%d"))
	progname 			= "save_one_trade : "
	one_orders_file 	= "every_trades"
	folder_id 			= "C:\\files\\"
end

function OnStop()
	do_it = false
	message(progname .. "завершение работы.")
end

function OnTrade(trd)
	
	if bit.test(tonumber(trd.flags), 2) then
		direct_operation = "sell"
	else
		direct_operation = "buy"
	end
	
	txt_trade_string = txt_trade_string .. trd.trade_num .. ";" .. trd.order_num .. ";" .. trd.price .. ";" .. trd.qty .. ";" .. direct_operation .. ";" .. trd.value .. ";" ..trd.brokerref .. ";\n"
	
	message(txt_trade_string)
	
end


function main()

	message(progname .. "старт работы.")

	while do_it do
	
		if txt_trade_string ~= "" then
			DirectionSaveFile = tostring(folder_id .. one_orders_file .. "_" .. tostring(DATE)  .. ".csv") 
			save_one_trade_csv = io.open(DirectionSaveFile,"a+") 
			save_one_trade_csv:write(txt_trade_string)
			save_one_trade_csv:flush()  
			save_one_trade_csv:close() 
			txt_trade_string = ""
		end
	
		sleep(100)
	end

end

