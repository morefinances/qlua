-- работа с котировками без графиков
 
function OnInit()

	birga="TQBR"
	tiker="SBER" 
	name="Сортировка среднего оборота на МосБирже с оптимизированной сортировкой"
	version="1.0.3. от 6 октября 2021"
	--тикеры актуальны на 16.02.24
	t={"SOFL", "LSRG", "TRMK", "POSI", "BANE", "FEES", "SELG", "WUSH", "ASTR", "DELI", "BELU", "AQUA", "TATNP", "GLTR", "POLY", "AGRO", "EUTR", "GTRK", "IRAO", "SGZH", "UNAC", "MDMG", "IRKT", "PHOR", "SIBN", "FESH", "RUAL", "RASP", "MTSS", "MSNG", "FLOT", "TATN", "UGLD", "AFLT", "BSPB", "UPRO", "ALRS", "PIKK", "MTLRP", "SNGS", "NMTP", "OZON", "MOEX", "PLZL", "SBERP", "AFKS", "VKCO", "TRNFP", "BANEP", "SNGSP", "NLMK", "FIVE", "VTBR", "TCSG", "ROSN", "MAGN", "MGNT", "CHMF", "GAZP", "SVCB", "LKOH", "GMKN", "MTLR", "NVTK", "SBER", "YNDX"}
		
	
	message("[  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  ]")		
	message("Старт : "..tostring(name).."  / версия "..tostring(version))

end

function VolTableStr(one_st, two_st)
	message("обмен строки "..tostring(one_st).." на "..tostring(two_st))
	FirstStr={}
	SecondStr={}
	
	for str=1, 23 do
		FirstStr[str]=GetCell(TableVol,one_st,str)
		SecondStr[str]=GetCell(TableVol,two_st,str)
		--message("str "..tostring(str).." FirstStr="..tostring(FirstStr[str].image).." SecondStr="..tostring(SecondStr[str].image))
		SetCell(TableVol, two_st, str, tostring(FirstStr[str].image))
		SetCell(TableVol, one_st, str, tostring(SecondStr[str].image))
	end
	
	
end
 
 function main()

	-- создание таблицы
	
	hist_price, error_descr = CreateDataSource(birga, tiker, INTERVAL_D1)
	
	sleepiii=0
	repeat 
		sleep(100) 
		sleepiii=sleepiii+1
	until hist_price:Size()~=0 or sleepiii>=10 
	
	hist_long=hist_price:Size()
	
	
	
		if TableVol==nil then
			TableVol=AllocTable()
			AddColumn(TableVol, 1, "tiker", true, QTABLE_STRING_TYPE, 7)
			-- подписываем столбцы датами
		for m=2, 21 do
		
			hist_day=hist_price:T(hist_long-21+m)
			Day=hist_day.day
			if Day<10 then Day=tostring("0"..Day) end
					
			Month=hist_day.month
			if Month<10 then Month=tostring("0"..Month) end
					
			Year=hist_day.year-2000
			if Year<10 then Year=tostring("0"..Year) end
					
			AddColumn(TableVol, m, tostring(Day.."."..Month.."."..Year), true, QTABLE_STRING_TYPE, 8)
			
			AddColumn(TableVol, 22, "GrosVol", true, QTABLE_STRING_TYPE, 8)
			
			AddColumn(TableVol, 23, "лот", true, QTABLE_STRING_TYPE, 8)
			

			
		end
		
			CreateWindow(TableVol)
			SetWindowPos(TableVol,0,100,1800,850)
			SetWindowCaption(TableVol, tostring(name).."  / версия "..tostring(version))
		for i=1, #t do
			InsertRow(TableVol,-1)
		end
	end
	
	
