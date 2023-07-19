offer = getParamEx("TQBR", "GAZP", "OFFER").param_value
bid = getParamEx("TQBR", "GAZP", "BID").param_value
change = getParamEx("TQBR", "GAZP", "CHANGE").param_value	
lastchange = getParamEx("TQBR", "GAZP", "LASTCHANGE").param_value
numoffers = getParamEx("TQBR", "GAZP", "NUMOFFERS").param_value
numbids = getParamEx("TQBR", "GAZP", "NUMBIDS").param_value
wprice  = getParamEx("TQBR", "GAZP", "WAPRICE").param_value

message("Лучшая цена предложения OFFER: "..offer)
message("Лучшая цена спроса BID: "..bid)
message("Разница цены последней сделки к предыдущей сессии CHANGE: "..change) 
message("% изменения от закрытия LASTCHANGE: "..lastchange)
message("Количество заявок на продажу NUMOFFERS: "..numoffers)
message("Количество заявок на покупку NUMBIDS: "..numbids)
message("Средневзвешенная цена WAPRICE: "..wprice)
 

 