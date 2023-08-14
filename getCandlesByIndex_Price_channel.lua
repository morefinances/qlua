function OnInit()
	 
end


function hhmmss(date_time)
	
	local Hour = date_time.hour
	if Hour<10 then Hour = "0"..Hour end
	
	local Min = date_time.min
	if Min<10 then Min = "0"..Min end
	
	local Sec=date_time.sec
	if Sec<10 then Sec="0"..Sec end
		
	return Hour..Min..Sec

end


function DDMMYYYY(date_time)

	local DD = date_time.day
	if DD<10 then DD = "0"..DD end
	
	local MM = date_time.month
	if MM<10 then MM = "0"..MM end
		
	local YYYY = date_time.year
		
	return DD..MM..YYYY

end


function main()
	
tiker_price_channel_id = "SBER_PRICECHANNEL_ID"
number_of_candles = getNumCandles(tiker_price_channel_id )
message(""..number_of_candles)

	rsi_upper, m, n = getCandlesByIndex(tiker_price_channel_id, 0, 0, number_of_candles)
	rsi_lower, k, s = getCandlesByIndex(tiker_price_channel_id, 2, 0, number_of_candles)
	
	
	summ = 0
	
	for i = number_of_candles-10, number_of_candles-1 do

		message(i.." "..DDMMYYYY(rsi_upper[i].datetime).." "..hhmmss(rsi_upper[i].datetime).." upper="..rsi_upper[i].close.." lower="..rsi_lower[i].close)

		sleep(10)

	end
	
	message(m.." "..n)
	message(k.." "..s)
	
end