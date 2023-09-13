function OnInit()
	SumOffer = 0
	SumBid = 0
end

function OnStop()
end

function main()

do_it = true

	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "Продажи", true, QTABLE_INT_TYPE, 12)
		AddColumn(m_t, 2, "Покупки", true, QTABLE_INT_TYPE, 12)
		AddColumn(m_t, 3, "bid/offer", true, QTABLE_DOUBLE_TYPE, 10)
		CreateWindow(m_t)
		SetWindowPos(m_t, 500, 447, 300, 110)
		SetWindowCaption(m_t, "bid/offer анализ")
		InsertRow(m_t,-1)
	
	end



	while do_it do
	
		quotelvl = getQuoteLevel2("TQBR", "SBER")
	
			if quotelvl then
		
				if quotelvl.offer then
					
					
					for i = quotelvl.offer_count, 1, -1 do
						offer = tonumber(quotelvl.offer[i].price)
						quant = tonumber(quotelvl.offer[i].quantity)
						SumOffer = SumOffer + 10 * offer * quant
					end
			
				end
			
				
				if quotelvl.bid then
					
					for i = quotelvl.bid_count, 1, -1 do
						bid = tonumber(quotelvl.bid[i].price)
						quant = tonumber(quotelvl.bid[i].quantity)
						SumBid = SumBid + 10 * bid * quant
					end

				end
				
				SetCell(m_t, 1, 1, tostring(string.format("%.0f",SumOffer)))
				SetCell(m_t, 1, 2, tostring(string.format("%.0f",SumBid)))
				
				if SumBid > 0 then
					a = SumOffer / SumBid
				else
					a = " "
				end
				
				SetCell(m_t, 1, 3, tostring(string.format("%.2f",a)))
				
				SumOffer = 0
				SumBid = 0
			end
	
		sleep(1000)
	end



end