function OnInit()

	tikers = {
	"AFKS" , "AFLT" , "AGRO" , "ALRS" , "CBOM" , "CHMF" , "ENPG" , "FEES" , "FIVE" , "FIXP" , "GAZP" , "GLTR" , "GMKN" , "HYDR" , "IRAO" , "LKOH" , "MAGN" , "MGNT" , "MOEX" , "MTSS" , "NLMK" , "NVTK" , "OZON" , "PHOR" , "PIKK" , "PLZL" , "POLY" , "ROSN" , "RTKM" , "RUAL" , "SBER" , "SBERP" , "SGZH" , "SNGS" , "SNGSP" , "TATN" , "TATNP" , "TCSG" , "TRNFP" , "VKCO" , "VTBR" , "YNDX"
	}
	
	progname = "simple advisor v.1 :"
	timeout = 10000
	startind = 0 -- индекс старта скрипта (первой итерации)
	
	-- цветовые константы
	mBlack = RGB(0,0,0)
	mWhite = RGB(255,255,255)
	mRed = RGB(255,204,250)
	mGreen = RGB(199,254,236)
	mGray = RGB(226,226,226)
end


function OnStop()
	DestroyTable(m_t)
	do_it = false
	message(progname.." Финиш.")
end

 
function main() 
	
	message(progname.." Старт.")

	do_it = true
	
	if m_t==nil then     -- если таблица не создана ранее, то 
		m_t=AllocTable() -- создать таблицу
			AddColumn(m_t, 1, "Тикер", true, QTABLE_STRING_TYPE, 10) 
			AddColumn(m_t, 2, "Бумага", true, QTABLE_STRING_TYPE, 20)
			AddColumn(m_t, 3, "Тек.Цена", true, QTABLE_STRING_TYPE, 10)
			AddColumn(m_t, 4, "Закрытие", true, QTABLE_STRING_TYPE, 10)
			AddColumn(m_t, 5, "Продажи", true, QTABLE_STRING_TYPE, 10)
			AddColumn(m_t, 6, "Покупки", true, QTABLE_STRING_TYPE, 10)
			AddColumn(m_t, 7, "Сигнал", true, QTABLE_STRING_TYPE, 10)
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
			
			
			
			if tonumber(tOffer.param_value) > 2 * tonumber(tBid.param_value) then
				SetColor(m_t, i, 5, mRed, mBlack, mRed, mBlack)
				SetColor(m_t, i, 6, mWhite, mBlack, mWhite, mBlack)
				
				if tonumber(tLast.param_value) < tonumber(closeprice[i].param_value) then 
					
					SetCell(m_t, i, 7, "SHORT")
					
					if signal[i] == 0 then
						message(progname.." сигнал SHORT по "..tikers[i].." по цене "..tLast.param_image)
						signal[i] = -1 
					end
					
				end
				
			elseif 2 * tonumber(tOffer.param_value) < tonumber(tBid.param_value) then

				SetColor(m_t, i, 5, mWhite, mBlack, mWhite, mBlack)
				SetColor(m_t, i, 6, mGreen, mBlack, mGreen, mBlack)	

				if tonumber(tLast.param_value)>tonumber(closeprice[i].param_value) then 
					
					SetCell(m_t, i, 7, "LONG")
					
					if signal[i] == 0 then
						message(progname.." сигнал LONG по "..tikers[i].." по цене "..tLast.param_image)
						signal[i] = 1 
					end
					
				end
				
			else
	
				SetColor(m_t, i, 5, mWhite, mBlack, mWhite, mBlack)
				SetColor(m_t, i, 6, mWhite, mBlack, mWhite, mBlack)
				
				SetCell(m_t, i, 7, " ")
				
				if signal[i] ~= 0 then signal[i] = 0 end
								
			end			
			
			Highlight(m_t, i, QTABLE_NO_INDEX, mGray, mBlack, 500) -- выделение цветом вносимых изменений
			
			if startind == 0 and i == #tikers then startind = 1 end -- убираем индекс первой итерации
			
			sleep(100)
			 
		end
 
 
		if IsWindowClosed(m_t) then OnStop() end
		
		sleep(timeout)
		
	end

end
