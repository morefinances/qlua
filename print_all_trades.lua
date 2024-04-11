function PrintAllTrades()

	message(string.rep('=', 25))
	local index_active = 0

	number_of_trades = getNumberOf("trades")

	if number_of_trades == 0 then
	
		message("Сделок не было.")
		
	else

		message("Всего сделок : " .. number_of_trades .. " шт.")

		local title_txt = "Numb / trans_id  / order_num / trade_num / class_code / sec_code / direct_operation / qty / price / value / brokerref"
		
		message(title_txt)

		for i = 0, number_of_trades - 1 do
		
			table_all_trades = getItem("trades", i)

			if bit.test(tonumber(table_all_trades.flags), 2) then
				direct_operation = "Sell"
			else
				direct_operation = "Buy"
			end

			local txt_for_trades	= i .. " / " .. table_all_trades.trans_id .. " / " .. table_all_trades.order_num .. " / " .. table_all_trades.trade_num .. " / " .. table_all_trades.class_code .. " / " .. table_all_trades.sec_code .. " / " ..direct_operation .. " / " .. math.floor(table_all_trades.qty) .. " / " .. table_all_trades.price .. " / " .. table_all_trades.value .. " / " .. table_all_trades.brokerref 
			
			message(txt_for_trades)
			
		end
		
	end
	
end


function main()
	PrintAllTrades()
end