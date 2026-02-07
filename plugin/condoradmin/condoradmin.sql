/*
 Navicat Premium Dump SQL

 Source Server         : sansheng-mysql84
 Source Server Type    : MySQL
 Source Server Version : 80403 (8.4.3)
 Source Host           : localhost:9906
 Source Schema         : condoradmin

 Target Server Type    : MySQL
 Target Server Version : 80403 (8.4.3)
 File Encoding         : 65001

 Date: 01/02/2026 13:35:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for con_system_admin
-- ----------------------------
DROP TABLE IF EXISTS `con_system_admin`;
CREATE TABLE `con_system_admin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '昵称',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号码',
  `loginfailure` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `logintime` bigint DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录IP',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态:1=正常,2=关闭',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员表';

-- ----------------------------
-- Records of con_system_admin
-- ----------------------------
BEGIN;
INSERT INTO `con_system_admin` (`id`, `admin_id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`, `loginfailure`, `logintime`, `loginip`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 0, 'admin', 'admin', '$2y$10$Qu/cSA95pIi6gXW6jJGlPOTPgesy9ERUIsgBS2qYjDDvarySjR6ie', '', '16659230@qq.com', '19175494588', 21, 1769908738, '127.0.0.1', 1, 1762530176, 1769908738, NULL);
INSERT INTO `con_system_admin` (`id`, `admin_id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`, `loginfailure`, `logintime`, `loginip`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 0, 'test', 'test', '$2y$10$c7T0Apqpx7KzRMpxHCqI0.EQ900YgzQQRlV07bqt20r70/PYnTXwu', '', '16659230@qq.com', '19175494588', 6, 1769825131, '127.0.0.1', 1, 1767074249, 1769825131, NULL);
INSERT INTO `con_system_admin` (`id`, `admin_id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`, `loginfailure`, `logintime`, `loginip`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 0, 'condor', 'qwe', '', '', NULL, NULL, 0, NULL, NULL, 1, 1769226913, 1769226926, 1769226926);
COMMIT;

-- ----------------------------
-- Table structure for con_system_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `con_system_admin_log`;
CREATE TABLE `con_system_admin_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作页面',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '日志标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `browser` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '浏览器',
  `os` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '系统',
  `ip_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地区',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'User-Agent',
  `createtime` bigint DEFAULT NULL COMMENT '操作时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='后台操作日志';

-- ----------------------------
-- Records of con_system_admin_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_attachment
-- ----------------------------
DROP TABLE IF EXISTS `con_system_attachment`;
CREATE TABLE `con_system_attachment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type_id` int unsigned DEFAULT '0' COMMENT '类别ID',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '物理路径',
  `storage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `filename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名称',
  `filesize` int unsigned NOT NULL DEFAULT '0' COMMENT '文件大小',
  `mimetype` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'mime类型',
  `extparam` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '透传数据',
  `createtime` bigint DEFAULT NULL COMMENT '创建日期',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片类型',
  `sha1` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '文件 sha1编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='附件表';

-- ----------------------------
-- Records of con_system_attachment
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_attachment_type
-- ----------------------------
DROP TABLE IF EXISTS `con_system_attachment_type`;
CREATE TABLE `con_system_attachment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int DEFAULT '0' COMMENT '管理员ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '名称',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='附件类型';

-- ----------------------------
-- Records of con_system_attachment_type
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_config
-- ----------------------------
DROP TABLE IF EXISTS `con_system_config`;
CREATE TABLE `con_system_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_sys` tinyint unsigned DEFAULT '0' COMMENT '是否系统',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量名',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '变量值',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
  `group_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分组标识',
  `group_id` int DEFAULT NULL COMMENT '分组ID',
  `tips` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类型',
  `is_visible` tinyint DEFAULT NULL COMMENT '是否可见',
  `weigh` int NOT NULL DEFAULT '0' COMMENT '权重',
  `dict_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典name',
  `dict_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典类型',
  `status` tinyint unsigned DEFAULT '0' COMMENT '状态',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `key_group_id_active` (`key`,`group_id`,((case when (`deleted_at` is null) then 1 end)))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统参数配置';

-- ----------------------------
-- Records of con_system_config
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'site_name', 'CondorAdmin', '站点名称', 'base_config', 1, NULL, 'string', 1, 0, NULL, NULL, 1, 1769852933, 1769854781, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'site_logo', NULL, '站点Logo', 'base_config', 1, NULL, 'image', 1, 0, NULL, NULL, 1, 1769852962, 1769852962, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 1, 'site_record_number', NULL, '备案号', 'base_config', 1, '域名备案号', 'string', 1, 0, NULL, NULL, 1, 1769853117, 1769853117, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 1, 'site_copyright', '', '版权信息', 'base_config', 1, NULL, 'string', 1, 0, NULL, NULL, 1, 1769853701, 1769853701, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 1, 'host', 'smtp.qq.com', 'SMTP服务器', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769853821, 1769854602, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 1, 'port', '465', 'SMTP端口', 'email_config', 2, NULL, 'number', 1, 0, NULL, NULL, 1, 1769853842, 1769854602, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 1, 'username', NULL, 'SMTP用户名', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854135, 1769854135, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 1, 'password', NULL, 'SMTP密码', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854166, 1769854166, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 1, 'smtp_secure', 'tsl', 'SMTP验证方式', 'email_config', 2, NULL, 'dict', 1, 0, 'smtp_secure', 'radio', 1, 1769854350, 1769854602, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 1, 'from', NULL, '默认发件人', 'email_config', 2, '默认发件的邮箱地址', 'string', 1, 0, NULL, NULL, 1, 1769854493, 1769854493, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 1, 'from_name', NULL, '默认发件名称', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854533, 1769854533, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 1, 'char_set', 'UTF-8', '编码', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854577, 1769854602, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_config_group
-- ----------------------------
DROP TABLE IF EXISTS `con_system_config_group`;
CREATE TABLE `con_system_config_group` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `is_sys` tinyint unsigned DEFAULT '0' COMMENT '是否系统',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标识',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '更新人',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='配置分组表';

-- ----------------------------
-- Records of con_system_config_group
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config_group` (`id`, `is_sys`, `name`, `code`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, '基本配置', 'base_config', NULL, 1, 1, 1766636482, 1766641935, NULL);
INSERT INTO `con_system_config_group` (`id`, `is_sys`, `name`, `code`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, '邮件配置', 'email_config', NULL, 1, NULL, 1766641925, 1766641925, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_crontab
-- ----------------------------
DROP TABLE IF EXISTS `con_system_crontab`;
CREATE TABLE `con_system_crontab` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `type` tinyint unsigned DEFAULT '1' COMMENT '任务类型',
  `target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '调用任务',
  `params` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '参数',
  `cron` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表达式',
  `cron_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表达式原值',
  `status` tinyint DEFAULT '1' COMMENT '状态:1=正常,2=停用',
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `updated_by` int DEFAULT NULL COMMENT '更新者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务';

-- ----------------------------
-- Records of con_system_crontab
-- ----------------------------
BEGIN;
INSERT INTO `con_system_crontab` (`id`, `name`, `type`, `target`, `params`, `cron`, `cron_value`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 'test', 1, 'sdf', '4444', '0 1 * * * *', '{\"type\":2,\"month\":1,\"day\":1,\"week\":0,\"hour\":4,\"minute\":1,\"second\":5}', 2, '4', 1, 1, 1767533926, 1767617311, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_crontab_log
-- ----------------------------
DROP TABLE IF EXISTS `con_system_crontab_log`;
CREATE TABLE `con_system_crontab_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `crontab_id` int unsigned DEFAULT NULL COMMENT '任务ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `target` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务',
  `params` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '参数',
  `exception_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '异常信息',
  `status` smallint DEFAULT '1' COMMENT '执行状态:1=成功,2=失败',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务日志表';

-- ----------------------------
-- Records of con_system_crontab_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_crud_log
-- ----------------------------
DROP TABLE IF EXISTS `con_system_crud_log`;
CREATE TABLE `con_system_crud_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL,
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Crud 记录';

-- ----------------------------
-- Records of con_system_crud_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `con_system_dict_data`;
CREATE TABLE `con_system_dict_data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` int unsigned DEFAULT NULL COMMENT '字典类型ID',
  `label` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典标签',
  `value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典值',
  `color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典颜色',
  `weigh` int unsigned DEFAULT '0' COMMENT '排序',
  `status` smallint DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `updated_by` int DEFAULT NULL COMMENT '更新者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type_id` (`type_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of con_system_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, '接口', '0', '#656CFF', 0, 1, NULL, 1, 1, 1766570935, 1766657038, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, '菜单', '1', '#18A058', 0, 1, NULL, 1, 1, 1766571038, 1766657006, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, '字符串', 'string', NULL, 0, 1, NULL, 1, NULL, 1766657936, 1766657936, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, '数字', 'number', NULL, 1, 1, NULL, 1, NULL, 1766657956, 1766657956, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 2, '文本域', 'textarea', NULL, 2, 1, NULL, 1, NULL, 1766657974, 1766657974, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 2, '开关', 'switch', NULL, 3, 1, NULL, 1, NULL, 1766657997, 1766657997, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 2, '单图', 'image', NULL, 4, 1, NULL, 1, NULL, 1766658031, 1766658031, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 2, '多图', 'images', NULL, 5, 1, NULL, 1, NULL, 1766658048, 1766658048, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 2, '数组', 'array', NULL, 6, 1, NULL, 1, NULL, 1766658076, 1766658076, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 2, '日期', 'date', NULL, 7, 1, NULL, 1, NULL, 1766658103, 1766658103, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 2, '日期时间', 'datetime', NULL, 8, 1, NULL, 1, NULL, 1766658120, 1766658120, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 2, '日期范围', 'daterange', NULL, 9, 1, NULL, 1, NULL, 1766658138, 1766658138, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, 2, '字典', 'dict', NULL, 10, 1, NULL, 1, NULL, 1766658155, 1766658155, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, 2, '富文本', 'editor', NULL, 11, 1, NULL, 1, NULL, 1766658180, 1766658180, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 3, '单选框', 'radio', NULL, 0, 1, NULL, 1, 1, 1766669350, 1766669425, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 3, '多选框', 'checkbox', NULL, 1, 1, NULL, 1, 1, 1766669371, 1766669429, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 3, '下拉选择', 'select', NULL, 1, 1, NULL, 1, NULL, 1766669413, 1766669413, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 4, '全部', 'all', NULL, 0, 1, NULL, 1, 1, 1767357297, 1767357750, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 4, '图片', 'image', NULL, 1, 1, NULL, 1, 1, 1767357311, 1767357756, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 4, '视频', 'video', NULL, 2, 1, NULL, 1, 1, 1767357321, 1767357760, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 4, '音频', 'audio', NULL, 3, 1, NULL, 1, 1, 1767357332, 1767357765, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 4, '文本', 'txt', NULL, 4, 1, NULL, 1, 1, 1767357342, 1767357769, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 4, '文档', 'word', NULL, 5, 1, NULL, 1, 1, 1767357395, 1767357774, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 4, 'Excel', 'excel', NULL, 6, 1, NULL, 1, 1, 1767357408, 1767357779, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 4, 'PPT', 'ppt', NULL, 7, 1, NULL, 1, 1, 1767357418, 1767357784, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (26, 4, 'PDF', 'pdf', NULL, 8, 1, NULL, 1, 1, 1767357427, 1767357788, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (27, 4, '压缩包', 'zip', NULL, 9, 1, NULL, 1, 1, 1767357437, 1767357793, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (28, 4, '其他', 'other', NULL, 10, 1, NULL, 1, 1, 1767357447, 1767357798, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (29, 5, '两者都有', '0', '#656CFF', 0, 1, NULL, 1, 1, 1767522989, 1767523648, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (30, 5, '前台', '1', NULL, 0, 1, NULL, 1, NULL, 1767522997, 1767522997, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (31, 5, '后台', '2', '#FFA23E', 0, 1, NULL, 1, 1, 1767523004, 1767523672, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (32, 6, '类执行', '1', NULL, 0, 1, NULL, 1, NULL, 1767529393, 1767529393, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (33, 7, 'SSL', 'ssl', NULL, 0, 1, NULL, 1, NULL, 1769854304, 1769854304, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `label`, `value`, `color`, `weigh`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (34, 7, 'TSL', 'tsl', NULL, 0, 1, NULL, 1, NULL, 1769854316, 1769854316, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `con_system_dict_type`;
CREATE TABLE `con_system_dict_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典标题',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典名称',
  `scope` tinyint unsigned DEFAULT '0' COMMENT '可见:0=两者都,1=前台,2=后台',
  `status` smallint DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `updated_by` int DEFAULT NULL COMMENT '更新者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of con_system_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, '菜单类型', 'menu_type', 2, 1, '菜单', 1, 1, 1766565999, 1767523709, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, '表单类型', 'config_form_type', 2, 1, '配置的表单类型', 1, 1, 1766657796, 1767523705, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, '字典组件', 'dict_component', 2, 1, '字典渲染的组件', 1, 1, 1766669327, 1767523700, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, '附件类型', 'attachment_type', 2, 1, '附件', 1, 1, 1767357074, 1767523683, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, '字典可见', 'dict_scope', 2, 1, '前台或后台可见', 1, 1, 1767522966, 1767523723, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, '定时任务类型', 'crontab_type', 2, 1, '定时任务类型', 1, NULL, 1767529330, 1767529330, NULL);
INSERT INTO `con_system_dict_type` (`id`, `title`, `name`, `scope`, `status`, `remark`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 'SMTP验证方式', 'smtp_secure', 2, 1, NULL, 1, NULL, 1769854270, 1769854270, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_login_log
-- ----------------------------
DROP TABLE IF EXISTS `con_system_login_log`;
CREATE TABLE `con_system_login_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录IP地址',
  `ip_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP所属地',
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '浏览器',
  `status` smallint DEFAULT '1' COMMENT '登录状态 (1成功 2失败)',
  `message` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '提示消息',
  `login_time` bigint DEFAULT NULL COMMENT '登录时间',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'UA',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='登录日志表';

-- ----------------------------
-- Records of con_system_login_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for con_system_menu_rule
-- ----------------------------
DROP TABLE IF EXISTS `con_system_menu_rule`;
CREATE TABLE `con_system_menu_rule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_keep` tinyint(1) DEFAULT '0' COMMENT 'is_keep:1=缓存节点',
  `pid` int unsigned DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图标',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则路径',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'component',
  `i18nkey` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '国际化显示,title 被忽略',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `hidden` tinyint(1) DEFAULT NULL COMMENT '是否隐藏',
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `menu_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '菜单:0=接口,1=菜单,2=按钮',
  `href` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由外部链接',
  `active_menu` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '进入该路由激活的菜单项,该路由不在菜单中',
  `multi_tab` tinyint(1) DEFAULT NULL COMMENT '是否使用多个标签页面，默认相同路径共享一个标签页',
  `fixed_tab_index` int DEFAULT NULL COMMENT '路由是否在标签页中固定显示的顺序',
  `query` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由参数',
  `weigh` int DEFAULT '0' COMMENT '权重',
  `status` tinyint DEFAULT '1' COMMENT '状态:1=正常,2=关闭',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `weigh` (`weigh`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='菜单规则';

-- ----------------------------
-- Records of con_system_menu_rule
-- ----------------------------
BEGIN;
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 0, 'home', '控制台', 'mdi:monitor-dashboard', '/home', 'layout.base$view.home', 'route.home', '', 0, NULL, 1, '', '', NULL, NULL, NULL, 0, 1, 1762870065, 1767949463, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 0, 'system', '系统管理', 'carbon:cloud-service-management', '/system', 'layout.base', 'route.system', '', 0, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1762870065, 1769592992, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 1, 9, 'system_menu', '菜单管理', 'material-symbols:route', '/system/menu', 'view.system_menu', 'route.system_menu', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1762870065, 1769593759, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 1, 9, 'system_role', '角色管理', 'carbon:user-role', '/system/role', 'view.system_role', 'route.system_role', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1762870065, 1769593770, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 1, 2, 'system_dict-type', '字典管理', 'qlementine-icons:dictionary-16', '/system/dict-type', 'view.system_dict-type', 'route.system_dict-type', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1762870065, 1769593607, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 1, 2, 'system_config', '配置管理', 'material-symbols:brightness-7-rounded', '/system/config', 'view.system_config', 'route.system_config', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1762870065, 1769593514, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 1, 9, 'system_admin', '管理员列表', 'ic:round-manage-accounts', '/system/admin', 'view.system_admin', 'route.system_admin', '', 0, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1762870065, 1769593748, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 1, 2, 'system_attachment', '附件管理', 'ic:outline-format-list-bulleted', '/system/attachment', 'view.system_attachment', 'route.system_attachment', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1766720165, 1769593623, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 1, 0, 'permission', '权限管理', 'ri:team-line', '/permission', 'layout.base', 'condor.common.permission', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 2, 1, 1767496244, 1769593253, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 0, 2, 'system_crontab', '定时任务', 'material-symbols:alarm-add-outline', '/system/crontab', 'view.system_crontab', 'route.system_crontab', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767529595, 1769593487, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, NULL, 6, 'core_config_index', '配置查看', NULL, '/core/config/index', NULL, NULL, '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767875509, 1767875509, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, NULL, 6, 'core_config_add', '配置添加', NULL, '/core/config/add', NULL, NULL, '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, NULL, 6, 'core_config_edit', '配置编辑', NULL, '/core/config/edit', NULL, NULL, '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, NULL, 6, 'core_config_del', '配置删除', NULL, '/core/config/del', NULL, NULL, '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, NULL, 6, 'core_config_save', '配置保存', NULL, '/core/config/save', NULL, NULL, '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 1, 9, 'system_login-log', '登录日志', 'material-symbols:view-list-sharp', '/system/login-log', 'view.system_login-log', 'route.system_login-log', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767949196, 1769593736, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 1, 9, 'system_admin-log', '操作日志', 'lucide:logs', '/system/admin-log', 'view.system_admin-log', 'route.system_admin-log', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767949383, 1769593724, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 1, 2, 'system_crud', '一键CRUD', 'material-symbols-light:add-ad', '/system/crud', 'view.system_crud', 'route.system_crud', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 5, 1, 1767955613, 1769593658, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 1, 9, 'system_test', 'CRUD 测试', 'mdi:checkbox-multiple-blank-circle-outline', '/system/test', 'view.system_test', 'route.system_test', '', 0, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1769593676, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 1, 19, 'core_system-test_index', '查看', '', '/core/system-test/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 1, 19, 'core_system-test_add', '添加', '', '/core/system-test/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 1, 19, 'core_system-test_edit', '编辑', '', '/core/system-test/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 1, 19, 'core_system-test_del', '删除', '', '/core/system-test/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 1, 19, 'core_system-test_multi', '批量操作', '', '/core/system-test/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 1, 19, 'core_system-test_selectpage', '选择列表', '', '/core/system-test/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (60, 1, 3, 'core_system_menu_index', '查看', '', '/core/menu/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (61, 1, 3, 'core_system_menu_add', '添加', '', '/core/menu/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (62, 1, 3, 'core_system_menu_edit', '编辑', '', '/core/menu/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (63, 1, 3, 'core_system_menu_del', '删除', '', '/core/menu/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (64, 1, 3, 'core_system_menu_multi', '批量操作', '', '/core/menu/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (65, 1, 3, 'core_system_menu_selectpage', '选择列表', '', '/core/menu/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (66, 1, 4, 'core_system_role_index', '查看', '', '/core/role/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (67, 1, 4, 'core_system_role_add', '添加', '', '/core/role/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (68, 1, 4, 'core_system_role_edit', '编辑', '', '/core/role/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (69, 1, 4, 'core_system_role_del', '删除', '', '/core/role/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (70, 1, 4, 'core_system_role_multi', '批量操作', '', '/core/role/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (71, 1, 4, 'core_system_role_selectpage', '选择列表', '', '/core/role/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (72, 1, 5, 'core_dict-type_index', '类型查看', '', '/core/dict-type/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (73, 1, 5, 'core_dict-type_add', '类型添加', '', '/core/dict-type/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (74, 1, 5, 'core_dict-type_edit', '类型编辑', '', '/core/dict-type/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (75, 1, 5, 'core_dict-type_del', '类型删除', '', '/core/dict-type/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (76, 1, 5, 'core_dict-type_multi', '类型批量操作', '', '/core/dict-type/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (77, 1, 5, 'core_dict-type_selectpage', '类型选择列表', '', '/core/dict-type/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (78, 1, 5, 'core_dict-data_index', '数据查看', '', '/core/dict-data/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (79, 1, 5, 'core_dict-data_add', '数据添加', '', '/core/dict-data/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (80, 1, 5, 'core_dict-data_edit', '数据编辑', '', '/core/dict-data/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (81, 1, 5, 'core_dict-data_del', '数据删除', '', '/core/dict-data/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (82, 1, 5, 'core_dict-data_multi', '数据批量操作', '', '/core/dict-data/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (83, 1, 5, 'core_dict-data_selectpage', '数据选择列表', '', '/core/dict-data/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (84, 1, 7, 'core_system_admin_index', '查看', '', '/core/admin/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (85, 1, 7, 'core_system_admin_add', '添加', '', '/core/admin/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (86, 1, 7, 'core_system_admin_edit', '编辑', '', '/core/admin/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (87, 1, 7, 'core_system_admin_del', '删除', '', '/core/admin/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (88, 1, 7, 'core_system_admin_multi', '批量操作', '', '/core/admin/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (89, 1, 7, 'core_system_admin_selectpage', '选择列表', '', '/core/admin/selectpage', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (90, 1, 6, 'core_config-group_index', '分组查看', '', '/core/config-group/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (91, 1, 6, 'core_config-group_add', '分组添加', '', '/core/config-group/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (92, 1, 6, 'core_config-group_edit', '分组编辑', '', '/core/config-group/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (93, 1, 6, 'core_config-group_del', '分组删除', '', '/core/config-group/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (94, 1, 6, 'core_config-group_multi', '分组批量操作', '', '/core/config-group/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (95, 1, 8, 'core_attachment-type_index', '类型查看', '', '/core/attachment-type/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (96, 1, 8, 'core_attachment-type_add', '类型添加', '', '/core/attachment-type/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (97, 1, 8, 'core_attachment-type_edit', '类型编辑', '', '/core/attachment-type/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (98, 1, 8, 'core_attachment-type_del', '类型删除', '', '/core/attachment-type/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (99, 1, 8, 'core_attachment-type_multi', '类型批量操作', '', '/core/attachment-type/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (100, 1, 8, 'core_attachment_index', '附件查看', '', '/core/attachment/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (101, 1, 8, 'core_attachment_del', '附件删除', '', '/core/attachment/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (102, 1, 8, 'core_attachment_upload', '附件上传', '', '/core/attachment/upload', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (103, 1, 10, 'core_crontab_index', '查看', '', '/core/crontab/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (104, 1, 10, 'core_crontab_add', '添加', '', '/core/crontab/add', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (105, 1, 10, 'core_crontab_edit', '编辑', '', '/core/crontab/edit', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (106, 1, 10, 'core_crontab_del', '删除', '', '/core/crontab/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (107, 1, 10, 'core_crontab_multi', '批量操作', '', '/core/crontab/multi', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (108, 1, 10, 'core_crontab_run-once', '运行一次', '', '/core/crontab/run-once', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (109, 1, 10, 'core_crontab-log_index', '日志查看', '', '/core/crontab-log/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (110, 1, 16, 'core_login-log_del', '删除', '', '/core/login-log/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (111, 1, 16, 'core_login-log_index', '查看', '', '/core/login-log/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (112, 1, 17, 'core_admin-log_del', '删除', '', '/core/admin-log/del', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (113, 1, 17, 'core_admin-log_index', '查看', '', '/core/admin-log/index', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (114, 1, 18, 'core_crud_config', '获取配置', '', '/core/crud/config', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (115, 1, 18, 'core_crud_fields', '表字段', '', '/core/crud/fields', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (116, 1, 18, 'core_crud_create', '创建', '', '/core/crud/create', NULL, NULL, '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_role
-- ----------------------------
DROP TABLE IF EXISTS `con_system_role`;
CREATE TABLE `con_system_role` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_sys` tinyint unsigned DEFAULT '0' COMMENT '是否系统',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `pid` int unsigned NOT NULL DEFAULT '0' COMMENT '父组别',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '角色名称',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '规则ID',
  `status` tinyint DEFAULT '1' COMMENT '状态:1=正常,2=关闭',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='角色表';

-- ----------------------------
-- Records of con_system_role
-- ----------------------------
BEGIN;
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `name`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 1, 0, 'superadmin', '超级管理员', '', 1, 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `name`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 0, 1, 0, 'superadmin', '超级管理', NULL, 1, 1766417865, 1766487550, NULL);
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `name`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 0, 1, 2, 'test', 'test', '1,9,19,16,111,17,113,20,2,5,77,78,83,6,11,90,8,95,10,103,109,18,114,115,100,72,3,60,65,4,66,71,7,84,89,25,21,24,22,23', 1, 1766546252, 1769827337, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_role_group
-- ----------------------------
DROP TABLE IF EXISTS `con_system_role_group`;
CREATE TABLE `con_system_role_group` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `uid` int unsigned NOT NULL COMMENT '管理员ID',
  `role_id` int unsigned NOT NULL COMMENT '角色ID',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uid_group_id` (`uid`,`role_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `group_id` (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员所属角色分组';

-- ----------------------------
-- Records of con_system_role_group
-- ----------------------------
BEGIN;
INSERT INTO `con_system_role_group` (`id`, `uid`, `role_id`, `createtime`) VALUES (1, 1, 1, 1769824635);
INSERT INTO `con_system_role_group` (`id`, `uid`, `role_id`, `createtime`) VALUES (2, 3, 3, 1769824642);
COMMIT;

-- ----------------------------
-- Table structure for con_system_test
-- ----------------------------
DROP TABLE IF EXISTS `con_system_test`;
CREATE TABLE `con_system_test` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '目标',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片',
  `images` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片组',
  `attachfile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '附件',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '描述',
  `price` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '价格',
  `views` int unsigned DEFAULT '0' COMMENT '点击',
  `activitytime` bigint DEFAULT NULL COMMENT '活动时间',
  `refreshtime` bigint DEFAULT NULL COMMENT '刷新时间',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试';

-- ----------------------------
-- Records of con_system_test
-- ----------------------------
BEGIN;
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
