-- пример вывода всех торгуемых бумаг на Московской Бирже 
-- общим списком с помощью getClassSecurities()
-- по некоторым могут быть нулевые объемы, 
-- но биржа всё равно их держит в списке с 
-- индикативными ценами.

sec_list = getClassSecurities("TQBR")

ind = 1
for msec in string.gmatch(sec_list, "[^,]+") do
	message(ind..": "..msec)
	ind = ind + 1
end
