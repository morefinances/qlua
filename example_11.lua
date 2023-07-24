function OnInit()
	tikers = {"GAZP", "SBER", "VKCO"}
	progname = "mytable :"
	timeout = 5000
end


function OnStop()
	do_it = false
	DestroyTable(m_t)
	message(progname.." Финиш.")
end


function main() 

	message(progname.." Старт.")
	do_it = true


	if m_t==nil then     -- если таблица не создана ранее, то 
	m_t=AllocTable() -- создать таблицу
		AddColumn(m_t, 1, "Тикер", true, QTABLE_STRING_TYPE, 10) 
		-- добавить 1 столбец шириной в 10 символов
		AddColumn(m_t, 2, "Бумага", true, QTABLE_STRING_TYPE, 20)
		-- добавить 2 столбец шириной в 20 символов
		AddColumn(m_t, 3, "Цена", true, QTABLE_STRING_TYPE, 10)
		-- 3й столбец с шириной в 10
		AddColumn(m_t, 4, "Суммарное предложение", true, QTABLE_STRING_TYPE, 25)
		-- 4й и 5й столбцы с шириной в 25  
		AddColumn(m_t, 5, "Суммарный спрос", true, QTABLE_STRING_TYPE, 25)
	CreateWindow(m_t) -- создание окна таблицы
	SetWindowPos(m_t,0,430,700,110) -- позиционирвание (x,y от левого верхнего угла) 
									-- и размеры (ширина, высота)
	SetWindowCaption(m_t, "Вывод данных через таблицу") -- показать таблицу, пишем заголовок
		for u = 1, #tikers do
			InsertRow(m_t,-1)	-- добавить строку
		end
	end

 

-- вносим в таблицу неизменямые данные
	for i = 1, #tikers do
		local tName = getParamEx("TQBR", tikers[i], "SHORTNAME").param_image
		SetCell(m_t, i, 1, tikers[i])
		SetCell(m_t, i, 2, tName)
	end

	
	while do_it do

		-- заполнение и дальнейшее обновление таблицы
		for i = 1, #tikers do
			 
			local tLast = getParamEx("TQBR", tikers[i], "LAST") 
			local tOffer = getParamEx("TQBR", tikers[i], "OFFERDEPTHT") 
			local tBid = getParamEx("TQBR", tikers[i], "BIDDEPTHT")

			SetCell(m_t, i, 3, tLast.param_image)
			SetCell(m_t, i, 4, tOffer.param_image)
			SetCell(m_t, i, 5, tBid.param_image)
			
			-- продажи больше покупок подсвечиваем продажи, покупки без цвета
			if tOffer.param_value>tBid.param_value then 
				SetColor(m_t, i, 4, RGB(255,204,250), RGB(0,0,0), RGB(255,204,250), RGB(0,0,0))
				SetColor(m_t, i, 5, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
			-- покупки больше продаж подсвечивам покупки, продажи без цвета
			elseif tOffer.param_value<tBid.param_value then 
				SetColor(m_t, i, 4, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
				SetColor(m_t, i, 5, RGB(199,254,236), RGB(0,0,0), RGB(199,254,236), RGB(0,0,0))
			-- продажи равны покупкам оставляем без подстветки оба значения
			else
				SetColor(m_t, i, 4, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
				SetColor(m_t, i, 5, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
			end

		end
	
	if IsWindowClosed(m_t) then OnStop() end
	
	sleep(timeout)

	end

end
 
