function OnInit()
	firm_id 	= "NC0011100000"  
	client_code = "10461"
	trdaccid 	= "NL0011100043" -- счет депо
end


function main()

	for u = 0, 1 do
		
		local getdepo_limits = getDepoEx(firm_id, client_code, "SBER", trdaccid, u)
	  		
		local eng_name = {	"limit_kind", 
							"openbal", 
							"openlimit", 
							"currentbal", 
							"currentlimit", 
							"locked_sell", 
							"locked_buy", 
							"locked_buy_value", 
							"locked_sell_value", 
							"wa_position_price", 
							"wa_price_currency" }
		
		local rus_name = {	"Срок расчётов", 
							"Входящий остаток", 
							"Входящий лимит", 
							"Текущий остаток", 
							"Текущий лимит", 
							"В продаже", 
							"В покупке", 
							"Стоимость инструментов, заблокированных под покупку", 
							"Стоимость инструментов, заблокированных под продажу", 
							"Цена приобретения", 
							"Валюта"}
		
		message(string.rep('- ', 25))
			
		for i = 1 , #eng_name do
			message(eng_name[i] .. " / " .. rus_name[i] .. " = " .. getdepo_limits[eng_name[i]])
		end
		
	end

end

