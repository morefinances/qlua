function OnInit()
	do_it = true
end

function OnStop()
	do_it = false
end


function OnAllTrade(alltrade)
	
	if alltrade.sec_code=="SBER" then
	
		lastprice	= alltrade.price 	-- цена
		lastvolume	= alltrade.qty 		-- количество
		lastvalue 	= alltrade.value 	-- оборот
		
		
		if lastvolume >= 100 then
		
			if bit.test(alltrade.flags, 0) then  
				message("Продажа: количество: "..lastvolume.." цена: "..lastprice.." оборот: "..lastvalue)
			end
			if bit.test(alltrade.flags, 1) then 
				message("Покупка: количество: "..lastvolume.." цена: "..lastprice.." оборот: "..lastvalue)
			end		
			
		end
		
	end
end

function main()

	
	while do_it do 
		sleep(1000) 
	end


end