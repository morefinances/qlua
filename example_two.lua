function OnInit()
-- инициализирует глобальные переменные и константы
	progname="example_two: "
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

		for i=1, 10 do
		
			time1 = os.sysdate()
			time2 = getInfoParam('SERVERTIME')

			time_txt=time1.hour..":"..time1.min..":"..time1.sec
			message("Время через os.sysdate: "..time_txt.." время SERVERTIME:"..time2)
			sleep(250)
			
		end


	while do_it do
	

		
		sleep(1000)
	end

end

