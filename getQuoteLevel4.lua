function main()

SumOffer = 0
SumBid = 0

quotelvl = getQuoteLevel2("TQBR", "SBER")

	if quotelvl then
	
		if quotelvl.offer then
			
			message("Предложение:")
			
			for i = quotelvl.offer_count, 1, -1 do
				offer = tonumber(quotelvl.offer[i].price)
				quant = tonumber(quotelvl.offer[i].quantity)
				sum = 10 * offer * quant
				SumOffer = SumOffer + sum 
				message(i..") "..offer.." * "..quant.." * 10 = "..sum.." SumOffer:"..SumOffer)
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
				bsum = 10 * bid * quant
				SumBid = SumBid + bsum
				message(i..") "..bid.." * "..quant.." * 10 = "..bsum.." SumBid:"..SumBid)
			end
		
		else
		
			message("Нет данных по спросу")

		end
		
	end

end