function OnInit()
	class 		= "QJSIM"					-- класс бумаг: акции
	tiker 		= "SBER"					-- тикер: Сбер
	account 	= "NL0011100043"			-- торговый счет
	id_transact = 0			  				-- id счетчик всех транзакций
	progname	= "sndTrnsctn_v1"			-- название скрипта
end

function newtransaction(operation, quant, price)

id_transact = id_transact + 1

mytransaction  = 
	{
	["TRANS_ID"]			= tostring(id_transact),-- id транзакции
	["ACTION"]				= "NEW_ORDER", 			-- что делаем: выставляем новую заявку
	["CLASSCODE"]			= class ,				-- класс бумаги
	["SECCODE"]				= tiker,				-- тикер
	["QUANTITY"]			= tostring(quant), 		-- объем
	["PRICE"]				= tostring(price),		-- цена
	["ACCOUNT"]				= account,				-- торговый счет
	["CLIENT_CODE"]			= "sndTr_v1/"..id_transact, -- комментарий для терминала, до 12 символов
	["EXECUTION_CONDITION"] = "PUT_IN_QUEUE"		-- условие исполнения:  поставить в очередь 
	}

	if operation == -1 then
		mytransaction["OPERATION"] = "S"
	else
		mytransaction["OPERATION"] = "B"
	end

	error_transaction = sendTransaction(mytransaction)

	if error_transaction ~= "" then
		message(progname.." : ошибка выставления заявки :"..error_transaction, 3)
	else
		message(progname.." : заявка выставлена успешно. id транзакции="..id_transact)
	end

end

function main()

	price = 256.5 	-- цена покупки
	quant = 1 		-- объем покупки

	operation = 1	-- направление: покупка
	
	newtransaction(operation, quant, price)
	sleep(1000)		-- таймаут 1 сек.

end

