function main()

	num_orders = getNumberOf("orders")
	message("Количество заявок всего: "..num_orders)
	num_active_order = 0

	for i = 0, num_orders - 1 do
		
		myorder = getItem("orders", i)

		if bit.band(tonumber(myorder["flags"]),1) > 0 then 
			message(i..": заявка: "..myorder["order_num"].." цена:"..myorder["price"].." объем: "..myorder["balance"].." комментарий:"..myorder["brokerref"])
			num_active_order = num_active_order + 1
		end
		
		sleep(10)
		
	end
	
	message("Всего количество активных заявок : "..num_active_order)
	
end 

