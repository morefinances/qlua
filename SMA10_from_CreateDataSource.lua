function OnInit()
	indexload = 0
	N = 10
	summ = 0
end


function main()
	
	ds, error_discr = CreateDataSource("TQBR", "SBER", INTERVAL_M1)
	repeat
		sleep(100)
		indexload = indexload + 1
	until(ds:Size()~=0 or indexload>=10)

	number_of_candles = ds:Size()
	
	message("Количество свечей в источнике данных: "..number_of_candles)
	
	if number_of_candles < N then 
	
		message("Недостаточно данных для расчета")
		message(number_of_candles.." < "..N)
		
	else
	
		for index = number_of_candles-(N-1), number_of_candles do
			
			summ = summ + ds:C(index)
			
		end
		
		message("SMA("..N..")="..summ/N)
		
	end
	
	
	-- закрыть источники данных
	ds:Close() 
	
end
