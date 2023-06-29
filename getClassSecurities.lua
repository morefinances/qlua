-- пример вывода всех торгуемых бумаг на Московской Бирже 
-- общим списком с помощью getClassSecurities()

sec_list = getClassSecurities("TQBR")

ind = 1
for msec in string.gmatch(sec_list, "[^,]+") do
	message(ind..": "..msec)
	ind = ind + 1
end