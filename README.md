# NexClipper

NexCloud Monitoring Solution for Private Cloud (DCOS).

--------

## Prerequisites
* InfluxDB
* MySQL
* Redis
* Kafka
<hr>

## Development Environment
<img src="/img/dev_env.png" width="400"></img>
<br/>
<hr>

## Architecture
<img src="/img/Architecture.png" width="500"></img>
<br/>
<hr>

## Collector API
<img src="/img/Collecter_API.png" width="400"></img>
<br/>
<hr>

## SMACK API
<img src="/img/SMACK_API.PNG" width="400"></img>
<br/>
<hr>

## Configuration
### nex_rule.sql
* Node / Container의 CPU/Memory 임계치 설정
* Notification 을 위해 사용

### nex_notification.sql
* nex_rul.sql의 설정에 의해 생성된 데이터 저장

### nex_node.sql
* Metric에 의해 수집된 Node 정보 저장

### nex_config.sql
<pre>
INSERT INTO `nex_config` (`code`, `value`) VALUES
('influxdb'                 , 'INFLUXDB CONNECTION URL'),
('kafka_host'               , 'KAFKA BROKER ADDRESS'),
('kafka_mesos_group'        , 'KAFKA MESOS CONSUMER GROUP NAME'),
('kafka_notification_group' , 'KAFKA ASSURANCE CONSUMER GROUP NAME'),
('kafka_port'               , 'KAFKA CONNECTION PORT'),
('kafka_zookeeper'          , 'KAFKA ZOOKEEPER CONNECTION URL'),
('mesos_topic'              , 'MESOS METRIC KAFKA TOPIC NAME'),
('mesos_endpoint'           , 'MESOS ENDPOINT'),
('mesos_influxdb'           , 'MESOS METRIC INFLUXDB TABLE NAME'),
('mesos_snapshot_topic'     , 'MESOS SNAPSHOT METRIC KAFKA TOPIC NAME'),
('notification_topic'       , 'ASSURANCE METRIC KAFKA TOPIC NAME'),
('redis_host'               , 'REDIS CONNECTION URL'),
('redis_port'               , 'REDIS CONNECTION PORT'),
('scretKey'                 , 'DC/OS가 설치된 master 서버의 "var/lib/dcos/dcos-oauth/auth-token-secret 데이터'),
('uid'                      , 'DC/OS에 추가한 임의의 사용자'),
('kafka_snapshot_group'     , 'KAFKA SNAPSHOT CONSUMER GROUP NAME');
</pre>
<hr>

### nexclipper.json
#### "id": "nexclipper/collecter" ###
<pre>
"env": {
    "MYSQL_DBNAME": "YOUR DBNAME",
    "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
    "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
    "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
},
</pre>

#### "id": "nexclipper/workflow" ###
<pre>
"env": {
    "REDIS_HOST": "YOUR REDIS CONNECTION URL",
    "MYSQL_DBNAME": "YOUR DBNAME",
    "REDIS_PORT": "YOUR REDIS PORT",
    "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
    "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
    "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
},
</pre>

#### "id": "nexclipper/nexclipper" ###
<pre>
"env": {
    "REDIS_HOST": "YOUR REDIS CONNECTION URL",
    "MYSQL_DBNAME": "YOUR DBNAME",
    "REDIS_PORT": "YOUR REDIS PORT",
    "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
    "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
    "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
},
</pre>