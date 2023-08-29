function OnInit()
	do_it = true
	sentiment = 0
end

function OnStop()
	do_it = false
end


function OnAllTrade(alltrade)
	
	if alltrade.sec_code=="SBER" then
	
		lastvolume	= alltrade.qty 		 
		
		if bit.test(alltrade.flags, 0) then 
			sentiment = sentiment - lastvolume
		end
		
		if bit.test(alltrade.flags, 1) then 
			sentiment = sentiment + lastvolume
		end		
			
		message("Сентимент: "..sentiment)
		
	end
end

function main()

	
	while do_it do 
		sleep(1000) 
	end


end