function OnInit()

	tikers 	 = {}
	progname = "stockscreener v1.1 light : "
	mBlack 	 = RGB(0,0,0)
	mWhite 	 = RGB(255,255,255)
	mRed 	 = RGB(254,203,220)
	mGreen 	 = RGB(210,247,221)
	mGray 	 = RGB(178,178,178)
	startind = 0
	
end

function OnStop()

	message(progname.." финиш.")
	do_it = false
	
end

function main()

message(progname.." старт работы.")
do_it = true

if m_t==nil then      
	m_t=AllocTable() 
	for u = 1, 10 do
		AddColumn(m_t, u, " ", true, QTABLE_STRING_TYPE, 15) 
	end

	CreateWindow(m_t)  
	SetWindowPos(m_t,690,0,1000,500)   
	SetWindowCaption(m_t, progname.." скринер акций Московской Бирижи")  
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
	
		tikers[#tikers + 1] = TIKER
		SetCell(m_t, mRow, mColumn, tikers[#tikers])
		
		xCoord[TIKER] = mColumn
		yCoord[TIKER] = mRow
		
		mRow = mRow + 1
		
		if mRow == 26 then 
			mRow = 1
			mColumn = mColumn + 1 
		end
		
		sleep(65)
		
	end
	
 
	DELTA = {}

	while do_it do
	
		for i = 1 , #tikers do
		
			delta = getParamEx("TQBR", tikers[i], "LASTCHANGE")
			
			if startind == 0 or DELTA[tikers[i]]~=tonumber(delta.param_value) then

				SetCell(m_t, yCoord[tikers[i]], xCoord[tikers[i]], tikers[i].." "..delta.param_image)
				
				if tonumber(delta.param_value) < 0 then
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mRed, mBlack, mRed, mBlack)
				end
				
				if tonumber(delta.param_value) > 0 then
					SetColor(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mGreen, mBlack, mGreen, mBlack)
				end
				
				Highlight(m_t, yCoord[tikers[i]], xCoord[tikers[i]], mGray, mBlack, 500)
				
				DELTA[tikers[i]]=tonumber(delta.param_value)
				
				if startind == 0 then
					sleep(75)
				else
					sleep(10)
				end
				
			end
			
			if startind == 0 then
				DELTA[tikers[i]] = tonumber(delta.param_value)
			end
			
			
			if startind == 0 and i == #tikers then startind = 1 end

		
		end
	
		if IsWindowClosed(m_t) then OnStop() end
		
		sleep(10000)
	end


end
