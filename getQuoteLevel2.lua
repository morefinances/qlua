function main()

quotelvl = getQuoteLevel2("TQBR", "SBER")

	if quotelvl then
	
		if quotelvl.offer then
			
			message("Предложение:")
			
			for i = quotelvl.offer_count, 1, -1 do
				offer = tonumber(quotelvl.offer[i].price)
				quant = tonumber(quotelvl.offer[i].quantity)
				message(i.." : "..offer.." р. /"..quant.." шт.")
			end
	
		
		else
		
			message("Нет данных по предложениям")

		end
	
		message(string.rep("-",10)) -- разделитель
	
		if quotelvl.bid then
			
			message("Спрос:")
			
			for i = quotelvl.bid_count, 1, -1 do
				bid = tonumber(quotelvl.bid[i].price)
				quant = tonumber(quotelvl.bid[i].quantity)
				message(i.." : "..bid.." р. /"..quant.." шт.")
			end
		
		else
		
			message("Нет данных по спросу")

		end
		
	end

end

