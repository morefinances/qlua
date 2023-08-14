function OnInit()
end

function main()

	tiker_id = "SBER_ID"
	number_of_candles = getNumCandles(tiker_id)
	message(""..number_of_candles)

	mprice, m, n = getCandlesByIndex(tiker_id, 0, 0, number_of_candles)
	
	summ = 0
	ind = 1
	
	for i = number_of_candles-19, number_of_candles-1 do

		if i <= number_of_candles-10 then summ = summ + mprice[i].close end

		if i == number_of_candles-10 then
			SMA = summ/10
			message(i.." SMA10["..ind.."] по формуле = "..SMA)
			ind = ind + 1		
		end

		if i > number_of_candles-10 then
			SMA = SMA - mprice[i-10].close/10 + mprice[i].close/10
			message(i.." SMA10["..ind.."] по формуле = "..SMA)
			ind = ind + 1
		end

		sleep(10)

	end
	
	tiker_sma_id = "SBER_SMA_ID"
	number_of_candles_sma = getNumCandles(tiker_sma_id)
	SMA_from_graph, a, b = getCandlesByIndex(tiker_sma_id, 0, 0, number_of_candles_sma)

	for i = number_of_candles_sma-10, number_of_candles_sma-1 do
		message(i.." SMA с графика: "..SMA_from_graph[i].close)
	end
	
end