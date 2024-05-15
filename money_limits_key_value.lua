-- позиции на всех счетах
message("Лимиты по деньгам:") 
 
function main()

	message(string.rep("- ",22))

	local n = getNumberOf("money_limits")
		
		for i = 1, n - 1 do
		
			local money_limit=getItem("money_limits", i)
			
				for key, value in pairs(money_limit) do
					message(key..": "..value)
				end
	
		message(string.rep("- ",10))
		
		end
	
 end