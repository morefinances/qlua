function OnInit()
-- инициализирует глобальные переменные и константы
progname="example_one: "
do_it = true
end

function OnStop()
-- функция остановки скрипта, активируется при нажатии клавиши «Остановить» 
do_it = false
message(progname.." завершение работы")
end

function main()
--основная функция
message(progname.." старт")


while do_it do

	sleep(1000)
end

end

