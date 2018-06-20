CREATE TABLE `nex_config` (
	`code` VARCHAR(64) NOT NULL COMMENT 'KEY' COLLATE 'utf8_general_ci',
	`value` TEXT NOT NULL COMMENT 'VALUE' COLLATE 'utf8_general_ci'
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


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
-- secret key location --
-- At master node : /var/lib/dcos/dcos-oauth/auth-token-secret --
('scretKey', 'TjRihTXJiMQMvxtOGcLYDqIXgaQJDuLYWYqyCEaxrsOuKULKqKjvgltroQrpGkIP'),
-- DC/OS User ID --
('uid', 'admin@nexcloud.co.kr'),
('kafka_snapshot_group', 'snapshot_consumer');
