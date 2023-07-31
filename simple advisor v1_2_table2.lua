function OnInit()

	tikers = {
	"AFKS" , "AFLT" , "AGRO" , "ALRS" , "CBOM" , "CHMF" , "ENPG" , "FEES" , "FIVE" , "FIXP" , "GAZP" , "GLTR" , "GMKN" , "HYDR" , "IRAO" , "LKOH" , "MAGN" , "MGNT" , "MOEX" , "MTSS" , "NLMK" , "NVTK" , "OZON" , "PHOR" , "PIKK" , "PLZL" , "POLY" , "ROSN" , "RTKM" , "RUAL" , "SBER" , "SBERP" , "SGZH" , "SNGS" , "SNGSP" , "TATN" , "TATNP" , "TCSG" , "TRNFP" , "VKCO" , "VTBR" , "YNDX"
	}
	
	progname = "simple advisor v.1.2 : "
	timeout = 10000
	timeout2 = 25000 -- пауза 25 секунд для проверки старта скрипта
	startind = 0 -- индекс старта скрипта (первой итерации)
	
	-- цветовые константы
	mBlack = RGB(0, 0, 0)
	mWhite = RGB(255, 255, 255)
	mRed = RGB(255, 204, 250)
	mGreen = RGB(199, 254, 236)
	mGray = RGB(226, 226, 226)
	mBlue = RGB(166, 220, 243)   
	
	starttime = 100100
	nonewsignalstime = 174500
	finishtime = 175503
	
	--nomorningtime = 103000
	
end


function OnStop()
	DestroyTable(m_t)
	do_it = false
	message(progname.." Финиш.")
end


function hhmmss(date_time)
	
	local Hour = date_time.hour
	if Hour<10 then Hour = "0"..Hour end
	
	local Min = date_time.min
	if Min<10 then Min = "0"..Min end
	
	local Sec=date_time.sec
	if Sec<10 then Sec="0"..Sec end
		
	return tonumber(Hour..Min..Sec)

end

function table_print(table_text, table_result_ind)

	if table_result_ind <=10 then 
		SetCell(table_result, table_result_ind, 1, table_text)
	else
		InsertRow(table_result,-1)
		SetCell(table_result, table_result_ind, 1, table_text)
	end
	
