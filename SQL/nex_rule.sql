CREATE TABLE `nex_rule` (
	`idx` INT(11) NOT NULL AUTO_INCREMENT,
	`target_system` VARCHAR(64) NULL DEFAULT NULL COMMENT '대상 시스템 ( H: Host, M:Master, D:Docker, P:Process, A: Agent, T : Task )' COLLATE 'utf8_general_ci',
	`target` VARCHAR(64) NULL DEFAULT NULL COMMENT '대상' COLLATE 'utf8_general_ci',
	`type` VARCHAR(64) NULL DEFAULT NULL COMMENT '종류(Metric, Log )' COLLATE 'utf8_general_ci',
	`scale_type` CHAR(1) NULL DEFAULT 'U' COMMENT 'Scale조건관련( U: Scale UP, D :Scale Down )' COLLATE 'utf8_general_ci',
	`data_source` VARCHAR(128) NULL DEFAULT NULL COMMENT 'influxdb data source ( DCOS, Telegraf, Mesos...)' COLLATE 'utf8_general_ci',
	`table` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`metric` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Type이 Metric일경우 Metric 이름. Log일경우 Log file full path ' COLLATE 'utf8_general_ci',
	`math` VARCHAR(512) NULL DEFAULT NULL COMMENT '수식( divid ( / ), sum, avg.. )' COLLATE 'utf8_general_ci',
	`group_by` VARCHAR(512) NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`condition` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Metric조건' COLLATE 'utf8_general_ci',
	`message` VARCHAR(1024) NULL DEFAULT NULL COMMENT '기본 Output Text' COLLATE 'utf8_general_ci',
	`status` ENUM('Y','N') NULL DEFAULT 'N' COMMENT 'Rule사용 여부' COLLATE 'utf8_general_ci',
	`new_engine` ENUM('Y','N') NULL DEFAULT 'N' COMMENT '새로운 엔진 사용여부' COLLATE 'utf8_general_ci',
	`regdt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`idx`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;



INSERT INTO `nex_rule` (`target_system`, `target`, `type`, `scale_type`, `data_source`, `table`, `metric`, `math`, `group_by`, `condition`, `message`, `status`, `new_engine`, `regdt`) VALUES
('Agent', 'CPU', 'metric', 'U', 'nexclipper', 'node', 'cpu_used_percent', NULL, 'node_ip', '>95 and >5m', '[%s] 5분동안 CPU 사용율이 95%% 이상 입니다. ', 'Y', 'N', '2018-01-29 01:12:05'),
('Agent', 'Memory', 'metric', 'U', 'nexclipper', 'node', 'mem_used_percent', NULL, 'node_ip', '>95 and >10m', '[%s] 10분동안 Memory 사용율이 95%% 이상입니다. ', 'Y', 'N', '2018-01-29 01:12:05'),
('Task', 'CPU', 'metric', 'U', 'nexclipper', 'task', 'cpu_used_percent', NULL, 'executor_id', '>95 and >5m', '[%s] 5분동안 CPU 사용율이 95%% 이상 입니다. ', 'Y', 'N', '2018-01-29 01:13:15'),
('Task', 'Memory', 'metric', 'U', 'nexclipper', 'task', 'mem_used_percent', NULL, 'executor_id', '>95 and >10m', '[%s] 10분동안 Memory 사용율이 95%% 이상입니다. ', 'Y', 'N', '2018-01-29 01:14:07');

