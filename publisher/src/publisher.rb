require 'mqtt'
require 'json'
require 'date'
require 'yaml'

SLEEP_TIME = 60
SENSOR_NAME = 'xxx_cpu_raspi'

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

config = YAML.load_file("../conf/config.yml")

MQTT::Client.connect(host: config["mqtt_config"]["server"],
                     port: config["mqtt_config"]["port"],
                     keep_alive: config["mqtt_config"]["keep_alive"]) do |client|

  loop do
    #――――publisherのCPU温度を取得する場合――――
    temperature = `cat /sys/class/thermal/thermal_zone0/temp` # => CPUの温度
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

    value = {'time' => get_time, 'sensor' => SENSOR_NAME, 'temperature' => temp}
    json = value.to_json

    client.publish(config["mqtt_config"]["channel"], json)

    sleep SLEEP_TIME
  end
end
