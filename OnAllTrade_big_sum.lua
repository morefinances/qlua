function OnInit()
	do_it = true
	tiker_id = "SBER2_ID"
	progname = "simple advisor v.3.2 : "
	sum = 0
	msum = {}
end

function OnStop()
	message(progname.."завершение работы")
	do_it = false
end


function pointdraw(price, direction, size, texthint)
	label_params = {
		IMAGE_PATH = getScriptPath() .. "\\point.bmp",
		ALIGNMENT = "LEFT",
		YVALUE = price,
		DATE = tostring(os.date("%Y%m%d")),
		TIME = tostring(os.date('%H%M%S')),
		-- R = 0, 
		-- G = 0,
		-- B = 0,
		TRANSPARENT_BACKGROUND = 1,
		HINT = texthint
	}
	
	if size == 3 then
		label_params.IMAGE_PATH = getScriptPath() .. "\\3point.bmp"
	elseif size == 2 then
		label_params.IMAGE_PATH = getScriptPath() .. "\\2point.bmp"
	else
		label_params.IMAGE_PATH = getScriptPath() .. "\\point.bmp"
	end
	
	if direction == 1 then  
		label_params.TRANSPARENCY = 15
	else
		label_params.TRANSPARENCY = 85
	end
	
	label_id_text = AddLabel(tiker_id, label_params)
end


function OnAllTrade(alltrade)
	
	if alltrade.sec_code=="SBER" then
	
		lastprice	= alltrade.price 	-- цена
		lastvolume	= alltrade.qty 		-- количество
		
		if bit.test(alltrade.flags, 0) then direction = -1 end 	-- направление сделки: продажа
		if bit.test(alltrade.flags, 1) then direction = 1 end	-- направление сделки: покупка
		
		sum = sum + direction * lastvolume						-- накапливаем сумму с учетом 
																-- направления последней сделки
		table.insert(msum, direction * lastvolume)				-- добавляем в массив направление и количество
		
		if #msum >= 21 then 
			sum = sum - msum[1]									-- если массив стал >= 21, то вычитаем первое значение из sum
			table.remove(msum, 1)								-- аналогично удаляем 1й элемент из массива
		end
			
		if math.abs(sum) >= 2000 and #msum==20 then				-- сравниваем по модулю sum
																-- для определения размера метки
			if math.abs(sum) >= 5000 then						-- при >= 5000 3й
				size = 3
			elseif math.abs(sum) >= 3000 then					-- при >= 3000 2й
				size = 2
			else 												-- при >= 2000 1й
				size = 1
			end
		
			if sum > 0 then 									-- определяем направление сигнала
				dir = 1											-- при положительном sum лонг
				text = "Покупка по: "
			else	
				dir = -1 										-- при отрицательном шорт
				text = "Продажа по: "
			end
		
			pointdraw(lastprice, dir, size, tostring(lastprice.." / "..sum)) -- вывод метки на график
																			 -- дублируем в окно сообщений
			message(progname..text.." "..string.format("%.2f", lastprice).." sum: "..string.format("%.0f",sum))
			sum = 0    											-- обнуляем после сигнала сумму
			msum = {}											-- и массив
		
		end
			
	end

end

function main()

	message(progname.."старт работы")
	
	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "sum", true, QTABLE_INT_TYPE, 7)
		AddColumn(m_t, 2, "#msum", true, QTABLE_INT_TYPE, 6)
		
		CreateWindow(m_t)
		SetWindowPos(m_t, 500, 447, 200, 110)
		SetWindowCaption(m_t, progname.." анализ")
		InsertRow(m_t,-1)
	
	end
	
	
	while do_it do 

		SetCell(m_t, 1, 1, tostring(string.format("%.0f",sum)))
		SetCell(m_t, 1, 2, tostring(#msum))
		sleep(1000) 
				
	end


end
