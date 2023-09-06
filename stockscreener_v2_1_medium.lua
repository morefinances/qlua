-- (c) alfacentavra 06.09.2023
-- скринер акций Московской Биржи
-- подробнее: https://smart-lab.ru/blog/938450.php
-- начало: https://smart-lab.ru/blog/928152.php

function OnInit()

	tikers = {}
	progname = "stockscreener v2.0 medium : "
	
	mBlack 	 = RGB(0,0,0)
	mWhite   = RGB(255, 255, 255)
	mRed 	 = RGB(254, 203, 220)
	mGreen   = RGB(210, 247, 221)
	mDGreen  = RGB(154, 237, 179)
	mDRed 	 = RGB(253, 162, 191)
	
	startind = 0
	index_two = 0
	
	PreTotalDelta = 0
	PreUp = 0
	PreSumUp = 0
	PreSumDown = 0
	PreDown = 0
	--PreZero = 0
	
end

function mprint(numb)
	return string.format("%.2f", numb)
end

function OnStop()
	do_it = false
	message(progname.." финиш.")
end


function exc_tik(stock) -- исключение нулевых бумаг
	t = {
		"ACKO",
		"GAZC",
		"GAZS",
		"GAZT",
		"MGNZ"
}
	for i, v in ipairs(t) do 
	 if v == stock then return 1 end
	end
return 0
end


function main()

message(progname.." старт работы.")
do_it = true

if m_t==nil then      

	m_t=AllocTable() 
	
	for u = 1, 20 do
		if u%2 == 1 then
			lencolumn = 9
			celltype = QTABLE_STRING_TYPE
		else 
			lencolumn = 6
			celltype = QTABLE_DOUBLE_TYPE 
		end
		AddColumn(m_t, u, " ", true, celltype, lencolumn) 
	end

	AddColumn(m_t, 21, " ", true, QTABLE_STRING_TYPE, 3)
	AddColumn(m_t, 22, "TOPLIST", true, QTABLE_STRING_TYPE, 9)
	AddColumn(m_t, 23, " ", true, QTABLE_DOUBLE_TYPE, 7)
	AddColumn(m_t, 24, "ANTI TOP", true, QTABLE_STRING_TYPE, 9)
	AddColumn(m_t, 25, " ", true, QTABLE_DOUBLE_TYPE, 7)

	CreateWindow(m_t)  
	SetWindowPos(m_t,690, 0, 1188, 550)  
	SetWindowCaption(m_t, progname.." скринер акций Московской Биржи") 
	
	for i=1, 28 do
		InsertRow(m_t,-1)	 
	end
	
end

mess_start = {"Ждите,","идет","загрузка","тикеров."}

for u = 1, #mess_start do
	SetCell(m_t, 13, 7 + 2 * u, mess_start[u])
	sleep(50)
end

sleep(200)

