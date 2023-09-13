function main()

N = 10000000

quotelvl = getQuoteLevel2("TQBR", "SBER")

	if quotelvl then
	
		if quotelvl.offer then
			
			for i = 1, quotelvl.offer_count do
				
				offer = tonumber(quotelvl.offer[i].price)
				
				if i == 1 then
					message("Текущая цена предложения: "..offer )
					startprice = offer 
				end
				
				quant = tonumber(quotelvl.offer[i].quantity)
				
				sum = quant * offer * 10
				N = N - sum
				message(i..") "..offer.." * "..quant.." * 10 = "..sum.." N="..N)
				
				if N <= 0 or i == quotelvl.offer_count then
					message("Цена при покупке поднимется cо "..startprice.." до: "..offer )
					break
				end
				
			end
	
	
		end

		
	end

end

