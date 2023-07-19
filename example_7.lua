function mprint(numb)
  return math.floor(numb*100)/100
end

offer = getParamEx("TQBR", "GAZP", "OFFER").param_value
bid = getParamEx("TQBR", "GAZP", "BID").param_value
change = getParamEx("TQBR", "GAZP", "CHANGE").param_value	
lastchange = getParamEx("TQBR", "GAZP", "LASTCHANGE").param_value
numoffers = getParamEx("TQBR", "GAZP", "NUMOFFERS").param_value
numbids = getParamEx("TQBR", "GAZP", "NUMBIDS").param_value
wprice  = getParamEx("TQBR", "GAZP", "WAPRICE").param_value

message("Лучшая цена предложения OFFER: "..mprint(offer))
message("Лучшая цена спроса BID: "..mprint(bid))
message("Разница цены последней сделки к предыдущей сессии CHANGE: "..mprint(change)) 
message("% изменения от закрытия LASTCHANGE: "..mprint(lastchange))
message("Количество заявок на продажу NUMOFFERS: "..mprint(numoffers))
message("Количество заявок на покупку NUMBIDS: "..mprint(numbids))
message("Средневзвешенная цена WAPRICE: "..mprint(wprice))
