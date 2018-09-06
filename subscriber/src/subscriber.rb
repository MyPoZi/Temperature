require 'mqtt'
require 'json'
require 'slack/incoming/webhooks'
require 'date'
require 'yaml'

WARNIGN_TEMPERATURE = 55

def get_time
    dt = DateTime.now
    str = dt.strftime("%Y-%m-%d %H:%M:%S")

    return str
end

config = YAML.load_file("../conf/config.yml")

slack = Slack::Incoming::Webhooks.new config["slack_config"]["webhook_url"], channel: config["slack_config"]["channel"], username: config["slack_config"]["username"]

mqtt = MQTT::Client.connect(host: config["mqtt_config"]["server"],
                            port: config["mqtt_config"]["port"],
                            keep_alive: config["mqtt_config"]["keep_alive"]) # xxx: キーワード引数

    mqtt.get(config["mqtt_config"]["channel"]) do |toppic, message|
    json = JSON.load(message)
    p json
    p json['time']
    p json['sensor']
    p json['temperature']

    if json['temperature'] > WARNIGN_TEMPERATURE
        slack.post "#{WARNIGN_TEMPERATURE}℃を超えています。\n温度：#{json['temperature']}℃\n時間：#{get_time}"
    end

end
