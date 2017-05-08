contador = 20
tmr.alarm(1,1000,1, function()
	if contador ~= 0 then
		print("Esperando "..contador.." segundos antes de iniciar")
		contador = contador-1
	else
		tmr.stop(1)
	end
end)

dofile("config.lua")

--Connect to the wifi network

wifi.setmode(wifi.STATION) 
wifi.setphymode(wifi_signal_mode)
wifi.sta.config(wifi_SSID, wifi_password) 
wifi.sta.connect()
tmr.alarm(1, 5000, 1, function() 
    if wifi.sta.getip()== nil then
        print('IP unavaiable, waiting...') 
    else
        tmr.stop(1)
        print('IP is '..wifi.sta.getip())
        dofile('connect.lua')
    end
 end)
