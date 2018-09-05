require 'mqtt'
require 'json'
require 'slack/incoming/webhooks'
require 'date'

mqtt_config = {
    'server' => 'xxx.xxx.xxx.xxx',
    'port' => '1883',
    'channel' => 'xxx/xxx',
    'keep_alive' => 0,
}
slack_config = {
    'webhook_url' => 'https://hooks.slack.com/services/xxxxxxxxxxxxxxxxxxxxxx',
    'channel' => '#xxxxxxxxxxx',
    'username' => 'cpu_raspi',
}
WARNIGN_TEMPERATURE = 55

def get_time
    dt = DateTime.now
    str = dt.strftime("%Y-%m-%d %H:%M:%S")

    return str
end

slack = Slack::Incoming::Webhooks.new slack_config['webhook_url'], channel: slack_config['channel'], username: slack_config['username']

mqtt = MQTT::Client.connect(host: mqtt_config['server'],
                            port: mqtt_config['port'],
                            keep_alive: mqtt_config['keep_alive']) # xxx: キーワード引数

    mqtt.get(mqtt_config['channel']) do |toppic, message|
    json = JSON.load(message)
    p json
    p json['time']
    p json['sensor']
    p json['temperature']

    if json['temperature'] > WARNIGN_TEMPERATURE
        slack.post "#{WARNIGN_TEMPERATURE}℃を超えています。\n温度：#{json['temperature']}℃\n時間：#{get_time}"
    end

end
