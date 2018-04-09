# NexClipper

## Summary
NexCloud Monitoring Solution for Private Cloud (DCOS).
<hr>

## Prerequisites
Access to public agent node<br>
<pre>$ ssh root@&lt;public node ip&gt;</pre><br>
* InfluxDB<br> 
    <pre>$ dcos package install influxdb</pre>
* MySQL<br>
    <pre>$ dcos package install mysql<br>$ dcos package install mysql-admin</pre>
* Redis
    <pre>$ dcos package install redis</pre>
* Kafka
    <pre>$ dcos package install kafka</pre>
<hr>

## Configuration
MySQL에서 다음 SQL 문을 실행한다.
### [nex_rule.sql](https://github.com/nexclouding/NexClipper/blob/master/SQL/nex_rule.sql)
* Node / Container의 CPU/Memory 임계치 설정
* Notification 을 위해 사용

### [nex_notification.sql](https://github.com/nexclouding/NexClipper/blob/master/SQL/nex_notification.sql)
* nex_rule.sql의 설정에 의해 생성된 데이터 저장

### [nex_node.sql](https://github.com/nexclouding/NexClipper/blob/master/SQL/nex_node.sql)
* Metric에 의해 수집된 Node 정보 저장

### [nex_config.sql](https://github.com/nexclouding/NexClipper/blob/master/SQL/nex_config.sql)

* Modify
    ```sql
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
    ('scretKey'                 , 'DC/OS가 설치된 master 서버의 "var/lib/dcos/dcos-oauth/auth-token-secret" 데이터'),
    ('uid'                      , 'DC/OS에 추가한 임의의 사용자'),
    ('kafka_snapshot_group'     , 'KAFKA SNAPSHOT CONSUMER GROUP NAME');
    ```

* Default
    ```sql
    INSERT INTO `nex_config` (`code`, `value`) VALUES
    ('influxdb', 'http://influxdb.marathon.l4lb.thisdcos.directory:8086'),
    ('kafka_host', 'broker.kafka.l4lb.thisdcos.directory'),
    ('kafka_mesos_group', 'workflow_consumer'),
    ('kafka_notification_group', 'assurance_consumer'),
    ('kafka_port', '9092'),
    ('kafka_zookeeper', 'master.mesos:2181/dcos-service-kafka'),
    ('mesos_topic', 'data_collector'),
    ('mesos_endpoint', 'http://192.168.0.161'),
    ('mesos_influxdb', 'nexclipper'),
    ('mesos_snapshot_topic', 'data_snapshot'),
    ('notification_topic', 'data_assurance'),
    ('redis_host', 'redis.marathon.l4lb.thisdcos.directory'),
    ('redis_port', '6379'),
    ('scretKey', 'TjRihTXJiMQMvxtOGcLYDqIXgaQJDuLYWYqyCEaxrsOuKULKqKjvgltroQrpGkIP'),
    ('uid', 'admin@nexcloud.co.kr'),
    ('kafka_snapshot_group', 'snapshot_consumer');
    ```
<hr>

### [nexclipper.json](https://github.com/nexclouding/NexClipper/blob/master/JSON/nexclipper.json)
#### "id": "nexclipper/collecter" ###
* Modify
    ```json
    "env": {
        "MYSQL_DBNAME": "YOUR DBNAME",
        "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
        "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
        "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
    },
    ```
* Default
    ```json
    "env": {
        "MYSQL_DBNAME": "defaultdb",
        "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306",
        "MYSQL_PASSWORD": "password",
        "MYSQL_USERNAME": "admin"
    },
    ```
---
#### "id": "nexclipper/workflow" ###
* Modify
    ```json
    "env": {
        "REDIS_HOST": "YOUR REDIS CONNECTION URL",
        "MYSQL_DBNAME": "YOUR DBNAME",
        "REDIS_PORT": "YOUR REDIS PORT",
        "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
        "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
        "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
    },
    ```
* Default
    ```json
    "env": {
        "REDIS_HOST": "redis.marathon.l4lb.thisdcos.directory",
        "MYSQL_DBNAME": "defaultdb",
        "REDIS_PORT": "6379",
        "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306",
        "MYSQL_PASSWORD": "password",
        "MYSQL_USERNAME": "admin"
    },
    ```
---
#### "id": "nexclipper/nexclipper" ###
* Modify
    ```json
    "env": {
        "REDIS_HOST": "YOUR REDIS CONNECTION URL",
        "MYSQL_DBNAME": "YOUR DBNAME",
        "REDIS_PORT": "YOUR REDIS PORT",
        "MYSQL_URL": "YOUR MYSQL CONNECTION URL",
        "MYSQL_PASSWORD": "YOUR MYSQL PASSWORD",
        "MYSQL_USERNAME": "YOUR MYSQL USERNAME"
    },
    ```
* Default
    ```json
    "env": {
        "REDIS_HOST": "redis.marathon.l4lb.thisdcos.directory",
        "MYSQL_DBNAME": "defaultdb",
        "REDIS_PORT": "6379",
        "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306",
        "MYSQL_PASSWORD": "password",
        "MYSQL_USERNAME": "admin"
    },
    ```
<hr>

## Install NexClipper
* Access to public agent node
    ```bash
    $ ssh root@&<public node ip>
    ```
* Deploy NexClipper
    ```bash
    $ dcos marathon group add https://github.com/nexclouding/NexClipper/blob/master/JSON/nexclipper.json
    ```