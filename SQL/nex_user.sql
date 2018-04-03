CREATE TABLE `nex_user` (
	`user_id` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`user_passwd` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`user_name` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`access_ip` VARCHAR(16) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`user_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;



INSERT INTO `nex_user` (`user_id`, `user_passwd`, `user_name`, `access_ip`) VALUES
('admin', '1234', '¾îµå¹Î', NULL);
