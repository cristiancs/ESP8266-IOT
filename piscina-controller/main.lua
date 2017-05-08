t = require('ds18b20')

-- MAPEO PINES
pin0 = 0
pin1 = 1
pin2 = 2
pin3 = 3
pin4 = 4
pin5 = 5
pin6 = 6
pin7 = 7
pin8 = 8
pin9 = 9
pin10 = 10
polaridad ="HIGH"
-- INICIALIZAR PINES
gpio.mode(pin0,gpio.OUTPUT)
gpio.mode(pin1,gpio.OUTPUT)
gpio.mode(pin2,gpio.OUTPUT)
gpio.mode(pin3,gpio.OUTPUT)
gpio.mode(pin5,gpio.OUTPUT)
t.setup(pin6)
gpio.mode(pin7,gpio.INPUT)

-- TODOS A HIGH
gpio.write(pin0,gpio.HIGH)
gpio.write(pin1,gpio.HIGH)
gpio.write(pin2,gpio.HIGH)
gpio.write(pin3,gpio.HIGH)
gpio.write(pin5,gpio.HIGH)

function subscribir()
  -- SUBSCRIBIR TODOS LOS CANALES
  m:subscribe("/exterior/bomba_piscina",0, function(conn)
    end)
  m:subscribe("/exterior/bomba_tinaja",0, function(conn)
    end)
  m:subscribe("/exterior/luz_patio",0, function(conn)
    end)
  m:subscribe("/exterior/luz_interior",0, function(conn)
    end)
  m:subscribe("/exterior/polaridad",0, function(conn)
    end)
  m:subscribe("/exterior/temperatura_piscina",0, function(conn)
    end)
  m:subscribe("/exterior/temperatura_tinaja",0, function(conn)
    end)
  m:subscribe("/exterior/temperatura_exterior",0, function(conn)
    end)
  m:subscribe("/exterior/gas",0, function(conn)
    end)
  print("Subscrito a todos los canales")
end



m:on("message", function(conn, topic, data)
  print(topic..":")
  if data ~= nil then
    print(data)
    if(topic == "/exterior/bomba_piscina") then
      if (data == "OFF") then
        gpio.write(pin0, gpio.HIGH)
      end
      if (data == "ON") then
        gpio.write(pin0, gpio.LOW)
      end
    end
    if(topic == "/exterior/bomba_tinaja") then
      if (data == "OFF") then
        gpio.write(pin1, gpio.HIGH)
      end
      if (data == "ON") then
        gpio.write(pin1, gpio.LOW)
      end
    end
    if(topic == "/exterior/luz_patio") then
      if (data == "OFF") then
        gpio.write(pin3, gpio.HIGH)
      end
      if (data == "ON") then
        gpio.write(pin3, gpio.LOW)
      end
    end
    if(topic == "/exterior/luz_interior") then
      if (data == "OFF") then
        gpio.write(pin2, gpio.HIGH)
      end
      if (data == "ON") then
        gpio.write(pin2, gpio.LOW)
      end
    end
    if(topic == "/exterior/polaridad") then
      if (polaridad == "HIGH") then
        gpio.write(pin5, gpio.LOW)
        polaridad = "LOW"
      end
      if (polaridad == "LOW") then
        gpio.write(pin5, gpio.HIGH)
        polaridad = "HIGH"
      end
    end
    if(topic == "/exterior/temperatura_piscina") then
      if (data == "READ") then
        addrs = t.addrs()
        if #addrs > 2 then
          lectura = t.readNumber(addrs[1])
          else
            lectura = -13.37
          end
        m:publish("/exterior/temperatura_piscina",lectura,0,0, function(conn) 
          print("sent") 
          end)
      end
    end
    if(topic == "/exterior/temperatura_tinaja") then
      if (data == "READ") then
        addrs = t.addrs()
        if #addrs > 0 then
          lectura = t.readNumber(addrs[3])
          else
            lectura = -13.37
          end
        m:publish("/exterior/temperatura_tinaja",lectura,0,0, function(conn) 
          print("sent") 
          end)
      end
    end
    if(topic == "/exterior/temperatura_exterior") then
      if (data == "READ") then
        addrs = t.addrs()
        if #addrs > 1 then
          lectura = t.readNumber(addrs[2])
          else
            lectura = -13.37
          end
        m:publish("/exterior/temperatura_exterior",lectura,0,0, function(conn) 
          print("sent") 
          end)
      end
    end
    if(topic == "/exterior/gas") then
      if (data == "READ") then
        lectura = gpio.read(pin7)
        m:publish("/exterior/gas",lectura,0,0, function(conn) 
          print("sent") 
          end)
      end
    end
  end

end)
