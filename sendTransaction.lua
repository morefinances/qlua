function OnInit()
	class 		= "QJSIM"					-- класс бумаг: акции
	tiker 		= "SBER"					-- тикер: Сбер
	account 	= "NL0011100043"			-- торговый счет
	id_transact = 0			  				-- id счетчик всех транзакций
	progname	= "sndTrnsctn_v1"			-- название скрипта
end


function main()

	id_transact = id_transact + 1

	price = 256.59 -- цена покупки
	quant = 1 	-- объем покупки

	newtransaction  = 
	{
	["TRANS_ID"]			= tostring(id_transact),-- id транзакции
	["ACTION"]				= "NEW_ORDER", 			-- что делаем: выставляем новую заявку
	["CLASSCODE"]			= class ,				-- класс бумаги
	["SECCODE"]				= tiker,				-- тикер
	["OPERATION"]			= "B",					-- B - Buy=покупка / S - Sell=продажа
	["QUANTITY"]			= tostring(quant), 		-- объем
	["PRICE"]				= tostring(price),		-- цена
	["ACCOUNT"]				= account,				-- торговый счет
	["CLIENT_CODE"]			= "sndTr_v1/"..id_transact, -- комментарий, не более 12 символов
	["EXECUTION_CONDITION"] = "PUT_IN_QUEUE"		-- условие исполнения:  поставить в очередь 
	}


	error_transaction = sendTransaction(newtransaction)

	if error_transaction ~= "" then
		message(progname.." : ошибка выставления заявки :"..error_transaction, 3)
	else
		message(progname.." : заявка выставлена успешно. id транзакции="..id_transact)
	end

end