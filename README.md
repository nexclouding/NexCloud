# NexCloud

## Summary
NexCloud는 프라이빗 DC/OS 모니터링 솔루션입니다. Apache MESOS, Marathon 클러스터 요약, 리소스 할당 및 사용현황, 마스터 모니터링, 에이전트 상태를 모니터링하고 전문화된 컨테이너 성능 모니터링 및 관리기능을 제공합니다.  

[Prerequisites](#prerequisites) | [Configuration](#configuration) | [Installation](#installation)
<br>

* Architecture  

    <img src="./imgs/Architecture.PNG" width="700"></img>  

* Full Stack Dashboard  

    <img src="./imgs/dashboard.PNG" width="700"></img>  

* Agent Map  

    <img src="./imgs/agent.PNG" width="700"></img>

* Container  

    <img src="./imgs/container.PNG" width="700"></img>  

<hr>

## Features
* Full Stack Dashboard
* Container Cluster Resource Allocation & Usage Monitoring
* Private Cloud Monitoring: Agent / Container
* Container Performance Monitoring & Tracing
* Event Notification And Event Trace
* Major Framework & Service Monitoring
* Container Status Monitoring
<hr>

## Prerequisites
Access to DC/OS CLI installed node  
```bash
$ ssh root@<DC/OS CLI installed node>
```
* [InfluxDB](https://universe.dcos.io/#/package/influxdb/version/latest)  
    ```bash
    $ dcos package install influxdb
    ```
* [MySQL](https://universe.dcos.io/#/package/mysql/version/latest) / [MySQL-admin](https://universe.dcos.io/#/package/mysql-admin/version/latest)  
    ```bash
    $ dcos package install mysql
    $ dcos package install mysql-admin
    ```
* [Redis](https://universe.dcos.io/#/package/redis/version/latest)
    ```bash
    $ dcos package install redis
    ```
* [Kafka](https://universe.dcos.io/#/package/kafka/version/latest)
    ```bash
    $ dcos package install kafka
    ```
<hr>

## Installation
1. Follow [Configuration](#configuration) steps

2. MySQL Table Create

3. MySQL Data Create.  
    -> nex_config table

4. Access to DC/OS CLI installed node  
    ```bash
    $ ssh root@<DC/OS CLI installed node>
    ```
5. Select Install Type  

    -> [Group Install](#group-install)  
    -> [Component Install](#component-install)

* Execute Service  
    http://nexcloud-service-endpoint/v1/dashboard
<hr>

## Configuration

1. SQL

    MySQL에서 다음 SQL 문을 실행한다.
    
    * [nex_notification.sql](/SQL/nex_notification.sql)
        * notification 데이터 저장 테이블
            ```sql
            CREATE TABLE `nex_notification` (
                `idx` INT(11) NOT NULL AUTO_INCREMENT,
                `severity` ENUM('Critical','Warning') NOT NULL DEFAULT 'Critical' COMMENT 'Notification등급( Critical, Warning)' COLLATE 'utf8_general_ci',
                `target_system` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Notification 대상 ( \'Host\',\'Agent\',\'Task\',\'Framework\',\'Docker\' )' COLLATE 'utf8_general_ci',
                `target_ip` VARCHAR(32) NULL DEFAULT NULL COMMENT '발생대상 IP' COLLATE 'utf8_general_ci',
                `target` VARCHAR(124) NULL DEFAULT NULL COMMENT '발생 대상( CPU, Memory, Disk, Netowrk, System Error..... )' COLLATE 'utf8_general_ci',
                `metric` VARCHAR(512) NULL DEFAULT NULL COMMENT '수행 Metric' COLLATE 'utf8_general_ci',
                `condition` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Condition' COLLATE 'utf8_general_ci',
                `id` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Service/Task/Node/Framework의 Service ID or IP' COLLATE 'utf8_general_ci',
                `status` ENUM('S','F') NULL DEFAULT 'S' COMMENT '상태 (\'S\':발생, \'F\':종료)' COLLATE 'utf8_general_ci',
                `start_time` TIMESTAMP NULL DEFAULT NULL COMMENT '시작시간',
                `finish_time` TIMESTAMP NULL DEFAULT NULL COMMENT '종료시간',
                `contents` TEXT NOT NULL COMMENT 'notification 내용' COLLATE 'utf8_general_ci',
                `memo` TEXT NULL COLLATE 'utf8_general_ci',
                `check_yn` CHAR(1) NOT NULL DEFAULT 'N' COLLATE 'utf8_general_ci',
                `regdt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`idx`),
                INDEX `severity` (`severity`),
                INDEX `target_system` (`target_system`),
                INDEX `target_ip` (`target_ip`),
                INDEX `id` (`id`),
                INDEX `status` (`status`),
                INDEX `start_time` (`start_time`),
                INDEX `finish_time` (`finish_time`),
                INDEX `regdt` (`regdt`)
            )
            COLLATE='latin1_swedish_ci'
            ENGINE=InnoDB;
            ```
            <br>
    * [nex_node.sql](/SQL/nex_node.sql)
        * DC/OS 노드 정보
            ```sql
            CREATE TABLE `nex_node` (
                `node_name` VARCHAR(64) NOT NULL COMMENT '노드명',
                `node_ip` VARCHAR(32) NOT NULL COMMENT '노드 IP',
                `node_id` VARCHAR(64) NOT NULL COMMENT '노드 ID',
                `role` VARCHAR(64) NOT NULL COMMENT 'role(agent, master)',
                `parent` VARCHAR(64) NULL DEFAULT NULL COMMENT 'parent host정보',
                `status` VARCHAR(2) NOT NULL COMMENT '노드상태',
                `regdt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
                UNIQUE INDEX `node_ip` (`node_ip`)
            )
            COLLATE='utf8_general_ci'
            ENGINE=InnoDB;
            ```
            <br>
    * [nex_config.sql](/SQL/nex_config.sql)
        * 필수 설정 정보

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
            ('mesos_endpoint', 'http://leader.mesos'),
            ('mesos_influxdb', 'nexclipper'),
            ('mesos_snapshot_topic', 'data_snapshot'),
            ('notification_topic', 'data_assurance'),
            ('redis_host', 'redis.marathon.l4lb.thisdcos.directory'),
            ('redis_port', '6379'),
            ('scretKey', 'TjRihTXJiMQMvxtOGcLYDqIXgaQJDuLYWYqyCEaxrsOuKULKqKjvgltroQrpGkIP'),
            ('uid', 'admin@nexcloud.co.kr'),
            ('kafka_snapshot_group', 'snapshot_consumer');
            ```

        * Modify
            ```sql
            INSERT INTO `nex_config` (`code`, `value`) VALUES
            ('influxdb'                 , 'INFLUXDB CONNECTION URL'),
            ('kafka_host'               , 'KAFKA BROKER ADDRESS'),
            ('kafka_mesos_group'        , 'KAFKA MESOS CONSUMER GROUP NAME - Unique Name'),
            ('kafka_notification_group' , 'KAFKA ASSURANCE CONSUMER GROUP NAME - Unique Name'),
            ('kafka_port'               , 'KAFKA CONNECTION PORT'),
            ('kafka_zookeeper'          , 'KAFKA ZOOKEEPER CONNECTION URL'),
            ('mesos_topic'              , 'MESOS METRIC KAFKA TOPIC NAME - Unique Name'),
            ('mesos_endpoint'           , 'MESOS ENDPOINT'),
            ('mesos_influxdb'           , 'MESOS METRIC INFLUXDB TABLE NAME - Unique Name'),
            ('mesos_snapshot_topic'     , 'MESOS SNAPSHOT METRIC KAFKA TOPIC NAME - Unique Name'),
            ('notification_topic'       , 'ASSURANCE METRIC KAFKA TOPIC NAME - Unique Name'),
            ('redis_host'               , 'REDIS CONNECTION URL'),
            ('redis_port'               , 'REDIS CONNECTION PORT'),
            ('scretKey'                 , 'DC/OS가 설치된 master 서버의 "/var/lib/dcos/dcos-oauth/auth-token-secret" 데이터'),
            ('uid'                      , 'DC/OS에 등록된 사용자'),
            ('kafka_snapshot_group'     , 'KAFKA SNAPSHOT CONSUMER GROUP NAME - Unique Name');
            ```
    <hr>

2. Deployment JSON Modify
    * [nexcloud.json](/JSON/nexcloud.json)
        * "id": "nexcloud/collecter"
            * Default
                ```json
                "env": {
                    "MYSQL_DBNAME": "defaultdb (MySQL DB name)",
                    "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306 (MySQL URL)",
                    "MYSQL_PASSWORD": "password (MySQL password)",
                    "MYSQL_USERNAME": "admin (MySQL account)"
                },
                ```
        ---
        * "id": "nexcloud/workflow"
            * Default
                ```json
                "env": {
                    "REDIS_HOST": "redis.marathon.l4lb.thisdcos.directory (Redis URL)",
                    "MYSQL_DBNAME": "defaultdb (MySQL DB name)",
                    "REDIS_PORT": "6379 (Redis port)",
                    "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306 (MySQL URL)",
                    "MYSQL_PASSWORD": "password (MySQL password)",
                    "MYSQL_USERNAME": "admin (MySQL account)"
                },
                ```
        ---
        * "id": "nexcloud/nexcloudui"
            * Default
                ```json
                "env": {
                    "REDIS_HOST": "redis.marathon.l4lb.thisdcos.directory (Redis URL)",
                    "MYSQL_DBNAME": "defaultdb (MySQL DB name)",
                    "REDIS_PORT": "6379 (Redis port)",
                    "MYSQL_URL": "mysql.marathon.l4lb.thisdcos.directory:3306 (MySQL URL)",
                    "MYSQL_PASSWORD": "password (MySQL password)",
                    "MYSQL_USERNAME": "admin (MySQL account)"
                },
                ```

    <hr>

## Group install
* Deploy NexCloud
    ```bash
    $ dcos marathon group add https://raw.githubusercontent.com/nexclouding/NexCloud/master/JSON/nexcloud.json
    ```
---

## Component Install
1. [collecter.json](/JSON/components/collecter.json)
    ```bash
    $ dcos marathon app add https://raw.githubusercontent.com/nexclouding/NexCloud/master/JSON/components/collecter.json 
    ```
2. [workflow.json](/JSON/components/workflow.json)
    ```bash
    $ dcos marathon app add https://raw.githubusercontent.com/nexclouding/NexCloud/master/JSON/components/workflow.json  
    ```
3. [nexcloudui.json](/JSON/components/nexcloudui.json)
    ```bash
    $ dcos marathon app add https://raw.githubusercontent.com/nexclouding/NexCloud/master/JSON/components/nexcloudui.json
    ```