function OnInit()
	firm_id 	= "NC0011100000"
	client_code = "10461"
	trdaccid 	= "NL0011100043" -- счет депо
end

function main()

	getdepo_limits = getDepo(client_code, firm_id, "SBER", trdaccid)
  
	local eng_name = {	"depo_limit_locked_buy_value", 
						"depo_current_balance", 
						"depo_limit_locked_buy", 
						"depo_limit_locked", 
						"depo_limit_available", 
						"depo_current_limit", 
						"depo_open_balance", 
						"depo_open_limit" }
	
	local rus_name = {	"Стоимость инструментов, заблокированных на покупку", 
						"Текущий остаток по инструментам", 
						"Количество лотов инструментов, заблокированных на покупку", 
						"Заблокированное Количество лотов инструментов", 
						"Доступное количество инструментов", 
						"Текущий лимит по инструментам", 
						"Входящий остаток по инструментам", 
						"Входящий лимит по инструментам"}
	
	message(string.rep('- ', 25))
	
	message('getdepo_limits.depo_limit_available='..getdepo_limits.depo_limit_available)
	
	for i = 1 , #eng_name do
		message(eng_name[i] .. " / " .. rus_name[i] .. " = " .. getdepo_limits[eng_name[i]])
	end
	
end

