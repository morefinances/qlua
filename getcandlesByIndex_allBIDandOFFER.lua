function OnInit()
	 
end



function main()
	
	
tiker_bid_id = "SBER_BID"
tiker_offer_id = "SBER_OFFER"

number_of_candles_bid = getNumCandles(tiker_bid_id)
number_of_candles_offer = getNumCandles(tiker_offer_id)

BID_from_graph, a, b = getCandlesByIndex(tiker_bid_id, 0, 0, number_of_candles_bid)
OFFER_from_graph, c, d = getCandlesByIndex(tiker_offer_id, 0, 0, number_of_candles_offer)

for i = number_of_candles_bid-10, number_of_candles_bid-1 do

	message("Свеча : "..i)
	message("Общий спрос : "..BID_from_graph[i].close)
	message("Общее предл.: "..OFFER_from_graph[i].close)

end

message(a.." "..b)
message(c.." "..d)
	
end