function OnInit()
	do_it = true 
	progname="example_four: "
end


function OnStop()
	do_it = false
	message(progname.." завершение работы")
end



function main()
	
	message(progname.." старт")

	connect = isConnected()
	
	if connect == 1 then 
		message(progname..' связь с сервером установлена')
	else
		message(progname..'связи с сервером нет')
	end 
	
	
	while do_it do
	 


			
	sleep(1000)
	end
		

end
 