--message(tostring(Day.."."..Month.."."..Year).." : "..hist_price:C(tonumber(hist_long-10+m)))
	
	--наполнение таблицы
	
	for i=1, #t do
		SetCell(TableVol, i, 1, tostring(t[i]))
	end
	
	
	for mm=1, #t do
		hist_price, error_descr = CreateDataSource(birga, t[mm], INTERVAL_D1)
		
		sleepiii=0
		repeat 
			sleep(10) 
			sleepiii=sleepiii+1
		until hist_price:Size()~=0 or sleepiii>=10 
		
		SumVol=0
		-- SumVOL=0
		histlong2=hist_price:Size()
		
		for mi=0, 19 do
		
		
		PR_HIGH=hist_price:H(histlong2-(mi))
		PR_LOW=hist_price:L(histlong2-(mi))
		VOL=hist_price:V(histlong2-(mi))
		
				-- if PR_CLOSE==0 then 
					-- message(tostring(t[mm]).." ноль в PR_CLOSE="..tostring(PR_CLOSE).." mi="..tostring(mi).." mi="..tostring(mi)) 
					-- Res=0
					-- kRost=0
				-- else
					--message("HIGH="..tostring(HIGH).." LOW="..tostring(LOW).." mm="..tostring(mm).." mi="..tostring(mi))
					 
					-- if PR_CLOSE>PR_OPEN then Res=1 end
					-- if PR_CLOSE<PR_OPEN then Res=-1 end
					-- if PR_CLOSE==PR_OPEN then Res=0 end
					
					GrosVal=(PR_HIGH+PR_LOW)*VOL/2
					
					
					--message(tostring(t[mm]).."PR_HIGH="..tostring(PR_HIGH).." PR_LOW="..tostring(PR_LOW).." mi="..tostring(mi).." VOL="..tostring(VOL).." GrosVal="..tostring(GrosVal))
					 
					SumVol=SumVol+GrosVal
					 
				
			
			SetCell(TableVol, mm, 21-mi, tostring(GrosVal-GrosVal%1))
		

		SetCell(TableVol, mm, 22, tostring(SumVol-SumVol%1))
	
		end
		--SetCell(TableVol, mm, 23, tostring(SchPL-SchPL%1))
		
		
		--SumRost=SumRost/20
		--SetCell(TableVol, mm, 24, tostring(SumRost-SumRost%0.01))
		
		d=getParamEx("TQBR", t[mm], "LOTSIZE").param_value
		SetCell(TableVol, mm, 23, tostring(d-d%1))
		 
		
		--SetCell(TableVol, mm, 25, tostring(KItog))
		
		--message("K="..tostring(KItog))
		
	 
		
	end
	
	sleep(500)
	
	--message("Биржа: "..tostring(birga))
	--message("Инструмент: "..tostring(tiker))
	--message("Количество свечей: "..hist_price:Size())
	
	-- for i=10, 0, -1 do



		-- gg=GetCell(TableVol,5,2)
		-- gf=GetCell(TableVol,5,3)
		
		-- if tonumber(gf.image) > tonumber(gg.image) then 
			-- message("gf= "..tostring(gf.image)..">".."gg= "..tostring(gg.image))
		-- else 
			-- message("gf= "..tostring(gf.image).."<".."gg= "..tostring(gg.image))
		-- end
		
	runs=1
	 
 	while runs<66 do
		
		-- определяем максимум
		gf=GetCell(TableVol,runs,22)
		GMax=tonumber(gf.image)
		GStr=runs
		for runny=runs+1,66 do
			gg=GetCell(TableVol,runny,22)
			-- поиск локального максимума с runs и ниже до 28 строки
			if tonumber(gg.image)>GMax then 
				GMax=tonumber(gg.image) 
				GStr=runny
				--message("Найден новый локальный GMax "..tostring(GMax).."итерация "..tostring(runs))
				
			end
			
		end
		
		if GStr>runs then
			message("Смена "..tostring(runs).."  "..tostring(GStr))
			VolTableStr(runs, GStr)

		end
		
		
		sleep(10)
		runs=runs+1
		
		
	end
 
 
	hist_price:Close()
	message(tostring(name).."  / версия "..tostring(version).." // Успешный финиш")
 end