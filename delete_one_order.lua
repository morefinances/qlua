function OnInit()
	class 		= "QJSIM"					-- класс бумаг: акции
	tiker 		= "SBER"					-- тикер: Сбер
	account 	= "NL0011100043"			-- торговый счет
	client_code = "10070"					-- код клиента
	id_transact = 0			  				-- id счетчик всех транзакций
	progname	= "delete_order_1.0"		-- название скрипта
end


function trasactiondelete(number_order)

id_transact = id_transact + 1

deleteorder  = 
	{
	["TRANS_ID"]			= tostring(id_transact), 
	["ACTION"]				= "KILL_ORDER", 			 
	["CLASSCODE"]			= class ,				 
	["SECCODE"]				= tiker,				 			 
	["ACCOUNT"]				= account,				
	["ORDER_KEY"] 			= tostring(number_order)		
	}
	
end

function main()
 	
	num_orders = getNumberOf("orders")
	
	for i = num_orders - 1, 0, -1 do
	
		myorder = getItem("orders", i)
		
		if myorder["client_code"]==client_code and myorder["sec_code"]==tiker then
		
			if bit.band(tonumber(myorder["flags"]),1) > 0 then
			
				message(progname.." Номер заявки: "..myorder.order_num)
					
					trasactiondelete(myorder.order_num)
					error_transaction = sendTransaction(deleteorder)
					sleep(300)
					
					if error_transaction ~= "" then
						message(progname.." : ошибка ="..error_transaction, 3)
					else
						message(progname.." : снятие заявки "..myorder["order_num"].." цена:"..myorder["price"].." объем: "..myorder["balance"].." комментарий:"..myorder["brokerref"], 2)
					end
				
				break -- выходим из цикла после того как сняли 1 активную заявку

			end
	
		end
	
	end

end