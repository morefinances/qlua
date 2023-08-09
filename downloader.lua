function OnInit()
	indexload = 0
	size_table = 21 -- количество строк таблицы
	tiker = "SBER"
	timeframe = INTERVAL_H1
	progname = "Скрипт выгрузки котировок, версия 1.0 : "
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


function YYYYDDMM(date_time)
	
	local DD = date_time.day
	if DD<10 then DD = "0"..DD end
	
	local MM = date_time.month
	if MM<10 then MM = "0"..MM end
		
	local YYYY = date_time.year
		
	return YYYY..MM..DD

end

function main()
	
	message(progname.." cтарт.")
	

	ds, error_discr = CreateDataSource("TQBR", tiker , timeframe)
	repeat
		sleep(100)
		indexload = indexload + 1
	until(ds:Size()~=0 or indexload>=10)

	
	number_of_candles = ds:Size()

	message("Количество свечей в источнике данных: "..number_of_candles)

	
	-- сохранение данных в файл
	-- наименование файла: тикер _ дата и время текущий свечи _ дата и время первой свечи
	filename = tiker.."_"..YYYYDDMM(ds:T(number_of_candles))..hhmmss(ds:T(number_of_candles)).."_"..YYYYDDMM(ds:T(1))..hhmmss(ds:T(1)) 
	--размещение файла на C:\files
	DirectionSaveFile=tostring("C:\\files\\"..filename..".csv")
	--создаем файл для записи
	my_csv=io.open(DirectionSaveFile,"a+")

	
	

	if table_result==nil then  
	
		table_result = AllocTable() 
		AddColumn(table_result, 1, "<DATA>", true, QTABLE_DATE_TYPE, 12) 
		AddColumn(table_result, 2, "<TIME>", true, QTABLE_TIME_TYPE, 10) -- QTABLE_STRING_TYPE
		AddColumn(table_result, 3, "<OPEN>", true, QTABLE_DOUBLE_TYPE, 8) 
		AddColumn(table_result, 4, "<HIGH>", true, QTABLE_DOUBLE_TYPE, 8) 
		AddColumn(table_result, 5, "<LOW>", true, QTABLE_DOUBLE_TYPE, 8) 
		AddColumn(table_result, 6, "<CLOSE>", true, QTABLE_DOUBLE_TYPE, 9) 
		AddColumn(table_result, 7, "<VOLUME>", true, QTABLE_INT_TYPE, 15) 
		CreateWindow(table_result) 
		SetWindowPos(table_result,0,440,500,420) 
		SetWindowCaption(table_result, "Выгрузка котировок : "..tiker.." таймфрейм : "..timeframe)
		
		for u = 1, size_table do 
			InsertRow(table_result,-1)	
		end
	end
	
	my_csv:write("<DATA>;<TIME>;<OPEN>;<HIGH>;<LOW>;<CLOSE>;<VOLUME>;\n")
	
	for index = 1, number_of_candles  do
		openprice 	= ds:O(index)
		highprice 	= ds:H(index)
		lowprice 	= ds:L(index)
		closeprice 	= ds:C(index)
		volume 		= ds:V(index)
		localtime 	= hhmmss(ds:T(index))
		localdata 	= YYYYDDMM(ds:T(index))
		
		my_csv:write(localdata..";"..localtime..";"..openprice..";"..highprice..";"..lowprice..";"..closeprice..";"..volume..";\n")
		
		--наполнение таблицы
		if index >= number_of_candles-9 and  index <= (number_of_candles) then
			local linetable = 1 + number_of_candles - index
			SetCell(table_result, linetable, 1, tostring(localdata))
			SetCell(table_result, linetable, 2, tostring(localtime))
			SetCell(table_result, linetable, 3, tostring(openprice))
			SetCell(table_result, linetable, 4, tostring(highprice))
			SetCell(table_result, linetable, 5, tostring(lowprice))
			SetCell(table_result, linetable, 6, tostring(closeprice))
			SetCell(table_result, linetable, 7, tostring(math.floor(volume)))
		end
		
		for i = 1, 7 do
			SetCell(table_result, 11, i, "...")
		end
		
		if index >= 1 and  index <= 10 then
			local linetable = 22 - index
			SetCell(table_result, linetable, 1, tostring(localdata))
			SetCell(table_result, linetable, 2, tostring(localtime))
			SetCell(table_result, linetable, 3, tostring(openprice))
			SetCell(table_result, linetable, 4, tostring(highprice))
			SetCell(table_result, linetable, 5, tostring(lowprice))
			SetCell(table_result, linetable, 6, tostring(closeprice))
			SetCell(table_result, linetable, 7, tostring(math.floor(volume)))
		end
		
	end
	
	-- сохраняем и закрываем файл
	my_csv:flush() 
	my_csv:close()
	
	
	ds:Close() -- закрыть источник данных
	
	message(progname.." завершение.")
	
end
