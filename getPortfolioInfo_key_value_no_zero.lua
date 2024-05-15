function OnInit()
	firm_id 	= "NC0011100000"
	client_code = "10461"
end

function main()

	
Portfolio = getPortfolioInfo( firm_id, client_code )
    
	message( string.rep( "- ", 15 ) ) 

	for key, value in pairs( Portfolio ) do
		if value and tonumber( value ) ~= 0 then
			message( key .. ": " .. value )
		end
	end
		
end

