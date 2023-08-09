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


function main()
	
	
	ds, error_discr = CreateDataSource("TQBR", "ABRD", INTERVAL_M1)
	repeat
		sleep(100)
		indexload = indexload + 1
	until(ds:Size()~=0 or indexload>=10)

	number_of_candles = ds:Size()

	message("Количество свечей в источнике данных: "..number_of_candles)
	
	
	for index = number_of_candles-9, number_of_candles do
		openprice 	= ds:O(index)
		highprice 	= ds:H(index)
		lowprice 	= ds:L(index)
		closeprice 	= ds:C(index)
		volume 		= ds:V(index)
		localtime 	= hhmmss(ds:T(index))
		localdata 	= DDMMYYYY(ds:T(index))
		
		message("Свеча "..index.." data:"..localdata.." time:"..localtime.." open="..openprice.." high="..highprice.." low="..lowprice.." close="..closeprice.." volume="..volume)
		
	end
	
	ds:Close() -- закрыть источник данных
	
end
