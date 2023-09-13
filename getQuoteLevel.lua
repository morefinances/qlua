function main()

quotelvl = getQuoteLevel2("TQBR", "SBER")

	if quotelvl then
	
		if quotelvl.offer then
			
			offer = tonumber(quotelvl.offer[1].price)
			quant = tonumber(quotelvl.offer[1].quantity)
			
			message("Лучшая цена предложения : "..offer)
			message("Количество при данной цене : "..quant)
			message("Количество котировок офферов : "..quotelvl.offer_count)
		
		else
		
			message("Нет данных по предложениям")

		end
	
		if quotelvl.bid then
			
			bid = tonumber(quotelvl.bid[tonumber(quotelvl.bid_count)].price)
			quant = tonumber(quotelvl.bid[tonumber(quotelvl.bid_count)].quantity)
			
			message("Лучшая цена спроса : "..bid)
			message("Количество при данной цене : "..quant)
			message("Количество котировок спроса : "..quotelvl.bid_count)
		
		else
		
			message("Нет данных по спросу")

		end

	end

end

