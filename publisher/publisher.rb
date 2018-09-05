require 'mqtt'
require 'json'
require 'date'

mqtt_config = {
    'server' => 'xxx.xxx.xxx.xxx',
    'port' => '1883',
    'channel' => 'xxx/xxx',
    'keep_alive' => 0,
}
SLEEP_TIME = 60
SENSOR_NAME = 'xxx'

def division(temperature)
    float_temperature = temperature.to_f.quo(1000)
    p float_temperature

    return float_temperature
end

def get_time
    dt = DateTime.now
    str = dt.strftime("%Y-%m-%d %H:%M:%S")

    return str
end

MQTT::Client.connect(host: mqtt_config['server'],
                     port: mqtt_config['port'],
                     keep_alive: mqtt_config['keep_alive']) do |client|

    loop do
        #――――publisherのCPU温度を取得する場合――――
        temperature =`cat /sys/class/thermal/thermal_zone0/temp` # => CPUの温度
        temp = division(temperature)
        #――――――――――――――――――――――――

        #――――USBで温度を取得する場合――――
        # temperature =`sudo /home/pi/usb` # => USB温度
        # if temperature.empty? #　時々、USB温度取得エラーにより値が空白になるため
        #     next
        # end
        # p float_temperature
        # temp = temperature.to_f
        #――――――――――――――――――――

        time = get_time

        value = {'time': time,'sensor': SENSOR_NAME,'temperature': temp}
        json = value.to_json

        client.publish(mqtt_config['channel'], json)

    sleep SLEEP_TIME
    end
end
