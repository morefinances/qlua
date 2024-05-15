-- позиции на всех счетах
message("Вывод текущих позиций в разрезе Т0 / Т1:") 
 
function main()

	local n = getNumberOf("depo_limits")
	
		for i = 0, n - 1 do
		
			local depo_limit=getItem( "depo_limits", i )
			
			if depo_limit.limit_kind >= 0 and depo_limit.currentbal > 0 and depo_limit.limit_kind <= 1 then
				
				message(tostring(depo_limit.sec_code) .. " : " .. string.format("%.0f", depo_limit.currentbal) .. " / T+" .. depo_limit.limit_kind)
		
			end
		
		end
	
	message(string.rep("- ",22))
	
 end
 
 