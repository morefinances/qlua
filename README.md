# qlua
Shared Access Scripts on QLua (for a trading terminal Quik)

Скрипты для торгового терминала Quik. Общий доступ.
Не забудьте после скачивания установить кодировку
moextickers.lua Windows-1251. Quik только с ней дружит.
Иначе будет нечитаемо.

moextickers.lua:
Скрипт делает выгрузку всех торгуемых акций на Московской Бирже (иногда встречаются варианты с нулевыми объемами, но с индикативными ценами). 
Сохраняет результат в файл C:\\files\\tickers.csv.
Параллельно выводит список с разбивкой по 5 бумаг в строку в терминале.

downloads.lua: запускается следом после moextickers.lua
Скрипт выгрузки котировок цен OHLC, Value (оборот в руб.), LegalClosePrice (закрытие дневной сессии в18:50); ClosePrice (закрытие в 23:50), 
плюс LegalClosePrice и ClosePrice предыдущей торговой сессии.

Cкрипт запускается по таймеру (HTimeOut – час выгрузки по МСК, MTimeOut — минуты) и делает выгрузку всей необходимой информации из таблицы текущих торгов. 
Тикеры берутся из только что полученного файла C:\files\tickers.csv (его готовит скрипт moextickers.lua, запускается предварительно первым, при необходимости список бумаг можно в csv уменьшить). 

Я запускаю параллельно 2 подобных скрипта, один делает выгрузку в 18:55 под закрытие основной сессии, 
после чего сам выключается, второй в 23:55 и также выключается.

Файл записывает логи по которым можно смотреть всё ли прошло нормально в logs.csv.

В процессе выгрузки если получены нулевые значения, то скрипт ожидает 100 мс и перезапрашивает данные, если за 10 итераций ничего не получено (значит ничего и нет), то переходит далее. 

Предусмотрено, что может отключаться сервер, скрипт ждет восстановления связи. 
Если далее связь возобновляется скрипт продолжает дожидаться нужного времени и штатно делает выгрузку. 

Если через 7 часов после старта (я запускаю в начале 6го) выгрузка не состоялась скрипт по таймеру (indTimer) выключает работу. Если ваш компьютер уходит в спящий режим, то скорее всего и терминал «засыпает». Поэтому у меня стоит в настройках никогда не уходить в спящий режим, чтобы всё корректно работало.

Результаты записываются в файлы downloads с датой и временем выгрузки в названии файла всё в той же C:\files\ директории.

Статусы текущих состояний работы скриптов выводятся в отдельные таблички.