end

 
function main() 
	
	message(progname.." Старт.")
	message(progname.." starttime = "..starttime)
	message(progname.." nonewsignalstime = "..nonewsignalstime)
	message(progname.." finishtime = "..finishtime)
	
	-- обработка starttime
	while hhmmss(os.sysdate())<starttime do
		local time1 = hhmmss(os.sysdate())
		message('Ожидаем время старта скрипта : '..starttime..", текущее время: "..time1) 
		sleep(timeout2)
	end
	
	do_it = true
	
	size_table = 10 -- количество строк таблицы
	table_result_ind = 1 -- индекс строки
	if table_result==nil then  
		table_result = AllocTable() 
		AddColumn(table_result, 1, "Сигналы и результаты:", true, QTABLE_STRING_TYPE, 70) 
		CreateWindow(table_result) 
		SetWindowPos(table_result,0,430,500,300) 
		SetWindowCaption(table_result, progname.." сообщения скрипта")
		for u = 1, size_table do 
			InsertRow(table_result,-1)	
		end
	end
	
	if m_t==nil then     -- если таблица не создана ранее, то 
		m_t = AllocTable() -- создать таблицу
			AddColumn(m_t, 1, "Тикер", true, QTABLE_STRING_TYPE, 10) 
			AddColumn(m_t, 2, "Бумага", true, QTABLE_STRING_TYPE, 20)
			AddColumn(m_t, 3, "Тек.Цена", true, QTABLE_DOUBLE_TYPE, 10)
			AddColumn(m_t, 4, "Закрытие", true, QTABLE_DOUBLE_TYPE, 10)
			AddColumn(m_t, 5, "Продажи", true, QTABLE_INT64_TYPE, 10)
			AddColumn(m_t, 6, "Покупки", true, QTABLE_INT64_TYPE, 10)
			AddColumn(m_t, 7, "Сигнал", true, QTABLE_STRING_TYPE, 23)
		CreateWindow(m_t)  
		SetWindowPos(m_t,700,0,690,780) 
		SetWindowCaption(m_t, progname.." создание советника") -- показать таблицу, пишем заголовок
		
		-- добавляем строки циклом
		for u = 1, #tikers do 
			InsertRow(m_t,-1)	
		end
		
	end

	closeprice = {} -- создаем массив цен закрытия
	signal = {}
	
	
	for x = 1, #tikers do 
		closeprice[x] = getParamEx("TQBR", tikers[x], "PREVLEGALCLOSEPR") -- цена закрытия предыдущего дня
		signal[x] = 0 -- статус сигнала по инструменту
	end


	while do_it do

		-- заполнение таблицы
		for i = 1, #tikers do
			
			local tLast = getParamEx("TQBR", tikers[i], "LAST") 
			local tOffer = getParamEx("TQBR", tikers[i], "OFFERDEPTHT")  
			local tBid = getParamEx("TQBR", tikers[i], "BIDDEPTHT") 

			
			if startind == 0 then -- вывод неизменямой части таблицы
			
				local tName = getParamEx("TQBR", tikers[i], "SHORTNAME") 
				
				SetCell(m_t, i, 1, tikers[i]) 
				SetCell(m_t, i, 2, tName.param_image)
				SetCell(m_t, i, 4, closeprice[i].param_image)
			end

			SetCell(m_t, i, 3, tLast.param_image)
			SetCell(m_t, i, 5, tOffer.param_image)
			SetCell(m_t, i, 6, tBid.param_image)
			
			time3 = hhmmss(os.sysdate())	

			-- if i == 1 and startind == 0 and time3 >= nomorningtime then
				-- message('Старт после nomorningtime='..nomorningtime)
			-- end			
			
			if tonumber(tOffer.param_value) > 2 * tonumber(tBid.param_value) then
			
				SetColor(m_t, i, 5, mRed, mBlack, mRed, mBlack)
				SetColor(m_t, i, 6, mWhite, mBlack, mWhite, mBlack)
				
				-- отработка сигналов
				if tonumber(tLast.param_value) < tonumber(closeprice[i].param_value) and signal[i] == 0 then 
					
			
					if time3 < nonewsignalstime then
						SetCell(m_t, i, 7, "SHORT")
						table_text = "сигнал SHORT по "..tikers[i].." по цене "..tLast.param_image
						signal[i] = -1 
					else
						SetCell(m_t, i, 7, "no signal SHORT")
						table_text ="пропускаем сигнал на SHORT по таймеру "..nonewsignalstime.." по "..tikers[i].." по цене "..tLast.param_image
						signal[i] = -2 
					end
					
					message(progname..table_text)
					table_print(table_text, table_result_ind)
					table_result_ind = table_result_ind + 1
					
				end
				
			elseif 2 * tonumber(tOffer.param_value) < tonumber(tBid.param_value) then

				SetColor(m_t, i, 5, mWhite, mBlack, mWhite, mBlack)
				SetColor(m_t, i, 6, mGreen, mBlack, mGreen, mBlack)	

				if tonumber(tLast.param_value) > tonumber(closeprice[i].param_value) and signal[i] == 0 then 
					
					if time3 < nonewsignalstime then
						SetCell(m_t, i, 7, "LONG")
						table_text = "сигнал LONG по "..tikers[i].." по цене "..tLast.param_image
						signal[i] = 1 
					else				
						SetCell(m_t, i, 7, "no signal LONG")
						table_text = "пропускаем сигнал LONG по таймеру "..nonewsignalstime.." по "..tikers[i].." по цене "..tLast.param_image
						signal[i] = 2 
					end
 					
					message(progname..table_text)
					table_print(table_text, table_result_ind)
					table_result_ind = table_result_ind + 1
					
				end
				
			else
	
				SetColor(m_t, i, 5, mWhite, mBlack, mWhite, mBlack)
				SetColor(m_t, i, 6, mWhite, mBlack, mWhite, mBlack)
				
				--отработка выхода из сигналов
				if signal[i] ~= 0 then 
					if signal[i] == 1 then
						table_text = "закрытие позиции LONG по "..tikers[i].." по цене "..tLast.param_image
					end
					if signal[i] == -1 then
						table_text = "закрытие позиции SHORT по "..tikers[i].." по цене "..tLast.param_image
					end
					signal[i] = 0
					
					message(progname..table_text)
					table_print(table_text, table_result_ind)
					table_result_ind = table_result_ind + 1
					
				end
				
				SetCell(m_t, i, 7, " ")
				
				
								
			end			
			
			--if table_result_ind == 11 then table_result_ind = 1 end
			
			Highlight(m_t, i, QTABLE_NO_INDEX, mGray, mBlack, 500) -- выделение цветом вносимых изменений
			
			if startind == 0 and i == #tikers then startind = 1 end -- убираем индекс первой итерации
			
			sleep(100)
			 
		end
 
 
		--остановка по таймеру
		local time2 = hhmmss(os.sysdate())
			
		if time2>= finishtime then
			table_text = "скрипт остановлен по таймеру: "..time2
			message(progname..table_text)
			SetCell(table_result, table_result_ind, 1, table_text)
			OnStop()
		end
		
 
 
		if IsWindowClosed(m_t) then OnStop() end
		
		sleep(timeout)
		
	end

end
