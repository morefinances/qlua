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
	
tiker_id = "SBER_ID"
number_of_candles = getNumCandles(tiker_id)

	mprice, a, b = getCandlesByIndex(tiker_id, 0, 0, number_of_candles)
	
	for i = 0, number_of_candles, (number_of_candles - 1) do
			openprice 	= mprice[i].open
			highprice 	= mprice[i].high
			lowprice 	= mprice[i].low
			closeprice 	= mprice[i].close
			volume 		= mprice[i].volume
			localtime 	= hhmmss(mprice[i].datetime)
			localdata 	= DDMMYYYY(mprice[i].datetime)

			message(number_of_candles.." "..localdata.." "..localtime.." OPEN="..openprice.." HIGH="..highprice.." LOW="..lowprice.." CLOSE="..closeprice.." VOLUME="..volume)

	end


	message(a.." "..b)
	
end