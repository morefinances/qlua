function OnInit()

	firm_id 	= "NC0011100000"  
	client_code = "10461"  

end


function mprint( numb )
	return string.format( "%.2f", numb )
end


function main()

	Portfolio = getPortfolioInfo( firm_id, client_code )
    
	message( string.rep( "- ", 15 ) ) 
	
	message( "Входящие активы = " .. mprint( Portfolio.in_all_assets ) )
	message( "Текущие активы = " .. mprint( Portfolio.all_assets ) )
	message( "Стоимость портфеля = " .. mprint( Portfolio.portfolio_value ) )
	message( "Прибыль / убыток = " .. mprint( Portfolio.profit_loss ) )
	message( "УДС = " .. mprint( Portfolio.fundslevel ) )
	
	message( "Минимальная маржа = " .. mprint( Portfolio.min_margin ) )
	message( "Начальная маржа = " .. mprint( Portfolio.init_margin ) )
	message( "Норматив покрытие риска НПР1 = " .. mprint( Portfolio.rcv1 ) )
	message( "Норматив покрытие риска НПР2 = " .. mprint( Portfolio.rcv2 ) )
	
	firm_id 	= "SPBFUT" 
	client_code = "SPBFUT108"
	Portfolio = getPortfolioInfoEx( firm_id, client_code, 0 )
	message( "Доступные средства для открытия позиций FORTS = " .. Portfolio.lim_non_margin )

end

