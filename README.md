# Temperature  

**bundlerとかDocker使いこなせるようになりたい**

ほぼメモ ：D  

description：RaspberryPiのCPU温度をpublisherでbrokerにpublishして、subscriberでbrokerからsubscribeする

publusher：Raspberry Pi3 Debian 9.0(だと思う)  
subscriber：CentOS 7.5.1804  

publisher側  
`$ sudo gem install mqtt json`

broker側(subscriber側)  
`$ sudo yum install mosquitto mosquitto-clients`
`$ sudo gem install slack-incoming-webhooks mqtt json`

firewall設定(恒久的な)  
この設定をしないと外部からアクセスできない(個人差あり)  
ここでハマった  
`$ firewall-cmd --add-port=1883/tcp --zone=public --permanent`  

`$ sudo yum install sqlite`  

`$ sqlite3 temperature.db`  
`> create table temperature(time text, sensor text, temperature real);`  
`> .mode column`  
`> .headers on`  

`$ sudo gem install sqlite3`  
すんなり出来なかったんでソース取ってきてビルドしてインストール  
gccない人はまず  
`$ sudo yum -y install gcc gcc-c++`

`$ wget https://www.sqlite.org/2018/sqlite-autoconf-3240000.tar.gz`  
`$ tar vxzf sqlite-autoconf-3240000.tar.gz`  
`$ cd sqlite-autoconf-3240000`  
`$ ./configure`  
`$ make`  
`$ sudo make install`  
`$ sudo gem install sqlite3`  

subcriber側の設定が大変だった  
全くメモ取らずに自分のPCに環境づくりしたため、色々抜けているところがあると思う  
こういうことがあるから、Dockerの全く同じ環境作れるメリットをひしひしと感じる  
あとパスワードとかTLSの設定していないYO
