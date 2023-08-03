function OnInit()

	tikers = {}
	progname = "stockscreener v1.3 light : "
	
	mBlack 	 = RGB(0,0,0)
	mWhite   = RGB(255,255,255)
	mRed 	 = RGB(254,203,220)
	mGreen   = RGB(210,247,221)
	mDGreen  = RGB(154, 237, 179)
	mDRed 	 = RGB(253, 162, 191)
	startind = 0
	
end

function OnStop()
	message(progname.." финиш.")
	do_it = false
end


function exc_tik(stock) -- исключение бумаг с нулевыми оборотами
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

	CreateWindow(m_t)  
	SetWindowPos(m_t,690,0,1000,500)  
	SetWindowCaption(m_t, progname.." скринер акций Московской Биржи") 
	
	for i=1, 25 do
		InsertRow(m_t,-1)	 
	end
	
end


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
			
			sleep(65)
			
		end
		
	end
	
	
	DELTA = {}

	while do_it do
	
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
				
				DELTA[tikers[i]]=tonumber(delta.param_value)
			
				if startind == 0 then
					sleep(75) 
				else 
					sleep(5)
				end
			
			end
			
			if startind == 0 then
				DELTA[tikers[i]] = tonumber(delta.param_value)
			end
			
			if startind == 0 and i == #tikers then startind = 1 end

			sleep(5)
		
		end
	
		if IsWindowClosed(m_t) then OnStop() end
		
		sleep(10000)
	end


end
