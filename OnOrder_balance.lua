function OnInit()
	class 		= "QJSIM"					-- класс бумаг: акции -- QJSIM
	tiker 		= "SBER"					-- тикер: Сбер
	account 	= "NL0011100043"			-- торговый счет
	id_transact = 0			  				-- id счетчик всех транзакций
	progname	= "sndTrnsctn_v1"			-- название скрипта
	commentid	= "sndTr_v1/"				-- комментарий к заявке
	title1 		= "OnTransReply / "
	title2		= "OnOrder / "
	quant	 	= 0
	operation	= 0
end
 
function OnTransReply(trn)

	message(string.rep("-",25))
	message(title1.." trn_id="..tostring(trn.trans_id).." / status="..trn.status.." / order_num="..trn.order_num)
	message(title1.." price="..trn.price.." / quantity="..trn.quantity.." / brokerref="..trn.brokerref)
	message(title1.." result_msg="..trn.result_msg)
	time2 = os.clock()
	message(title1.." время отклика "..(time2-time1).." сек.")

end

function OnOrder(trans)

	if trans.trans_id == 1 then
		message(string.rep("-",25))
		message(title2.." trn_id="..trans.trans_id.." / order_num="..trans.order_num)
		message(title2.." price="..trans.price.." / quantity="..trans.qty.." / brokerref="..trans.brokerref)
		message(title2.." value="..trans.value)
		time3 = os.clock()
		message(title2.." время отклика:"..(time3-time1).." сек.")
		message(title2.." остаток balance="..trans.balance)
	end
 
end


function OnQuote(cls, tkr)

	if cls == class and tkr == tiker then
	
	quotelvl = getQuoteLevel2(class, tiker)

		if quotelvl and quotelvl.bid then
			
			offer2 = tonumber(quotelvl.offer[2].price)
			quant_offer1 = tonumber(quotelvl.offer[1].quantity)
			quant_offer2 = tonumber(quotelvl.offer[2].quantity)
			
			if (quant_offer1 + quant_offer2 < 50) and operation == 0 then
				quant = 100
				message(string.format("%s + %s = %s < 50 / price = %s", quant_offer1, quant_offer2, quant_offer1 + quant_offer2, offer2))
			end

		end

	end
	

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
	["CLIENT_CODE"]			= commentid..id_transact, -- комментарий для терминала, до 12 символов
	["EXECUTION_CONDITION"] = "PUT_IN_QUEUE"		-- условие исполнения:  поставить в очередь 
	}

	if operation == 1 then
		mytransaction["OPERATION"] = "B"
	else
		mytransaction["OPERATION"] = "S"
	end

	error_transaction = sendTransaction(mytransaction)

	if error_transaction ~= "" then
		message(progname.." : ошибка выставления заявки :"..error_transaction, 3)
	else
		message(progname.." : заявка выставлена успешно. id транзакции="..id_transact)
		lastId = id_transact
	end


end

function main()

message(string.rep("-",20)) -- разделитель
message(progname.." : старт")

	do_it = true

	while do_it do
		
		if quant > 0 and operation == 0 then
		
			operation = 1 
			price_order = offer2
			time1 = os.clock()
			newtransaction(operation, quant, price_order)
			message("Время выставление заявки: "..tostring(os.date('%H:%M:%S')))
		
		end
		
		sleep(1000)
		
	end
	
end