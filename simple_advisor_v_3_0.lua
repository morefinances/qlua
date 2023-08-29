function OnInit()
	do_it = true
	tiker_id = "SBER_ID"
	progname = "simple advisor v.3.0 : "
end

function OnStop()
	message(progname.." завершение работы")
	do_it = false
end


function pointdraw(price, direction, size, texthint)
	label_params = {
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
	
	if alltrade.sec_code == "SBER" then
	
		lastprice	= alltrade.price 	-- цена
		lastvolume	= alltrade.qty 		-- количество
		
		if lastvolume >= 1000 then
		
			if bit.test(alltrade.flags, 0) then 
				direction = -1 
				text = "Продажа по: "
			end
			
			if bit.test(alltrade.flags, 1) then 
				direction = 1 
				text = "Покупка по: "
			end		
			
			if lastvolume >= 3000 then
				size = 3
			elseif lastvolume >= 2000 then
				size = 2
			else
				size = 1
			end
			
			pointdraw(lastprice, direction, size, tostring(lastvolume))
			message(text.." "..string.format("%.2f", lastprice).." количество: "..string.format("%.0f",lastvolume))
			
		end		
		
	end
	
end

function main()

	message(progname.." старт работы.")
	
	while do_it do 
		sleep(1000) 
	end

end