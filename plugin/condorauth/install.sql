SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for con_system_third_user
-- ----------------------------
DROP TABLE IF EXISTS `con_system_third_user`;
CREATE TABLE `con_system_third_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int unsigned NOT NULL COMMENT 'User.id',
  `platform` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平台类型',
  `open_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台openid',
  `union_id` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信UnionID',
  `access_token` varchar(680) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'access_token',
  `refresh_token` varchar(680) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'refresh_token',
  `expire_in` bigint DEFAULT NULL COMMENT 'expire_in',
  `raw_info` text COLLATE utf8mb4_unicode_ci COMMENT '平台原始用户信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_openid` (`platform`,`open_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_union_id` (`union_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='第三方平台授权用户信息';

-- ----------------------------
-- Records of con_system_third_user
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_user
-- ----------------------------
DROP TABLE IF EXISTS `con_system_user`;
CREATE TABLE `con_system_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int DEFAULT NULL COMMENT 'PID',
  `vip_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'VIP_ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '昵称',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像',
  `level` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `gender` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '性别:0=未知,1=男,2=女',
  `money` decimal(18,4) NOT NULL DEFAULT '0.0000' COMMENT '余额',
  `score` int NOT NULL DEFAULT '0' COMMENT '积分',
  `invite_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邀请码',
  `consecutive_login_days` int unsigned NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `logintime` bigint DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP',
  `loginfailure` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `register_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注册IP',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态:1=正常,2=禁用',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `email` (`email`),
  KEY `mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员表';

-- ----------------------------
-- Records of con_system_user
-- ----------------------------
BEGIN;
INSERT INTO `con_system_user` (`id`, `pid`, `vip_id`, `username`, `nickname`, `password`, `email`, `mobile`, `avatar`, `level`, `gender`, `money`, `score`, `invite_code`, `consecutive_login_days`, `logintime`, `loginip`, `loginfailure`, `register_ip`, `createtime`, `updatetime`, `status`, `deleted_at`) VALUES (1, 0, 0, 'test', 'test1', '', '', '', '/uploads/20260607/b1289e0512b3b068b81b806611746434b4581342.png', 0, 1, 0.0000, 0, 'B64235', 1, NULL, '', 0, '127.0.0.1', 1776501745, 1781616511, 1, NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;