sec_list = getClassSecurities("TQBR") -- тикеры в одну строчку
	
	mColumn = 1
	mRow = 1
	xCoord = {}
	yCoord = {}
	xy={}
	
	-- разбивка строки с тикерами
	for TIKER in string.gmatch(sec_list, "[^,]+") do
		
		if exc_tik(TIKER) == 0 then
			tikers[#tikers + 1]=TIKER
			SetCell(m_t, mRow, mColumn, tikers[#tikers])
			
			xCoord[TIKER] = mColumn
			yCoord[TIKER] = mRow
			
			mRow = mRow + 1
			
			if mRow == 26 then 
				mRow = 1
				mColumn = mColumn + 2 
			end
			
			sleep(5)
			
		end
		
	end
	
	
	DELTA = {}
	

	while do_it do
	
		TotalDelta = 0
		UpAver = 0
		DownAver = 0
		SumUp = 0
		SumDown = 0
	
		for i = 1 , #tikers do
		

			delta = getParamEx("TQBR", tikers[i], "LASTCHANGE")
			
			if startind == 0 or DELTA[tikers[i]]~=tonumber(delta.param_value) then

				SetCell(m_t, yCoord[tikers[i]], xCoord[tikers[i]], tikers[i])
				SetCell(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1, delta.param_image)
				
				if tonumber(delta.param_value) < 0 then
					
					Highlight(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mDRed, mBlack, 500)
					Highlight(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1 , mDRed, mBlack, 500)
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mRed, mBlack, mRed, mBlack)
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1, mRed, mBlack, mRed, mBlack)
					
				end
				
				if tonumber(delta.param_value) > 0 then
					Highlight(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mDGreen, mBlack, 500)
					Highlight(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1, mDGreen, mBlack, 500)
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mGreen, mBlack, mGreen, mBlack)
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1, mGreen, mBlack, mGreen, mBlack)
				end
				
				if tonumber(delta.param_value) == 0 then
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mWhite, mBlack, mWhite, mBlack)
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]] + 1, mWhite, mBlack, mWhite, mBlack)
				end
				
				DELTA[tikers[i]]=tonumber(delta.param_value)
			
				if startind == 0 then
					sleep(75) 
				else 
					sleep(5)
				end
			
			end
			
			TotalDelta = TotalDelta + tonumber(delta.param_value)
			
			if tonumber(delta.param_value) > 0 then
				UpAver = UpAver + tonumber(delta.param_value)
				SumUp = SumUp + 1
		
			end
			
			if tonumber(delta.param_value) < 0 then
				DownAver = DownAver + tonumber(delta.param_value)
				SumDown = SumDown + 1
			end
			
		
			if startind == 0 then
				DELTA[tikers[i]] = tonumber(delta.param_value)
			end
			
			if startind == 0 and i == #tikers then startind = 1 end

			sleep(5)
		
		end
	
		for x = 1, #tikers do 
			
			if x == 1 then
			
				TOPPLUS = {}
				TOPMINUS = {}
				
				table.insert(TOPPLUS, {tikers[x], DELTA[tikers[x]]})
				table.insert(TOPMINUS, {tikers[x], DELTA[tikers[x]]})
				
			end
		
			-- рейтинг лучших
			if x > 1 and DELTA[tikers[x]] >= TOPPLUS[#TOPPLUS][2] then
				
				if #TOPPLUS == 1 then
				
					if DELTA[tikers[x]] > TOPPLUS[1][2] then
						table.insert(TOPPLUS, 1, {tikers[x], DELTA[tikers[x]]})
					else
						table.insert(TOPPLUS, 2, {tikers[x], DELTA[tikers[x]]})
					end
					
				else
					
					for zx = 1, #TOPPLUS do
						if DELTA[tikers[x]] >= TOPPLUS[zx][2] then
							table.insert(TOPPLUS, zx, {tikers[x], DELTA[tikers[x]]})
							break
						end
					end
					
			
					if #TOPPLUS > 25 then 
						table.remove(TOPPLUS)
					end
					
				end

			end
		
			if #TOPPLUS < 25 and DELTA[tikers[x]] > 0 and DELTA[tikers[x]]<=TOPPLUS[#TOPPLUS][2] then
					table.insert(TOPPLUS, #TOPPLUS, {tikers[x], DELTA[tikers[x]]})
			end
		
		
			--антирейтинг
			if x > 1 and TOPMINUS[#TOPMINUS][2] >= DELTA[tikers[x]] then
				
				if #TOPMINUS == 1 then
				
					if DELTA[tikers[x]] < TOPMINUS[1][2] then
						table.insert(TOPMINUS, 1, {tikers[x], DELTA[tikers[x]]})
					else
						table.insert(TOPMINUS, 2, {tikers[x], DELTA[tikers[x]]})
					end
					
				else
					
					for zx = 1, #TOPMINUS do
						if DELTA[tikers[x]] <= TOPMINUS[zx][2] then
							table.insert(TOPMINUS, zx, {tikers[x], DELTA[tikers[x]]})
							break
						end
					end

					-- if #TOPPLUS < 25 and DELTA[tikers[x]]>0 and DELTA[tikers[x]]<=TOPPLUS[#TOPPLUS][2] then
						-- table.insert(TOPPLUS, #TOPPLUS, {tikers[x], DELTA[tikers[x]]})
					-- end
					
					if #TOPMINUS > 25 then 
						table.remove(TOPMINUS)
					end
					
				end

			end			
		
			if #TOPMINUS < 25 and DELTA[tikers[x]] < 0 and DELTA[tikers[x]]>=TOPMINUS[#TOPMINUS][2] then
					table.insert(TOPMINUS, #TOPMINUS, {tikers[x], DELTA[tikers[x]]})
			end
		
		
		end

		-- нумерация столбца рейтинга, выводим только один раз 
		if index_two == 0 then
		
			for j = 1, 25 do
				SetCell(m_t, j, 21, tostring(j))
			end
		
		end

		--вывод лучших
		for j = 1, #TOPPLUS do
		
			SetCell(m_t, j, 22, " ")
			SetCell(m_t, j, 23, " ")
		
			if TOPPLUS[j][2]>0 then
				SetCell(m_t, j, 22, TOPPLUS[j][1])
				SetCell(m_t, j, 23, mprint(TOPPLUS[j][2]))
			end
			
		end 
		
		-- вывод худших	
		for j = 1, #TOPMINUS do
		
			SetCell(m_t, j, 24, " ")
			SetCell(m_t, j, 25, " ")
		
			if TOPMINUS[j][2]<0 then
				SetCell(m_t, j, 24, TOPMINUS[j][1])
				SetCell(m_t, j, 25, mprint(TOPMINUS[j][2]))
			end		
		
		end
		
		
	
		if index_two == 0 then
			SetCell(m_t, 27, 1,  "Ср.всего:")
			SetCell(m_t, 27, 3,  "Ср.рост:")
			SetCell(m_t, 27, 5,  "Ср.сниж:")
			SetCell(m_t, 28, 2,  tostring(#tikers)) -- всего тикеров в массиве
			index_two = 1
		end
	
		if PreTotalDelta ~= TotalDelta then
			SetCell(m_t, 27, 2,  mprint(TotalDelta/#tikers))
			PreTotalDelta = TotalDelta
		end
	
	
		if PreUp~=UpAver then		
			if SumUp>0 then
				SetCell(m_t, 27, 4,  mprint(UpAver/SumUp))
			else
				SetCell(m_t, 27, 4,  mprint(0))
			end
			PreUp=UpAver
		end

		
		if PreDown ~= DownAver then
			if SumDown>0 then 
				SetCell(m_t, 27, 6,  mprint(DownAver/SumDown))
			else
				SetCell(m_t, 27, 6,  mprint(0))
			end
			PreDown = DownAver
		end
			

		if PreSumUp ~= SumUp then 
			SetCell(m_t, 28, 4,  tostring(SumUp))
			local x = string.format("%.1f", 100 * SumUp / #tikers)
			SetCell(m_t, 28, 3,  tostring("      "..x.."%"))
			PreSumUp = SumUp
		end
	

		if PreSumDown ~= SumDown then
			SetCell(m_t, 28, 6,  tostring(SumDown))
			local x = string.format("%.1f", 100 * SumDown / #tikers)
			SetCell(m_t, 28, 5,  tostring("      "..x.."%"))
			PreSumDown = SumDown
		end
	

		if IsWindowClosed(m_t) then 
			do_it = false
			OnStop() 
		end
		
		sleep(10000)
		
	end


end
-- (c) alfacentavra 06.09.2023