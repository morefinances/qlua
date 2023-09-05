-- вывод ленты покупок в одном направлении
function OnInit()
	do_it = true
	tiker_id = "SBER3_ID"
	progname = "simple advisor v.3.3 : "
	sum = 0
	--trade = 0
	pretrade = 0	-- направление предыдущего трейда
	startindex = 0	-- флаг обработки первой сделки (в этом случае нет предыдущего трейда)
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
		
		if indexstart == 0 then
		
			sum = direction
	
		else
		
			if direction == 1 and pretrade == 1 then sum = sum + 1 end
			
			if direction == -1 and pretrade == -1 then sum = sum - 1 end
			
			if ( direction + pretrade ) == 0 then 
				SetCell(m_t, 1, 1, tostring(string.format("%.0f",sum)))
				sum = direction 
			end
		
		end
		
		if math.abs(sum)==30 or math.abs(sum)==50 or math.abs(sum)==100 then
		
			if sum > 0 then
				dir = 1	
				text = "ѕокупка по: "
			else
				dir = -1	
				text = "ѕродажа по: "
			end
		
			if math.abs(sum) == 100 then						 
				size = 3
			elseif math.abs(sum) == 50 then					 
				size = 2
			else 												 
				size = 1
			end
		
			pointdraw(lastprice, dir, size, tostring(lastprice.." / "..sum))
			message(progname..text.." "..string.format("%.2f", lastprice))
		
		end
		
		
		if indexstart == 0 then indexstart = 1 end				-- снимаем флаг обработки первой сделки
		
		pretrade = direction
		
	end

end

function main()

	message(progname.."старт работы")
	
	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "sum", true, QTABLE_INT_TYPE, 7)
		
		CreateWindow(m_t)
		SetWindowPos(m_t, 500, 447, 200, 110)
		SetWindowCaption(m_t, progname.." анализ2")
		InsertRow(m_t,-1)
	
	end
	
	
	while do_it do 

		SetCell(m_t, 1, 1, tostring(string.format("%.0f",sum)))
		sleep(1000) 
				
	end


end