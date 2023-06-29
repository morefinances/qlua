-- To read comments, use the encoding:: Windows-1251

--[[
Скрипт выгрузки котировок цен OHLC, Value (оборот в руб.), LegalClosePrice (закрытие дневной сессии в18:50); ClosePrice (закрытие в 23:50), 
плюс LegalClosePrice и ClosePrice предыдущей торговой сессии.

Cкрипт запускается по таймеру (HTimeOut – час выгрузки по МСК, MTimeOut — минуты),
делает выгрузку всей необходимой информации из таблицы текущих торгов. 
Тикеры берутся из только что полученного файла C:\files\tickers.csv (его готовит скрипт moextickers.lua  https://github.com/morefinances/qlua). 

Я запускаю параллельно 2 подобных скрипта, один делает выгрузку в 18:55 под закрытие основной сессии, 
после чего сам выключается, второй в 23:55 и также выключается.

Файл записывает логи по которым можно смотреть всё ли прошло нормально в logs.csv.

В процессе выгрузки если получены нулевые значения, то скрипт ожидает 100 мс и перезапрашивает данные, 
если за 10 итераций ничего не получено (значит ничего и нет), то переходит далее. 

В списке (tickers) всегда есть бумаги, по которым торги не проводятся, но биржа их при этом отражает как торгуемые (через iss запросы они аналогично выгружаются с нулевыми объемами, но индикативными ценами).

Предусмотрено, что может отключаться сервер, скрипт ждет восстановления связи. 
Если далее связь возобновляется скрипт продолжает дожидаться нужного времени и штатно делает выгрузку. 

Если через 7 часов после старта (я запускаю в начале 6го) выгрузка не состоялась скрипт по таймеру (indTimer) выключает работу. Если ваш компьютер уходит в спящий режим, то скорее всего и терминал «засыпает». Поэтому у меня стоит в настройках никогда не уходить в спящий режим, чтобы всё корректно работало.

Результаты записываются в файлы downloads с датой и временем выгрузки в названии файла всё в той же C:\files\ директории.

Статусы текущих состояний работы скриптов выводятся в отдельные таблички.
]]--

function OnInit()

	--параметры таймера:
	HTimeOut=15 -- час по МСК и
	MTimeOut=15 -- минуты запуска 
				-- процедуры выгрузку данных
	
	-- наименования колонок таблицы статуса работы скрипта
	NameTableColumns = {'старт', 'таргет', 'текущий статус', 'время начала выгрузки'} 
	QCTanbles = {9, 7, 55, 33}
	
	-- координаты по Y расположения таблиц скрипта. 
	YPosConsts = {447, 526}
	
	-- тот что до 19 запускается будет чуть выше.
	if HTimeOut <= 19 then 
		YPosTables = YPosConsts[1] 
	else
		YPosTables = YPosConsts[2]
	end
	
	indTimer = 1680 -- таймер отключит скрипт через 7 часов (4*60*7=1680)
	
	--дополнительные нули для корректного вывода времени
	if HTimeOut < 10 then 
		otxt = "0"
	else
		otxt = ""
	end
	
	if MTimeOut < 10 then
		ttxt = "0"
	else
		ttxt = ""
	end
	
	WorkPath="C:\\files\\"  -- рабочая директория, где находится tickers.csv 
							-- и куда будут сохраняться логи (logs.csv) и файл с котировками.
	
	-- версии скрипта для логов и анализа сообщений
	-- особенно полезно, когда скриптов несколько
	ProgramSmallName="dwnlds "..otxt..HTimeOut..":"..ttxt..MTimeOut
	ProgramName="выгрузка цен закрытия и объемов торгов"
	ProgramVersion="1.0.6. от 29.06.2023"
	
end



function OnStop()

	DirectionSaveFile=tostring(WorkPath.."logs.csv") 
	my_csv=io.open(DirectionSaveFile,"a+") 

	if ind == 1 then
		message("Скрипт "..ProgramSmallName.." остановлен по завершению работы", 2)
		my_csv:write("Скрипт "..ProgramSmallName.." остановлен по завершению работы\n")
		SetCell(m_t, 1, 3, "Скрипт остановлен по завершению работы")
		Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
		SetColor(m_t, 1, QTABLE_NO_INDEX, RGB(166, 220, 243), RGB(0,0,0), RGB(149,200,216), RGB(0,0,0))
		end 
		
	if ind == 0 then	
		message("Скрипт "..ProgramSmallName.." остановлен пользователем")	
		my_csv:write("Скрипт "..ProgramSmallName.." остановлен пользователем\n")
		SetCell(m_t, 1, 3, "Скрипт остановлен пользователем")
		Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
		SetColor(m_t, 1, QTABLE_NO_INDEX, RGB(197, 220, 243), RGB(0,0,0), RGB(149,200,216), RGB(0,0,0))
		end
		
	if ind == -1 then
		message("Скрипт "..ProgramSmallName.." остановлен в период разрыва соединения", 3)
		my_csv:write("Скрипт "..ProgramSmallName.." остановлен в период разрыва соединения\n")
		SetCell(m_t, 1, 3, "Скрипт остановлен в период разрыва соединения")
		Highlight(m_t, 1, 3, RGB(160, 160, 160), RGB(0,0,0), 600)
		SetColor(m_t, 1, QTABLE_NO_INDEX, RGB(224, 224, 224), RGB(0,0,0), RGB(149,200,216), RGB(0,0,0))
		end
	
	if ind == 2 then
		message("Скрипт "..ProgramSmallName.." остановлен по таймеру [ n >= "..indtre.." ] ", 3)
		my_csv:write("Скрипт "..ProgramSmallName.." остановлен по таймеру [ n >= "..indtre.." ] \n")
		SetCell(m_t, 1, 3, "Скрипт остановлен по таймеру [ n >= "..indtre.." ]")
		Highlight(m_t, 1, 3, RGB(160, 160, 160), RGB(0,0,0), 600)	
		SetColor(m_t, 1, QTABLE_NO_INDEX, RGB(224, 224, 224), RGB(0,0,0), RGB(149,200,216), RGB(0,0,0))		
		end
		
	myRun=false
	message("<--- завершение "..ProgramSmallName..": "..ProgramName.." --->")
	message("===========================================")
	my_csv:write("<--- завершение "..ProgramSmallName..": "..ProgramName.." --->\n")
	my_csv:write("===========================================\n")

	my_csv:flush()  
	my_csv:close() 
	sleep(10)
	
end


function downloadsdata()

	message("<-- "..ProgramSmallName.." -->")
	message("<-- выгрузка данных -->")
	message("подгрузка тикеров с "..WorkPath.."tickers.csv")

	-- выгрузка тикеров С:\files\moextickers.csv
	t = {}
	DirectionOpenFile=tostring(WorkPath.."tickers.csv") 
	f = io.open(DirectionOpenFile, "r");
	for i=1, 300 do
		t[i] = f:read("*l")
		if t[i]==nil then break end
		end
	f:close()

	message(ProgramSmallName.." Выгружено "..tostring(#t).." тикеров")

	
	
	-- создание файла
		datetime = os.date("!*t",os.time())
	
	Hou_one = datetime.hour
	Min_one = datetime.min
	Sec_one = datetime.sec
	Total_one = Hou_one * 60 * 60 + Min_one * 60 + Sec_one
	
	mdate=getTradeDate()
	
	if mdate.day<10 then
		clockdate = " 0"..mdate.day
	else
		clockdate = mdate.day
	end	
	
	if mdate.month < 10 then
		clockdate = clockdate.." 0"..mdate.month.." "..mdate.year
	else
		clockdate = clockdate.." "..mdate.month.." "..mdate.year
	end
	
	if (Hou_one + 3) < 10 then
		clocknamefile = "0"..tostring(Hou_one + 3)
	else
		clocknamefile = tostring(Hou_one + 3)
	end
	
	if Min_one < 10 then
		clocknamefile = clocknamefile.." ".."0"..Min_one
	else
		clocknamefile = clocknamefile.." "..Min_one
	end	
	
	if Sec_one < 10 then
		clocknamefile = clocknamefile.." ".."0"..Sec_one
	else
		clocknamefile = clocknamefile.." "..Sec_one
	end	
	
 
	DirectionSaveFile=tostring(WorkPath.."downloads "..clockdate.." "..clocknamefile..".csv") 
	my_csv=io.open(DirectionSaveFile,"a+") 
	
	--LEGALCLOSEPRICE 	18:45 /  Цена закрытия основной сессии 
	--CLOSE 			23:50 /  Цена закрытия дневной свечи (+ вечерняя сессия, если есть)
	
	if (Hou_one + 3) < 23 then
		my_csv:write("Тикер; OPEN; HIGH; LOW; LASTPRICE; Оборот (на 18:50); LCP; preLCP; preCP; LCP = LegalClosePrice (18:50); CP = ClosePrice (23:50) \n")
	else
		my_csv:write("Тикер; Open; High; Low; LastPrice; Оборот (на 23:50); LCP; CP ; preCP; LCP = LegalClosePrice (18:50); CP = ClosePrice (23:50)\n")
	end
		
	
	openprice = {}
	highprice={}
	lowprice = {}
	lastprice = {}
	closeprice = {}
	legalcloseprice = {}
	prevlegalcloseprice = {}
	value = {}
	
	
	for i = 1, #t do
	
		-- проверка на торгуемость
		if getParamEx("TQBR",t[i],'STATUS').param_value == 0 then
			message(ProgramSmallName..' Тикер '..t[i]..' не торгуется')
			my_csv:write(t[i].."; Не торгуется;\n")
			sleep(5)
		else
			openprice[i] = tonumber(getParamEx("TQBR",t[i],'OPEN').param_value)
	
			if openprice[i] == 0 then
				for u=1, 10 do
					sleep(100)
					openprice[i] = tonumber(getParamEx("TQBR",t[i],'OPEN').param_value)
					message(ProgramSmallName.." "..t[i]..": openprice_"..u)
					if openprice[i]~=0 then break end
				end
			end
			
			highprice[i] = tonumber(getParamEx("TQBR",t[i],'HIGH').param_value)
			
			if highprice[i] == 0 then
				for u=1, 10 do
					sleep(100)
					highprice[i] = tonumber(getParamEx("TQBR",t[i],'HIGH').param_value)
					message(ProgramSmallName.." "..t[i]..": highprice_"..u)
					if highprice[i]~=0 then break end
				end
			end
			
			lowprice[i] = tonumber(getParamEx("TQBR",t[i],'LOW').param_value)
			
			if lowprice[i] == 0 then
				for u=1, 10 do
					sleep(100)
					lowprice[i] = tonumber(getParamEx("TQBR",t[i],'LOW').param_value)
					message(ProgramSmallName.." "..t[i]..": lowprice_"..u)
					if lowprice[i]~=0 then break end
				end
			end
			
			lastprice[i] = tonumber(getParamEx("TQBR",t[i],'LAST').param_value)
			
			if lastprice[i] == 0 then
				for u=1, 10 do
					sleep(100)
					lastprice[i] = tonumber(getParamEx("TQBR",t[i],'LAST').param_value)
					message(ProgramSmallName.." "..t[i]..": lastprice_"..u)
					if lastprice[i]~=0 then break end
				end
			end
			
			legalcloseprice[i] = tonumber(getParamEx("TQBR",t[i],'LCLOSEPRICE').param_value)
			
			if legalcloseprice[i] == 0 and (Hou_one + 3) >= 18 then
				for u=1, 10 do
					sleep(1000)
					legalcloseprice[i] = tonumber(getParamEx("TQBR",t[i],'LCLOSEPRICE').param_value)
					message(ProgramSmallName.." "..t[i]..": legalcloseprice_"..u)
					if tonumber(legalcloseprice[i]~=0) then break end
				end
			end

			closeprice[i] = tonumber(getParamEx("TQBR",t[i],'PREVPRICE').param_value)
			
			-- убрано and ((Hou_one + 3) < 10 or (Hou_one + 3) >= 23),
			-- т.к. он в основную сессию выдает цену предыдущего дня  
			if closeprice[i] == 0 then 
				for u=1, 10 do
					sleep(1000)
					closeprice[i] = tonumber(getParamEx("TQBR",t[i],'PREVPRICE').param_value)
					message(ProgramSmallName.." "..t[i]..": prevprice~close"..u)
					if closeprice[i]~=0 then break end
				end
			end
			
			prevlegalcloseprice[i] = tonumber(getParamEx("TQBR",t[i],'PREVLEGALCLOSEPR').param_value)
			
			-- and ((Hou_one + 3) < 10 or (Hou_one + 3) >= 23)
			if prevlegalcloseprice[i] == 0  then
				for u=1, 10 do
					sleep(1000)
					prevlegalcloseprice[i] = tonumber(getParamEx("TQBR",t[i],'PREVLEGALCLOSEPR').param_value)
					message(ProgramSmallName.." "..t[i]..": prevlegalcloseprice"..u)
					if closeprice[i]~=0 then break end
				end
			end
			
			value[i] = tonumber(getParamEx("TQBR",t[i],'VALTODAY').param_value)
			
			if value[i] == 0 then
				for u=1, 10 do
					sleep(250)
					value[i] = tonumber(getParamEx("TQBR",t[i],'VALTODAY').param_value)
					message(ProgramSmallName.." "..t[i]..": value_"..u)
					if tonumber(value[i]~=0) then break end
				end
			end
			
			message(ProgramSmallName.." "..t[i].." : OPEN="..tostring(myint(openprice[i],2)).." / HIGH="..tostring(myint(highprice[i],2)).." / LOW="..tostring(lowprice[i]).."/ LAST= "..tostring(myint(lastprice[i],0)))
			message(ProgramSmallName.." "..t[i].." : legalCP="..tostring(myint(legalcloseprice[i],2)).." / CP="..tostring(myint(closeprice[i],2)).." / PLCP="..tostring(prevlegalcloseprice[i]).."/ V= "..tostring(myint(value[i],0)))
			my_csv:write(t[i]..";"..openprice[i]..";"..highprice[i]..";"..lowprice[i]..";"..lastprice[i]..";"..value[i]..";"..legalcloseprice[i]..";"..prevlegalcloseprice[i]..";"..closeprice[i]..";\n")
			sleep(10)
			
		end
		
		sleep(10)
		end
	
	my_csv:flush()  
	my_csv:close() 

	datetime = os.date("!*t",os.time())
	
	Hou_two = datetime.hour
	Min_two = datetime.min
	Sec_two = datetime.sec
	Total_two = Hou_two * 60 * 60 + Min_two * 60 + Sec_two
	
	message(ProgramSmallName.." Время выгрузки: "..tostring(Total_two-Total_one).." сек.")
	message(ProgramSmallName.." <-- завершение процедуры выгрузки -->")
	
	
end

-- вывод чисел: отсекаем хвосты 000
function myint(numb, qual)
	
	if qual == 0 then
		return(tostring(math.floor(numb)))
	end
	
	if qual == 1 then
		b = math.floor(numb)
		c = math.ceil((numb - b)*10)
		--message(b.."."..tostring(c))
		return (b.."."..tostring(c))
	end
	
	if qual == 2 then
		b = math.floor(numb)
		c = math.ceil((numb - b)*100)
		if c == 0 then 
			return(b.."."..tostring(c).."0")
		else
			return(b.."."..tostring(c))
		end
	end
	
end



function main()
 
-- создаём таблицу статусов скрипта
if m_t==nil then
	m_t=AllocTable()
		for m=1, 4 do
			AddColumn(m_t, m, NameTableColumns[m], true, QTABLE_STRING_TYPE, QCTanbles[m])
		end
	CreateWindow(m_t)
	SetWindowPos(m_t, 0, YPosTables, 706, 80)
	SetWindowCaption(m_t, ProgramSmallName..": "..ProgramName.." "..ProgramVersion)
	InsertRow(m_t,-1)	
end


	myRun=true -- пока true всё работает
	
	message("===========================================", 2)
	message("<--- cтарт "..ProgramSmallName..": "..ProgramName.." --->", 2)	
	message("<--- версия: "..ProgramVersion.." --->", 2)	
	message('Дата запуска: '..os.date("%d.%m.%Y"), 2)
	message('Время старта: '..os.date("%X",os.time()), 2)
	SetCell(m_t, 1, 1, tostring(os.date("%X",os.time())))
	SetCell(m_t, 1, 2, otxt..HTimeOut..":"..ttxt..MTimeOut)
	SetCell(m_t, 1, 3, "старт программы")
	Highlight(m_t, 1, QTABLE_NO_INDEX, RGB(149,200,216), RGB(0,0,0), 600)
	sleep(10)
	
	--дублируем в логи
	DirectionSaveFile=tostring(WorkPath.."logs.csv") 
	my_csv=io.open(DirectionSaveFile,"a+") 
	my_csv:write("===========================================\n")
	my_csv:write("<--- cтарт "..ProgramSmallName..": "..ProgramName.." --->\n")
	my_csv:write("<--- версия: "..ProgramVersion.." --->\n")	
	my_csv:write('Дата запуска: '..os.date("%d.%m.%Y").."\n")
	my_csv:write('Время старта: '..os.date("%X",os.time()).."\n")
	my_csv:flush()  
	my_csv:close() 
	sleep(10)

	ind = 0 -- счетчик выключения программы
	indtwo = 0 -- индикатор первой итерации
	MM = 0 -- запись минут
	indtre = 0 -- счетчик для отключения по таймеру
	
	while myRun do
	

		-- обработка таймера
		datetime = os.date("!*t",os.time())
		mHou = datetime.hour + 3
		mMin = datetime.min
		mSec = datetime.sec
		
		TimerVar = mHou * 3600 + mMin * 60 + mSec
		cnct = isConnected()
		
		
		if indtwo == 0 then 
		
		DirectionSaveFile=tostring(WorkPath.."logs.csv") 
		my_csv=io.open(DirectionSaveFile,"a+") 
		
			if cnct == 1 then
				if ind >= 0 then 
					message(ProgramSmallName.." <-- Связь с сервером на старте установлена -->", 2)
					my_csv:write(ProgramSmallName.." <-- Связь с сервером на старте установлена -->\n")
					SetCell(m_t, 1, 3, "Связь с сервером на старте установлена")
					Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
					sleep(10)
				end
			else
				message(ProgramSmallName.." <-- Связь с сервером на старте разорвана -->", 3)
				my_csv:write(ProgramSmallName.." <-- Связь с сервером на старте разорвана -->\n")
				SetCell(m_t, 1, 3, "Связь с сервером на старте разорвана")
				Highlight(m_t, 1, 3, RGB(160, 160, 160), RGB(0,0,0), 600)
				ind = -1
				OnStop()
				myRun = false
			end
		
		--	закрытие файла
		my_csv:flush()  
		my_csv:close() 
		sleep(10)		
		
		end
	
		if ind == -1 and cnct == 1 then
			DirectionSaveFile=tostring(WorkPath.."logs.csv") 
			my_csv=io.open(DirectionSaveFile,"a+") 
			
			if mMin<10 then
				stxtone="0"
			else
				stxtone=""
			end
			
			if mSec<10 then
				stxttwo="0"
			else
				stxttwo=""
			end
			
			message(ProgramSmallName..": Связь восстановлена в "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec, 2)
			my_csv:write(ProgramSmallName..": Связь восстановлена в "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."\n")
			SetCell(m_t, 1, 3, "Связь восстановлена в "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec)
			Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
			
			my_csv:flush()  
			my_csv:close() 
			sleep(10)	
			
			ind = 0
			indtwo = 0
			MM = 0
		end
	
		
		if cnct == 0 and indtwo == 1 then
		
			if mMin<10 then
				stxtone="0"
			else
				stxtone=""
			end
			
			if mSec<10 then
				stxttwo="0"
			else
				stxttwo=""
			end
			
			DirectionSaveFile=tostring(WorkPath.."logs.csv") 
			my_csv=io.open(DirectionSaveFile,"a+") 
			
			message(ProgramSmallName..": <-- Связь с сервером прервана "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.." -->", 3)
			message(ProgramSmallName.." Переход в спящий режим, ждём возобновления связи", 3)
			SetCell(m_t, 1, 3, "Связь с сервером прервана "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec)
			Highlight(m_t, 1, 3, RGB(160, 160, 160), RGB(0,0,0), 600)
			
			my_csv:write(ProgramSmallName..": <-- Связь с сервером прервана "..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.." -->\n")
			my_csv:write(ProgramSmallName.." Переход в спящий режим, ждём возобновления связи\n")
			
			my_csv:flush()  
			my_csv:close() 
			sleep(10)
			
			ind = -1
			indtwo = -1
			
		end

		-- обработка первой итерации
		if indtwo == 0 then 
			MM = TimerVar
			indtwo = 1
		end
			
		if mHou >= HTimeOut and mMin >= MTimeOut and cnct == 1 then 
		
			if mMin<10 then
				stxtone="0"
			else
				stxtone=""
			end
			
			if mSec<10 then
				stxttwo="0"
			else
				stxttwo=""
			end
			
			SetCell(m_t, 1, 3, "Процедура выгрузки данных")
			Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
			
			DirectionSaveFile=tostring(WorkPath.."logs.csv") 
			my_cs=io.open(DirectionSaveFile,"a+") 
		
			message(ProgramSmallName.." Timer downloads: "..mHou..":"..stxtone..tostring(mMin)..":"..stxttwo..tostring(mSec), 2)
			my_cs:write(ProgramSmallName.." Timer downloads: "..mHou..":"..stxtone..tostring(mMin)..":"..stxttwo..tostring(mSec).."\n")
			SetCell(m_t, 1, 4, " Timer downloads: "..mHou..":"..stxtone..tostring(mMin)..":"..stxttwo..tostring(mSec))	
				
			my_cs:flush()  
			my_cs:close() 
			sleep(10)
			
			
			downloadsdata()
			ind = 1
		end
		
		-- вывод статуса работы скрипта через каждые 5 минут
		if TimerVar >= (MM + 5*60)  then
			
			if mMin<10 then
				stxtone="0"
			else
				stxtone=""
			end
			
			if mSec<10 then
				stxttwo="0"
			else
				stxttwo=""
			end
			
			--открываем файл для записи логов
			DirectionSaveFile=tostring(WorkPath.."logs.csv") 
			my_csv=io.open(DirectionSaveFile,"a+") 

			
			if cnct == 1 then
				message(ProgramSmallName.." timer ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."]")
				-- фиксируем логи
				my_csv:write(ProgramSmallName.." timer ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."]\n")
				SetCell(m_t, 1, 3, "режим ожидания ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."]")
				Highlight(m_t, 1, 3, RGB(149, 200, 216), RGB(0,0,0), 600)
				sleep(10)
			end
			
			if cnct == 0 then
				message(ProgramSmallName.." timer ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."] без сервера", 3)
				-- фиксируем логи
				my_csv:write(ProgramSmallName.." timer ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."] без сервера\n")
				SetCell(m_t, 1, 3, " режим ожидания ["..mHou..":"..stxtone..mMin..":"..stxttwo..mSec.."] без сервера")
				Highlight(m_t, 1, 3, RGB(160, 160, 160), RGB(0,0,0), 600)
				sleep(10)
			end
			
			-- закрываем файл
			my_csv:flush()  
			my_csv:close() 
			sleep(10)
			
			MM = TimerVar
		end
		
		-- если всё выгрузили, то штатно сворачиваем работу
		if ind == 1 then OnStop() end
		
		-- счетчик в базовом варианте выставлен на 7 часов
		-- в самом начале скрипта
		if indtre >= indTimer then
			ind = 2
			OnStop()
			end
				
		--ожидание 15 секунд для разгрузки процессора
		sleep(15000)	

		indtre = indtre + 1
		
	end

end