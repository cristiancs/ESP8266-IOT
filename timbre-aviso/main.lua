
-- MAPEO PINES
pin2 = 4
gpio.mode(pin2,gpio.INPUT)
function delay_ms (milli_secs)
   local ms = milli_secs * 1000
   local timestart = tmr.now ( )

   while (tmr.now ( ) - timestart < ms) do
      tmr.wdclr ( )
   end
end



function subscribir()
  -- SUBSCRIBIR TODOS LOS CANALES
  m:subscribe("/exterior/timbre",0, function(conn)
    end)
  print("Subscrito a todos los canales")
end
m:on("message", function(conn, topic, data)
  print(topic..":")
  if data ~= nil then
    print(data)
    if(topic == "/exterior/timbre") then
        gpio.write(pin2, gpio.HIGH)
        delay_ms(100)
        gpio.write(pin2, gpio.LOW)
        delay_ms(50)
        gpio.write(pin2, gpio.HIGH)
        delay_ms(100)
        gpio.write(pin2, gpio.LOW)
        delay_ms(50)
    end
  end

end)
