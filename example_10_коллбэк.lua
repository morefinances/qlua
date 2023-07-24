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


-- колбэк реагирует на действия с таблицей
function table_callback(m_t,msg,par1,par2)   -- Коллбек для m_t - при закрытии таблицы вызывается OnStop()
	if msg==QTABLE_CLOSE then
		OnStop()
	end
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

 	-- Подписка на коллбек для m_t
	SetTableNotificationCallback(m_t,table_callback) 


-- вносим в таблицу неизменямые данные
	for i = 1, #tikers do
		local tName = getParamEx("TQBR", tikers[i], "SHORTNAME").param_image
		SetCell(m_t, i, 1, tikers[i])
		SetCell(m_t, i, 2, tName)
	end


	while do_it do

		-- заполнение и дальнейшее обновление таблицы
		for i = 1, #tikers do
			 
			local tLast = getParamEx("TQBR", tikers[i], "LAST").param_image 
			local tOffer = getParamEx("TQBR", tikers[i], "OFFERDEPTHT").param_image 
			local tBid = getParamEx("TQBR", tikers[i], "BIDDEPTHT").param_image 

			SetCell(m_t, i, 3, tLast)
			SetCell(m_t, i, 4, tOffer)
			SetCell(m_t, i, 5, tBid)
		end
	

	sleep(timeout)

	end

end
 