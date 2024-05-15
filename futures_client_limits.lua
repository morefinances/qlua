 
function main()

	message( string.rep( "- ", 22 ) )
	
	message( "Лимиты по деньгам на срочном рынке:" ) 

	local n = getNumberOf( "futures_client_limits" )

	local money_limit = getItem( "futures_client_limits", 0 )
	
	if money_limit.limit_type == 0 then
	
		message( "Предыдущий лимит открытых позиций " ..  money_limit.cbp_prev_limit )
		message( "Текущий лимит открытых позиций " ..  money_limit.cbplimit )
		message( "Текущие чистые позиции  " ..  money_limit.cbplused  )
		message( "Плановые чистые позиции   " ..  money_limit.cbplplanned  )
		message( "Вариационная маржа   " ..  money_limit.varmargin  )
	
	end

 end