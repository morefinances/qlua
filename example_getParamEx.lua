last_type = getParamEx("TQBR", "GAZP", "LAST").param_type
last_value = getParamEx("TQBR", "GAZP", "LAST").param_value
last_image = getParamEx("TQBR", "GAZP", "LAST").param_image

message("Цена последней сделки по Газпрому: ")
message("тип: "..last_type)
message("значение : "..last_value)
message("строка: "..last_image)
