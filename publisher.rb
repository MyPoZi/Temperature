require 'mqtt'
require 'json'
require 'date'

server = 'xxx.xxx.xxx.xxx'
port = '1883'
channel = 'xxxxxx/xxxxxx'


def division(temperature)

    fTemperature = temperature.to_f.quo(1000) 
    puts fTemperature

    return fTemperature
end
        
MQTT::Client.connect(host: server,
                     port: port) do |c|
                        
    loop do
        # temperature =`cat /sys/class/thermal/thermal_zone0/temp` => CPU温度
        # temp = division(temperature)
        temperature =`sudo /home/pi/usb` # => USB温度
        if temperature.empty? #　時々温度取得エラーにより値が空白になるため
            next
        end         
        temp = temperature.to_f
        p temp

        dt = DateTime.now
        str = dt.strftime("%Y-%m-%d %H:%M:%S")

        value = {'time': str,'sensor': 'xxxx_raspi','temper': temp}
        json = value.to_json 
        
        c.publish(channel, json)

    sleep 60
    end
end
