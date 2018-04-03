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
ENGINE=InnoDB
;
