function OnInit()
	LASTBID = 0
	LastQBid = 0
	LASTOFFER = 0
	LastQOffer = 0
end

function OnStop()
	do_it = false
end

function OnQuote(class, tiker)

	if class == "TQBR" and tiker == "SBER" then
	
	quotelvl = getQuoteLevel2("TQBR", "SBER")

		if quotelvl and quotelvl.bid then
			
			offer = tonumber(quotelvl.offer[1].price)
			quant_offer = tonumber(quotelvl.offer[1].quantity)
			
			bid = tonumber(quotelvl.bid[tonumber(quotelvl.bid_count)].price)
			quant_bid = tonumber(quotelvl.bid[tonumber(quotelvl.bid_count)].quantity)
			
			if offer~=LASTOFFER or bid ~= LASTBID or quant_offer ~= LastQOffer or quant_bid ~= LastQBid then
			
				message(offer.." ð. "..quant_offer.." / "..bid.." ð. "..quant_bid)
			
				LASTBID = bid
				LastQBid = quant_bid
				LASTOFFER = offer
				LastQOffer = quant_offer			
			
			end
		end
	end
end

function main()
do_it = true
	while do_it do
		sleep(1000)
	end
end

