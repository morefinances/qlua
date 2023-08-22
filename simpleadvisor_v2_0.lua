function OnInit()
	position = 0
	tiker_id = "SBER_ID"
	tiker_price_channel_id = "SBER_PRICECHANNEL_ID"
	tiker_envelopes_id = "SBER_ENVELOPES_ID"
	progname = "simple advisor v.2.0 : "
end

function OnStop()
	do_it = false
	message(progname.." завершение")
end

-- метка сигнала на вход
function signaldraw(price, direction)
	arrow_params = {
		ALIGNMENT = "LEFT",
		IMAGE_PATH = getScriptPath() .. "\\arrow.bmp",
		YVALUE = price,
		DATE = tostring(os.date("%Y%m%d")),
		TIME = tostring(os.date("%H%M%S")),
		TRANSPARENT_BACKGROUND = 1
	}
	
	if direction == 1 then
		arrow_params.TRANSPARENCY = 15
	else
		arrow_params.TRANSPARENCY = 85
	end
	
	label_id_arrow = AddLabel("SBER_ID", arrow_params)
	
end

-- метка выхода
function drawexit(price)
	arrow_params = {
		ALIGNMENT = "LEFT",
		IMAGE_PATH = getScriptPath() .. "\\arrowexit.bmp",
		YVALUE = price,
		DATE = tostring(os.date("%Y%m%d")),
		TIME = tostring(os.date("%H%M%S")),
		TRANSPARENCY = 80,
		TRANSPARENT_BACKGROUND = 1
	}
	
 	
	label_id_arrow = AddLabel("SBER_ID", arrow_params)
	
end

-- текстовая метка
function labeldraw(price, direction, textlabel, texthint)
	label_params = {
		TEXT = textlabel,
		ALIGNMENT = "LEFT",
		DATE = tostring(os.date("%Y%m%d")),
		TIME = tostring(os.date("%H%M%S")),
		R = 0, 
		G = 0,
		B = 0,
		TRANSPARENCY = 90,
		FONT_HEIGHT = 10,
		TRANSPARENT_BACKGROUND = 1,
		HINT = texthint
	}
	
	if direction == 1 then  
		label_params.YVALUE = price + 0.3
	else
		label_params.YVALUE = price - 0.3
	end
	
	label_id_text = AddLabel("SBER_ID", label_params)
end
 

function fulltime(settime)
	if settime < 10 then
		return "0"..settime
	else
		return settime
	end
end
 
 
function main()
	
do_it = true

-- брать по закрытию свечке
	
	message(progname.." старт")

	while do_it do
		
		--цены и объемы	
		number_of_candles = getNumCandles(tiker_id)
		price, _, _ = getCandlesByIndex(tiker_id, 0, number_of_candles - 2, 2)	
		sleep(300)
		
		-- Price Channel
		number_of_candles_price_channel = getNumCandles(tiker_price_channel_id)
		price_channel_upper, _, _ = getCandlesByIndex(tiker_price_channel_id, 0, number_of_candles_price_channel - 3, 3)
		price_channel_lower, _, _ = getCandlesByIndex(tiker_price_channel_id, 2, number_of_candles_price_channel - 3, 3)
		sleep(300)

		--конверты
		number_of_candles_envelopes = getNumCandles(tiker_envelopes_id)
		envelopes_upper, _, _ = getCandlesByIndex(tiker_envelopes_id, 1, number_of_candles_envelopes - 2, 2)
		sleep(300)
		envelopes_lower, _, _ = getCandlesByIndex(tiker_envelopes_id, 2, number_of_candles_envelopes - 2, 2)
		sleep(300)

		
		if price[0].high and price[0].low and price_channel_upper[0].close and price_channel_lower[0].close and price[0].close and envelopes_upper[0].close and envelopes_lower[0].close then
		
			if position~=1 and price[0].high > price_channel_upper[0].close and price[0].close > envelopes_upper[0].close then 
			
					message("LONG : "..price[0].datetime.hour..":"..fulltime(price[0].datetime.min)..":"..fulltime(price[0].datetime.sec))
					message("high="..price[0].high.." > price_channel_upper="..price_channel_upper[0].close)
					message("close="..price[0].close.." > envelopes_upper="..envelopes_upper[0].close)
					
					text = "LONG "..tostring(price[0].close)
					labeldraw(price[0].close, 1, text, "LONG")
					signaldraw(price[0].close, 1)
					
					position = 1 
			
			end
		
			if position~=-1 and price[0].low < price_channel_lower[0].close and price[0].close < envelopes_lower[0].close then 
			
					message("SHORT : "..price[0].datetime.hour..":"..fulltime(price[0].datetime.min)..":"..fulltime(price[0].datetime.sec))
					message("low="..price[0].low.." < price_channel_lower="..price_channel_lower[0].close)
					message("close="..price[0].close.." < envelopes_lower="..envelopes_lower[0].close)
					
					text = "SHORT "..tostring(price[0].close)
					labeldraw(price[0].close, -1, text, "SHORT")
					signaldraw(price[0].close, -1)
					
					position = -1
			
			end
		
		
		
		
			-- выход из лонга
			if position==1 and price[0].close < envelopes_upper[0].close then
				position=0
				message("position=0 ".." close = "..price[0].close.." < envelopes_upper ="..envelopes_upper[0].close.." "..price[0].datetime.hour..":"..fulltime(price[0].datetime.min)..":"..fulltime(price[0].datetime.sec))
				text = "closeLONG "..tostring(price[0].close)
				labeldraw(price[0].close, 1, text, "CLOSE(LONG)")
				drawexit(price[0].close)
			end
			
			-- выход из шорта
			if position==-1 and price[0].close and price[0].close > envelopes_lower[0].close then
				position=0
				message("position=0 ".." close = "..price[0].close.." < envelopes_lower ="..price_channel_lower[0].close.." "..price[0].datetime.hour..":"..fulltime(price[0].datetime.min)..":"..fulltime(price[0].datetime.sec))
				text = "closeSHORT "..tostring(price[0].close)
				labeldraw(price[0].close, -1, text, "CLOSE(SHORT)")
				drawexit(price[0].close)				
			end
		
		end
		
	
		
		if do_it then sleep(1000) end

	end
	
end
	 
