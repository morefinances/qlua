function OnInit()
	indexload = 0
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


function OnStop()
	do_it = false  
	ds:Close() 
end

function main()
	
	do_it = true
	
	ds, error_discr = CreateDataSource("TQBR", "SBER", INTERVAL_M1)
	repeat
		sleep(100)
		indexload = indexload + 1
	until(ds:Size()~=0 or indexload>=10)

	number_of_candles = ds:Size()

	message("Количество свечей в источнике данных: "..number_of_candles)
	
 
	
	
	while do_it do
	
	ds, error_discr = CreateDataSource("TQBR", "SBER", INTERVAL_M1)
	
		if ds:Size()~=number_of_candles and do_it then
		
			if ds:Size() == number_of_candles + 1 then

				number_of_candles = ds:Size()
				
				openprice 	= ds:O(number_of_candles)
				highprice 	= ds:H(number_of_candles)
				lowprice 	= ds:L(number_of_candles)
				closeprice 	= ds:C(number_of_candles)
				volume 		= ds:V(number_of_candles)
				localtime 	= hhmmss(ds:T(number_of_candles))
				localdata 	= DDMMYYYY(ds:T(number_of_candles))
				
				message(number_of_candles.." "..localdata.." "..localtime.." OPEN="..openprice.." HIGH="..highprice.." LOW="..lowprice.." CLOSE="..closeprice.." VOLUME="..volume)
			

			end
		
		
		end
	
		sleep(1000)
	end
	
	
end