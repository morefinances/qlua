function main()

	num_orders = getNumberOf("orders")
	message("Количество заявок : "..num_orders)

	for i = 0, num_orders - 1 do
		
		myorder = getItem("orders", i)
		
		if bit.band(tonumber(myorder["flags"]),1)>0 then 
			message(i..": заявка: "..myorder["order_num"].." цена:"..myorder["price"].." объем: "..myorder["balance"].." комментарий:"..myorder["brokerref"])
		end
		
		sleep(10)
		
	end
	
end 