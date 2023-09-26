function OnInit()
	class 		= "QJSIM"					-- класс бумаг: акции -- QJSIM
	tiker 		= "SBER"					-- тикер: Сбер
	account 	= "NL0011100043"			-- торговый счет
	id_transact = 0			  				-- id счетчик всех транзакций
	progname	= "sndTrnsctn_v1"			-- название скрипта
end

function offer_bid_price()

quotelvl = getQuoteLevel2(class, tiker)

if quotelvl then

	if quotelvl.offer then
		priceoffer = tonumber(quotelvl.offer[1].price)			
	else
		message("Нет данных по предложению")
		priceoffer = -1
	end

	if quotelvl.bid then
		pricebid = tonumber(quotelvl.bid[tonumber(quotelvl.bid_count)].price)
	else
		message("Нет данных по спросу")
		pricebid = -1
	end

end

return priceoffer, pricebid

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
	end


end

function main()

message(string.rep("-",15)) -- разделитель

quant = 1 	-- объем покупки

OfferPrice, BidPrice  = offer_bid_price()


	for i = 1 , 5 do
		

		if BidPrice > 0 then
			newtransaction(1, quant, BidPrice)
			sleep(300)
		end
		
		if OfferPrice > 0 then		
			newtransaction(-1, quant, OfferPrice)
			sleep(300)
		end
		
		BidPrice = BidPrice - 0.01
		OfferPrice = OfferPrice + 0.01

	end	
	
end