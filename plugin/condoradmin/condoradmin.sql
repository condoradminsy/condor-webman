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

 Date: 24/05/2026 09:33:00
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
INSERT INTO `con_system_admin` (`id`, `admin_id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`, `loginfailure`, `logintime`, `loginip`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 0, 'admin', 'admin', '$2y$10$c7T0Apqpx7KzRMpxHCqI0.EQ900YgzQQRlV07bqt20r70/PYnTXwu', '', '16659230@qq.com', '19175494588', 21, 1775813651, '127.0.0.1', 1, 1762530176, 1775813651, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='后台操作日志';

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='附件表';

-- ----------------------------
-- Records of con_system_attachment
-- ----------------------------
BEGIN;
INSERT INTO `con_system_attachment` (`id`, `type_id`, `admin_id`, `user_id`, `url`, `storage`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `type`, `sha1`) VALUES (1, 1, 1, 0, '/uploads/20260201/20260201152336_697eff78cdcdd.png', 'local', '1-1.png', 14532, 'image/png', '[]', 1769930616, 1769930616, 'image', '9cb3e3fec57e81bd4a91398939c8a6349c464ace');
INSERT INTO `con_system_attachment` (`id`, `type_id`, `admin_id`, `user_id`, `url`, `storage`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `type`, `sha1`) VALUES (2, 1, 1, 0, '/uploads/20260201/20260201152346_697eff827d6cf.png', 'local', '144x144.png', 37225, 'image/png', '[]', 1769930626, 1769930626, 'image', '6d1ecea2d0725a68c18b97727f9e47a1d7385a66');
INSERT INTO `con_system_attachment` (`id`, `type_id`, `admin_id`, `user_id`, `url`, `storage`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `type`, `sha1`) VALUES (3, 0, 1, 0, '/uploads/20260201/20260201152415_697eff9f2c1db.jpg', 'local', 'logo1.jpg', 43752, 'image/jpeg', '[]', 1769930655, 1769930655, 'image', 'caacb12e6b7017b6457914f88230570d3b766c77');
INSERT INTO `con_system_attachment` (`id`, `type_id`, `admin_id`, `user_id`, `url`, `storage`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `type`, `sha1`) VALUES (4, 0, 1, 0, '/uploads/20260201/20260201152450_697effc2058e2.pdf', 'local', 'mysql优化.pdf', 580124, 'application/pdf', '[]', 1769930690, 1769930690, 'pdf', '53e3eaf49c553b0edba6d5537822ba24e11344df');
COMMIT;

-- ----------------------------
-- Table structure for con_system_attachment_type
-- ----------------------------
DROP TABLE IF EXISTS `con_system_attachment_type`;
CREATE TABLE `con_system_attachment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int DEFAULT '0' COMMENT '管理员ID',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='附件类型';

-- ----------------------------
-- Records of con_system_attachment_type
-- ----------------------------
BEGIN;
INSERT INTO `con_system_attachment_type` (`id`, `admin_id`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 1771467329, 1771467329, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_attachment_type_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_attachment_type_translations`;
CREATE TABLE `con_system_attachment_type_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '名称',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='附件类型';

-- ----------------------------
-- Records of con_system_attachment_type_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_attachment_type_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'en-us', 'test', 1771467397, 1771467397, NULL);
INSERT INTO `con_system_attachment_type_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'zh-cn', '测试', 1771467397, 1771467397, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统参数配置';

-- ----------------------------
-- Records of con_system_config
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'site_name', 'CondorAdmin', '站点名称', 'base_config', 1, NULL, 'string', 1, 0, NULL, NULL, 1, 1769852933, 1769854781, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'site_logo', NULL, '站点Logo', 'base_config', 1, NULL, 'image', 1, 0, NULL, NULL, 1, 1769852962, 1769852962, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 1, 'site_record_number', NULL, '备案号', 'base_config', 1, '域名备案号', 'string', 1, 0, NULL, NULL, 1, 1769853117, 1769853117, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 1, 'site_copyright', '', '版权信息', 'base_config', 1, NULL, 'string', 1, 0, NULL, NULL, 1, 1769853701, 1769853701, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 1, 'host', 'smtp.share-email.com', 'SMTP服务器', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769853821, 1773413649, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 1, 'port', '465', 'SMTP端口', 'email_config', 2, NULL, 'number', 1, 0, NULL, NULL, 1, 1769853842, 1769854602, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 1, 'username', 'sa45l.com', 'SMTP用户名', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854135, 1773413649, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 1, 'password', 'sh45t', 'SMTP密码', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854166, 1773413649, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 1, 'smtp_secure', 'ssl', 'SMTP验证方式', 'email_config', 2, NULL, 'dict', 1, 0, 'smtp_secure', 'radio', 1, 1769854350, 1770431390, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 1, 'from', 'sa45com', '默认发件人', 'email_config', 2, '默认发件的邮箱地址', 'string', 1, 0, NULL, NULL, 1, 1769854493, 1773413686, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 1, 'from_name', 'sanrenxing', '默认发件名称', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854533, 1770431683, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 1, 'char_set', 'UTF-8', '编码', 'email_config', 2, NULL, 'string', 1, 0, NULL, NULL, 1, 1769854577, 1769854602, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, 0, 'gateways', 'aliyun', '', 'sms_config', 3, '', 'dict', 1, 0, 'sms_gateways', 'select', 1, 1771409912, 1779543115, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, 0, 'access_key_id', '824f0ff2f71cab52936axxxxxxxxxx', '', 'sms_config', 3, '', 'string', 1, 0, NULL, NULL, 1, 1779543619, 1779544668, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 0, 'access_key_secret', '824f0ff2f71cab52936axff2f71cab52936axxxxxxxxxx', '', 'sms_config', 3, '', 'string', 1, 0, NULL, NULL, 1, 1779543660, 1779544668, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 0, 'sign_name', 'XX 科技', '', 'sms_config', 3, '', 'string', 1, 0, NULL, NULL, 1, 1779543692, 1779544668, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 0, 'is_template', '1', '', 'sms_config', 3, '', 'switch', 1, 0, NULL, NULL, 1, 1779544492, 1779544668, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 0, 'template_code', 'SMS_001', '', 'sms_config', 3, '', 'string', 1, 0, NULL, NULL, 1, 1779544547, 1779544668, NULL);
INSERT INTO `con_system_config` (`id`, `is_sys`, `key`, `value`, `title`, `group_code`, `group_id`, `tips`, `type`, `is_visible`, `weigh`, `dict_code`, `dict_type`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 0, 'sms_content', '您的验证码为：${code}，该验证码5分钟内有效，请勿泄露给他人【XX科技】', '', 'sms_config', 3, '', 'textarea', 1, 0, NULL, NULL, 1, 1779544573, 1779544668, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_config_group
-- ----------------------------
DROP TABLE IF EXISTS `con_system_config_group`;
CREATE TABLE `con_system_config_group` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `is_sys` tinyint unsigned DEFAULT '0' COMMENT '是否系统',
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标识',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '更新人',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='配置分组表';

-- ----------------------------
-- Records of con_system_config_group
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config_group` (`id`, `is_sys`, `code`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'base_config', 1, 1, 1766636482, 1766641935, NULL);
INSERT INTO `con_system_config_group` (`id`, `is_sys`, `code`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'email_config', 1, NULL, 1766641925, 1766641925, NULL);
INSERT INTO `con_system_config_group` (`id`, `is_sys`, `code`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 1, 'sms_config', 1, 1, 1771397627, 1779541762, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_config_group_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_config_group_translations`;
CREATE TABLE `con_system_config_group_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `locale_main_id` (`locale`,`main_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='配置分组表语言表';

-- ----------------------------
-- Records of con_system_config_group_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'zh-cn', '基本配置', NULL, 1766636482, 1766636482, NULL);
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'en-us', 'Basic Configuration', NULL, 1766636482, 1766636482, NULL);
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'zh-cn', '邮件配置', NULL, 1766636482, 1766636482, NULL);
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'en-us', 'Mail Configuration', NULL, 1766636482, 1766636482, NULL);
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 3, 'zh-cn', '短信配置', '', 1771397627, 1779541778, NULL);
INSERT INTO `con_system_config_group_translations` (`id`, `main_id`, `locale`, `name`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 3, 'en-us', 'Sms Configuration', '', 1771397627, 1779541778, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_config_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_config_translations`;
CREATE TABLE `con_system_config_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
  `tips` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `locale_main_id` (`main_id`,`locale`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统参数配置';

-- ----------------------------
-- Records of con_system_config_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'zh-cn', '站点名称', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'en-us', 'Site Name', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'zh-cn', '站点Logo', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'en-us', 'Site Logo', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 3, 'zh-cn', '备案号', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 3, 'en-us', 'ICP Filing Number', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 4, 'zh-cn', '版权信息', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 4, 'en-us', 'Copyright Notice', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 5, 'zh-cn', 'SMTP服务器', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 5, 'en-us', 'SMTP server', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 6, 'zh-cn', 'SMTP端口', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 6, 'en-us', 'SMTP Port', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 7, 'zh-cn', 'SMTP用户名', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 7, 'en-us', 'SMTP Username', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 8, 'zh-cn', 'SMTP密码', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 8, 'en-us', 'SMTP Password', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 9, 'zh-cn', 'SMTP验证方式', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 9, 'en-us', 'SMTP Secure', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 10, 'zh-cn', '默认发件人', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 10, 'en-us', 'Default Sender', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 11, 'zh-cn', '默认发件名称', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 11, 'en-us', 'Default Sender Name', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 12, 'zh-cn', '编码', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (26, 12, 'en-us', 'Char Set', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (27, 13, 'zh-cn', '发送网关', '可用的发送网关', 1771409912, 1779543096, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (28, 13, 'en-us', 'Gateways', 'Available Sending Gateways', 1771409912, 1779543096, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (33, 14, 'en-us', 'Access Key', '', 1779543619, 1779543619, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (34, 14, 'zh-cn', 'Access Key', '', 1779543619, 1779543619, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (35, 15, 'en-us', 'Access Secret', '', 1779543660, 1779543660, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (36, 15, 'zh-cn', 'Access Secret', '', 1779543660, 1779543660, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (37, 16, 'en-us', 'Sign Name', '', 1779543692, 1779543699, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (38, 16, 'zh-cn', '短信签名', '', 1779543692, 1779543699, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (41, 17, 'en-us', 'Use a template', '', 1779544492, 1779544492, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (42, 17, 'zh-cn', '是否使用模板', '', 1779544492, 1779544492, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (43, 18, 'en-us', 'Template Code', '', 1779544547, 1779544547, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (44, 18, 'zh-cn', '模板编号', '', 1779544547, 1779544547, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (45, 19, 'en-us', 'Sms Content', '', 1779544573, 1779544573, NULL);
INSERT INTO `con_system_config_translations` (`id`, `main_id`, `locale`, `title`, `tips`, `createtime`, `updatetime`, `deleted_at`) VALUES (46, 19, 'zh-cn', '短信内容', '', 1779544573, 1779544573, NULL);
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
  `value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典值',
  `color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典颜色',
  `weigh` int unsigned DEFAULT '0' COMMENT '排序',
  `status` smallint DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `updated_by` int DEFAULT NULL COMMENT '更新者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type_id` (`type_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of con_system_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, '0', '#656CFF', 0, 1, 1, 1, 1766570935, 1766657038, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, '1', '#18A058', 0, 1, 1, 1, 1766571038, 1766657006, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'string', NULL, 0, 1, 1, NULL, 1766657936, 1766657936, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'number', NULL, 1, 1, 1, NULL, 1766657956, 1766657956, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 2, 'textarea', NULL, 2, 1, 1, NULL, 1766657974, 1766657974, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 2, 'switch', NULL, 3, 1, 1, NULL, 1766657997, 1766657997, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 2, 'image', NULL, 4, 1, 1, NULL, 1766658031, 1766658031, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 2, 'images', NULL, 5, 1, 1, NULL, 1766658048, 1766658048, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 2, 'array', NULL, 6, 1, 1, NULL, 1766658076, 1766658076, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 2, 'date', NULL, 7, 1, 1, NULL, 1766658103, 1766658103, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 2, 'datetime', NULL, 8, 1, 1, NULL, 1766658120, 1766658120, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 2, 'daterange', NULL, 9, 1, 1, NULL, 1766658138, 1766658138, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, 2, 'dict', NULL, 10, 1, 1, NULL, 1766658155, 1766658155, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, 2, 'editor', NULL, 11, 1, 1, NULL, 1766658180, 1766658180, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 3, 'radio', NULL, 0, 1, 1, 1, 1766669350, 1766669425, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 3, 'checkbox', NULL, 1, 1, 1, 1, 1766669371, 1766669429, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 3, 'select', NULL, 1, 1, 1, NULL, 1766669413, 1766669413, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 4, 'all', NULL, 0, 1, 1, 1, 1767357297, 1767357750, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 4, 'image', NULL, 1, 1, 1, 1, 1767357311, 1767357756, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 4, 'video', NULL, 2, 1, 1, 1, 1767357321, 1767357760, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 4, 'audio', NULL, 3, 1, 1, 1, 1767357332, 1767357765, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 4, 'txt', NULL, 4, 1, 1, 1, 1767357342, 1767357769, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 4, 'word', NULL, 5, 1, 1, 1, 1767357395, 1767357774, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 4, 'excel', NULL, 6, 1, 1, 1, 1767357408, 1767357779, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 4, 'ppt', NULL, 7, 1, 1, 1, 1767357418, 1767357784, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (26, 4, 'pdf', NULL, 8, 1, 1, 1, 1767357427, 1767357788, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (27, 4, 'zip', NULL, 9, 1, 1, 1, 1767357437, 1767357793, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (28, 4, 'other', NULL, 10, 1, 1, 1, 1767357447, 1767357798, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (29, 5, '0', '#656CFF', 0, 1, 1, 1, 1767522989, 1767523648, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (30, 5, '1', NULL, 0, 1, 1, NULL, 1767522997, 1767522997, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (31, 5, '2', '#FFA23E', 0, 1, 1, 1, 1767523004, 1767523672, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (32, 6, '1', NULL, 0, 1, 1, NULL, 1767529393, 1767529393, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (33, 7, 'ssl', NULL, 0, 1, 1, NULL, 1769854304, 1769854304, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (34, 7, 'tsl', NULL, 0, 1, 1, NULL, 1769854316, 1769854316, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (35, 8, 'aliyun', NULL, 0, 1, 1, NULL, 1779542030, 1779542030, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (36, 8, 'aliyunrest', NULL, 0, 1, 1, NULL, 1779542069, 1779542069, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (37, 8, 'aliyunintl', NULL, 0, 1, 1, NULL, 1779542119, 1779542119, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (38, 8, 'aliyundypns', NULL, 0, 1, 1, NULL, 1779542156, 1779542156, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (39, 8, 'yunpian', NULL, 0, 1, 1, NULL, 1779542180, 1779542180, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (40, 8, 'submail', NULL, 0, 1, 1, NULL, 1779542218, 1779542218, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (41, 8, 'luosimao', NULL, 0, 1, 1, NULL, 1779542274, 1779542274, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (42, 8, 'yuntongxun', NULL, 0, 1, 1, NULL, 1779542306, 1779542306, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (43, 8, 'huyi', NULL, 0, 1, 1, NULL, 1779542327, 1779542327, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (44, 8, 'juhe', NULL, 0, 1, 1, NULL, 1779542349, 1779542349, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (45, 8, 'sendcloud', NULL, 0, 1, 1, NULL, 1779542370, 1779542370, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (46, 8, 'baidu', NULL, 0, 1, 1, NULL, 1779542390, 1779542390, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (47, 8, 'huaxin', NULL, 0, 1, 1, NULL, 1779542411, 1779542411, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (48, 8, 'chuanglan', NULL, 0, 1, 1, NULL, 1779542445, 1779542445, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (49, 8, 'chuanglanv1', NULL, 0, 1, 1, NULL, 1779542468, 1779542468, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (50, 8, 'rongcloud', NULL, 0, 1, 1, NULL, 1779542493, 1779542493, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (51, 8, 'tianyiwuxian', NULL, 0, 1, 1, NULL, 1779542512, 1779542512, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (52, 8, 'twilio', NULL, 0, 1, 1, NULL, 1779542544, 1779542544, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (53, 8, 'tiniyo', NULL, 0, 1, 1, NULL, 1779542568, 1779542568, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (54, 8, 'qcloud', NULL, 0, 1, 1, NULL, 1779542589, 1779542589, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (55, 8, 'huawei', NULL, 0, 1, 1, NULL, 1779542614, 1779542614, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (56, 8, 'yunxin', NULL, 0, 1, 1, NULL, 1779542633, 1779542633, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (57, 8, 'yunzhixun', NULL, 0, 1, 1, NULL, 1779542651, 1779542651, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (58, 8, 'kingtto', NULL, 0, 1, 1, NULL, 1779542670, 1779542670, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (59, 8, 'qiniu', NULL, 0, 1, 1, NULL, 1779542689, 1779542689, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (60, 8, 'ucloud', NULL, 0, 1, 1, NULL, 1779542708, 1779542708, NULL);
INSERT INTO `con_system_dict_data` (`id`, `type_id`, `value`, `color`, `weigh`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (61, 8, 'smsbao', NULL, 0, 1, 1, NULL, 1779542729, 1779542729, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_dict_data_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_dict_data_translations`;
CREATE TABLE `con_system_dict_data_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典标签',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of con_system_dict_data_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'zh-cn', '接口', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'en-us', 'API', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'zh-cn', '菜单', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'en-us', 'Menu', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 3, 'zh-cn', '字符串', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 3, 'en-us', 'String', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 4, 'zh-cn', '数字', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 4, 'en-us', 'Number', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 5, 'zh-cn', '文本域', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 5, 'en-us', 'Textarea', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 6, 'zh-cn', '开关', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 6, 'en-us', 'Switch', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, 7, 'zh-cn', '单图', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, 7, 'en-us', 'Image', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 8, 'zh-cn', '多图', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 8, 'en-us', 'Images', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 9, 'zh-cn', '数组', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 9, 'en-us', 'Array', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 10, 'zh-cn', '日期', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 10, 'en-us', 'Date', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 11, 'zh-cn', '日期时间', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 11, 'en-us', 'Datetime', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 12, 'zh-cn', '日期范围', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 12, 'en-us', 'Daterange', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 13, 'zh-cn', '字典', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (26, 13, 'en-us', 'Dictionary', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (27, 14, 'zh-cn', '富文本', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (28, 14, 'en-us', 'Editor', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (29, 15, 'zh-cn', '单选框', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (30, 15, 'en-us', 'Radio', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (31, 16, 'zh-cn', '多选框', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (32, 16, 'en-us', 'Checkbox', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (33, 17, 'zh-cn', '下拉选择', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (34, 17, 'en-us', 'Select', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (35, 18, 'zh-cn', '全部', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (36, 18, 'en-us', 'All', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (37, 19, 'zh-cn', '图片', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (38, 19, 'en-us', 'Image', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (39, 20, 'zh-cn', '视频', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (40, 20, 'en-us', 'Video', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (41, 21, 'zh-cn', '音频', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (42, 21, 'en-us', 'Audio', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (43, 22, 'zh-cn', '文本', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (44, 22, 'en-us', 'Txt', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (45, 23, 'zh-cn', '文档', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (46, 23, 'en-us', 'Word', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (47, 24, 'zh-cn', 'Excel', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (48, 24, 'en-us', 'Excel', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (49, 25, 'zh-cn', 'PPT', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (50, 25, 'en-us', 'PPT', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (51, 26, 'zh-cn', 'PDF', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (52, 26, 'en-us', 'PDF', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (53, 27, 'zh-cn', '压缩包', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (54, 27, 'en-us', 'Zip', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (55, 28, 'zh-cn', '其他', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (56, 28, 'en-us', 'Other', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (57, 29, 'zh-cn', '两者都有', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (58, 29, 'en-us', 'Both', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (59, 30, 'zh-cn', '前台', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (60, 30, 'en-us', 'Front', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (61, 31, 'zh-cn', '后台', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (62, 31, 'en-us', 'Backend', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (63, 32, 'zh-cn', '类执行', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (64, 32, 'en-us', 'Class execution', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (65, 33, 'zh-cn', 'SSL', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (66, 33, 'en-us', 'SSL', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (67, 34, 'zh-cn', 'TSL', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (68, 34, 'en-us', 'TSL', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (69, 35, 'en-us', 'Aliyun', '', 1779542030, 1779542030, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (70, 35, 'zh-cn', '阿里云', '', 1779542030, 1779542030, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (71, 36, 'en-us', 'AliyunRest', '', 1779542069, 1779542069, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (72, 36, 'zh-cn', '阿里云Rest', '', 1779542069, 1779542069, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (73, 37, 'en-us', 'Aliyunintl', '', 1779542119, 1779542119, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (74, 37, 'zh-cn', '阿里云国际', '', 1779542119, 1779542119, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (75, 38, 'en-us', 'Aliyundypns', '', 1779542156, 1779542156, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (76, 38, 'zh-cn', '阿里云短信认证', '', 1779542156, 1779542156, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (77, 39, 'en-us', 'Yunpian', '', 1779542180, 1779542180, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (78, 39, 'zh-cn', '云片', '', 1779542180, 1779542180, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (79, 40, 'en-us', 'Submail', '', 1779542218, 1779542218, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (80, 40, 'zh-cn', 'Submail', '', 1779542218, 1779542218, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (81, 41, 'en-us', 'Luosimao', '', 1779542274, 1779542274, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (82, 41, 'zh-cn', '螺丝帽', '', 1779542274, 1779542274, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (83, 42, 'en-us', 'Yuntongxun', '', 1779542306, 1779542306, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (84, 42, 'zh-cn', '容联云通讯', '', 1779542306, 1779542306, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (85, 43, 'en-us', 'Huyi', '', 1779542327, 1779542327, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (86, 43, 'zh-cn', '互亿无线', '', 1779542327, 1779542327, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (87, 44, 'en-us', 'Juhe', '', 1779542349, 1779542349, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (88, 44, 'zh-cn', '聚合数据', '', 1779542349, 1779542349, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (89, 45, 'en-us', 'SendCloud', '', 1779542370, 1779542370, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (90, 45, 'zh-cn', 'SendCloud', '', 1779542370, 1779542370, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (91, 46, 'en-us', 'Baidu', '', 1779542390, 1779542390, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (92, 46, 'zh-cn', '百度云', '', 1779542390, 1779542390, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (93, 47, 'en-us', 'Huaxin', '', 1779542411, 1779542411, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (94, 47, 'zh-cn', '华信短信平台', '', 1779542411, 1779542411, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (95, 48, 'en-us', 'Chuanglan', '', 1779542445, 1779542445, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (96, 48, 'zh-cn', '253云通讯（创蓝）', '', 1779542445, 1779542445, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (97, 49, 'en-us', 'Chuanglanv1', '', 1779542468, 1779542468, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (98, 49, 'zh-cn', '创蓝云智', '', 1779542468, 1779542468, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (99, 50, 'en-us', 'Rongcloud', '', 1779542493, 1779542493, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (100, 50, 'zh-cn', '融云', '', 1779542493, 1779542493, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (101, 51, 'en-us', 'Tianyiwuxian', '', 1779542512, 1779542512, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (102, 51, 'zh-cn', '天毅无线', '', 1779542512, 1779542512, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (103, 52, 'en-us', 'Twilio', '', 1779542544, 1779542544, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (104, 52, 'zh-cn', 'Twilio', '', 1779542544, 1779542544, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (105, 53, 'en-us', 'Tiniyo', '', 1779542568, 1779542568, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (106, 53, 'zh-cn', 'Tiniyo', '', 1779542568, 1779542568, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (107, 54, 'en-us', 'Qcloud', '', 1779542589, 1779542589, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (108, 54, 'zh-cn', '腾讯云 SMS', '', 1779542589, 1779542589, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (109, 55, 'en-us', 'Huawei', '', 1779542614, 1779542614, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (110, 55, 'zh-cn', '华为云 SMS', '', 1779542614, 1779542614, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (111, 56, 'en-us', 'Yunxin', '', 1779542633, 1779542633, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (112, 56, 'zh-cn', '网易云信', '', 1779542633, 1779542633, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (113, 57, 'en-us', 'Yunzhixun', '', 1779542651, 1779542651, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (114, 57, 'zh-cn', '云之讯', '', 1779542651, 1779542651, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (115, 58, 'en-us', 'Kingtto', '', 1779542670, 1779542670, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (116, 58, 'zh-cn', '凯信通', '', 1779542670, 1779542670, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (117, 59, 'en-us', 'Qiniu', '', 1779542689, 1779542689, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (118, 59, 'zh-cn', '七牛云', '', 1779542689, 1779542689, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (119, 60, 'en-us', 'Ucloud', '', 1779542708, 1779542708, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (120, 60, 'zh-cn', 'Ucloud', '', 1779542708, 1779542708, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (121, 61, 'en-us', 'Smsbao', '', 1779542729, 1779542729, NULL);
INSERT INTO `con_system_dict_data_translations` (`id`, `main_id`, `locale`, `label`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (122, 61, 'zh-cn', '短信宝', '', 1779542729, 1779542729, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `con_system_dict_type`;
CREATE TABLE `con_system_dict_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典名称',
  `scope` tinyint unsigned DEFAULT '0' COMMENT '可见:0=两者都,1=前台,2=后台',
  `status` smallint DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `created_by` int DEFAULT NULL COMMENT '创建者',
  `updated_by` int DEFAULT NULL COMMENT '更新者',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of con_system_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 'menu_type', 2, 1, 1, 1, 1766565999, 1767523709, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 'config_form_type', 2, 1, 1, 1, 1766657796, 1767523705, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 'dict_component', 2, 1, 1, 1, 1766669327, 1767523700, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 'attachment_type', 2, 1, 1, 1, 1767357074, 1767523683, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 'dict_scope', 2, 1, 1, 1, 1767522966, 1767523723, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 'crontab_type', 2, 1, 1, NULL, 1767529330, 1767529330, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 'smtp_secure', 2, 1, 1, NULL, 1769854270, 1769854270, NULL);
INSERT INTO `con_system_dict_type` (`id`, `name`, `scope`, `status`, `created_by`, `updated_by`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 'sms_gateways', 2, 1, 1, NULL, 1779541962, 1779541962, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_dict_type_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_dict_type_translations`;
CREATE TABLE `con_system_dict_type_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典标题',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of con_system_dict_type_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'zh-cn', '菜单类型', '菜单', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'en-us', 'Menu Type', 'Menu', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'zh-cn', '表单类型', '配置的表单类型', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'en-us', 'Form Type', 'The type of form configured', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 3, 'zh-cn', '字典组件', '字典渲染的组件', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 3, 'en-us', 'Dict component', 'Dictionary-rendered component', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 4, 'zh-cn', '附件类型', '附件', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 4, 'en-us', 'Attachment Type', 'Attachment', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (9, 5, 'zh-cn', '字典可见', '前台或后台可见', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (10, 5, 'en-us', 'Dict Scope', 'Scope of dictionary visibility', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, 6, 'zh-cn', '定时任务类型', '定时任务类型', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, 6, 'en-us', 'Scheduled Task Type', 'Scheduled Task Type', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, 7, 'zh-cn', 'SMTP验证方式', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, 7, 'en-us', 'SMTP Secure Type', '', 1769852933, 1769852933, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, 8, 'en-us', 'SMS Gateway Identifier', 'easy-sms Gateway Identifier', 1779541962, 1779541962, NULL);
INSERT INTO `con_system_dict_type_translations` (`id`, `main_id`, `locale`, `title`, `remark`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 8, 'zh-cn', '短信网关标识', 'easy-sms 网关标识', 1779541962, 1779541962, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='登录日志表';

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
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='菜单规则';

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
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (11, NULL, 6, 'core_config_index', '配置查看', NULL, '/core/config/index', NULL, 'condor.route.configuration_view', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767875509, 1767875509, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (12, NULL, 6, 'core_config_add', '配置添加', NULL, '/core/config/add', NULL, 'condor.route.configuration_add', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (13, NULL, 6, 'core_config_edit', '配置编辑', NULL, '/core/config/edit', NULL, 'condor.route.configuration_edit', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (14, NULL, 6, 'core_config_del', '配置删除', NULL, '/core/config/del', NULL, 'condor.route.configuration_delete', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (15, NULL, 6, 'core_config_save', '配置保存', NULL, '/core/config/save', NULL, 'condor.route.configuration_save', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (16, 1, 9, 'system_login-log', '登录日志', 'material-symbols:view-list-sharp', '/system/login-log', 'view.system_login-log', 'route.system_login-log', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767949196, 1769593736, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (17, 1, 9, 'system_admin-log', '操作日志', 'lucide:logs', '/system/admin-log', 'view.system_admin-log', 'route.system_admin-log', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767949383, 1769593724, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (18, 1, 2, 'system_crud', '一键CRUD', 'material-symbols-light:add-ad', '/system/crud', 'view.system_crud', 'route.system_crud', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 5, 1, 1767955613, 1769593658, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (19, 1, 9, 'system_test', 'CRUD 测试', 'mdi:checkbox-multiple-blank-circle-outline', '/system/test', 'view.system_test', 'route.system_test', '', 0, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1769593676, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (20, 1, 19, 'core_system-test_index', '查看', '', '/core/system-test/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (21, 1, 19, 'core_system-test_add', '添加', '', '/core/system-test/add', NULL, 'condor.route.add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (22, 1, 19, 'core_system-test_edit', '编辑', '', '/core/system-test/edit', NULL, 'condor.route.edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (23, 1, 19, 'core_system-test_del', '删除', '', '/core/system-test/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (24, 1, 19, 'core_system-test_multi', '批量操作', '', '/core/system-test/multi', NULL, 'condor.route.bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (25, 1, 19, 'core_system-test_selectpage', '选择列表', '', '/core/system-test/selectpage', NULL, 'condor.route.selection_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (26, NULL, 6, 'core_config_send_test_email', '发送测试邮件', NULL, '/core/config/send-test-email', NULL, 'condor.route.send_test_email', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1767876624, 1767876624, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (60, 1, 3, 'core_system_menu_index', '查看', '', '/core/menu/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (61, 1, 3, 'core_system_menu_add', '添加', '', '/core/menu/add', NULL, 'condor.route.add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (62, 1, 3, 'core_system_menu_edit', '编辑', '', '/core/menu/edit', NULL, 'condor.route.edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (63, 1, 3, 'core_system_menu_del', '删除', '', '/core/menu/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (64, 1, 3, 'core_system_menu_multi', '批量操作', '', '/core/menu/multi', NULL, 'condor.route.bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (65, 1, 3, 'core_system_menu_selectpage', '选择列表', '', '/core/menu/selectpage', NULL, 'condor.route.selection_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (66, 1, 4, 'core_system_role_index', '查看', '', '/core/role/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (67, 1, 4, 'core_system_role_add', '添加', '', '/core/role/add', NULL, 'condor.route.add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (68, 1, 4, 'core_system_role_edit', '编辑', '', '/core/role/edit', NULL, 'condor.route.edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (69, 1, 4, 'core_system_role_del', '删除', '', '/core/role/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (70, 1, 4, 'core_system_role_multi', '批量操作', '', '/core/role/multi', NULL, 'condor.route.bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (71, 1, 4, 'core_system_role_selectpage', '选择列表', '', '/core/role/selectpage', NULL, 'condor.route.selection_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (72, 1, 5, 'core_dict-type_index', '类型查看', '', '/core/dict-type/index', NULL, 'condor.route.view_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (73, 1, 5, 'core_dict-type_add', '类型添加', '', '/core/dict-type/add', NULL, 'condor.route.add_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (74, 1, 5, 'core_dict-type_edit', '类型编辑', '', '/core/dict-type/edit', NULL, 'condor.route.edit_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (75, 1, 5, 'core_dict-type_del', '类型删除', '', '/core/dict-type/del', NULL, 'condor.route.delete_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (76, 1, 5, 'core_dict-type_multi', '类型批量操作', '', '/core/dict-type/multi', NULL, 'condor.route.type_bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (77, 1, 5, 'core_dict-type_selectpage', '类型选择列表', '', '/core/dict-type/selectpage', NULL, 'condor.route.select_type_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (78, 1, 5, 'core_dict-data_index', '数据查看', '', '/core/dict-data/index', NULL, 'condor.route.view_data', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (79, 1, 5, 'core_dict-data_add', '数据添加', '', '/core/dict-data/add', NULL, 'condor.route.add_data', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (80, 1, 5, 'core_dict-data_edit', '数据编辑', '', '/core/dict-data/edit', NULL, 'condor.route.edit_data', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (81, 1, 5, 'core_dict-data_del', '数据删除', '', '/core/dict-data/del', NULL, 'condor.route.delete_data', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (82, 1, 5, 'core_dict-data_multi', '数据批量操作', '', '/core/dict-data/multi', NULL, 'condor.route.data_bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (83, 1, 5, 'core_dict-data_selectpage', '数据选择列表', '', '/core/dict-data/selectpage', NULL, 'condor.route.select_data_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (84, 1, 7, 'core_system_admin_index', '查看', '', '/core/admin/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (85, 1, 7, 'core_system_admin_add', '添加', '', '/core/admin/add', NULL, 'condor.route.add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (86, 1, 7, 'core_system_admin_edit', '编辑', '', '/core/admin/edit', NULL, 'condor.route.edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (87, 1, 7, 'core_system_admin_del', '删除', '', '/core/admin/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (88, 1, 7, 'core_system_admin_multi', '批量操作', '', '/core/admin/multi', NULL, 'condor.route.bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (89, 1, 7, 'core_system_admin_selectpage', '选择列表', '', '/core/admin/selectpage', NULL, 'condor.route.selection_list', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (90, 1, 6, 'core_config-group_index', '分组查看', '', '/core/config-group/index', NULL, 'condor.route.group_view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (91, 1, 6, 'core_config-group_add', '分组添加', '', '/core/config-group/add', NULL, 'condor.route.group_add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (92, 1, 6, 'core_config-group_edit', '分组编辑', '', '/core/config-group/edit', NULL, 'condor.route.group_edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (93, 1, 6, 'core_config-group_del', '分组删除', '', '/core/config-group/del', NULL, 'condor.route.group_delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (94, 1, 6, 'core_config-group_multi', '分组批量操作', '', '/core/config-group/multi', NULL, 'condor.route.group_bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (95, 1, 8, 'core_attachment-type_index', '类型查看', '', '/core/attachment-type/index', NULL, 'condor.route.view_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (96, 1, 8, 'core_attachment-type_add', '类型添加', '', '/core/attachment-type/add', NULL, 'condor.route.add_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (97, 1, 8, 'core_attachment-type_edit', '类型编辑', '', '/core/attachment-type/edit', NULL, 'condor.route.edit_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (98, 1, 8, 'core_attachment-type_del', '类型删除', '', '/core/attachment-type/del', NULL, 'condor.route.delete_type', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (99, 1, 8, 'core_attachment-type_multi', '类型批量操作', '', '/core/attachment-type/multi', NULL, 'condor.route.type_bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (100, 1, 8, 'core_attachment_index', '附件查看', '', '/core/attachment/index', NULL, 'condor.route.view_attachment', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (101, 1, 8, 'core_attachment_del', '附件删除', '', '/core/attachment/del', NULL, 'condor.route.delete_attachment', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (102, 1, 8, 'core_attachment_upload', '附件上传', '', '/core/attachment/upload', NULL, 'condor.route.upload_attachment', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (103, 1, 10, 'core_crontab_index', '查看', '', '/core/crontab/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (104, 1, 10, 'core_crontab_add', '添加', '', '/core/crontab/add', NULL, 'condor.route.add', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (105, 1, 10, 'core_crontab_edit', '编辑', '', '/core/crontab/edit', NULL, 'condor.route.edit', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (106, 1, 10, 'core_crontab_del', '删除', '', '/core/crontab/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (107, 1, 10, 'core_crontab_multi', '批量操作', '', '/core/crontab/multi', NULL, 'condor.route.bulk_actions', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (108, 1, 10, 'core_crontab_run-once', '运行一次', '', '/core/crontab/run-once', NULL, 'condor.route.run_once', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (109, 1, 10, 'core_crontab-log_index', '日志查看', '', '/core/crontab-log/index', NULL, 'condor.route.view_logs', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (110, 1, 16, 'core_login-log_del', '删除', '', '/core/login-log/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (111, 1, 16, 'core_login-log_index', '查看', '', '/core/login-log/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (112, 1, 17, 'core_admin-log_del', '删除', '', '/core/admin-log/del', NULL, 'condor.route.delete', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (113, 1, 17, 'core_admin-log_index', '查看', '', '/core/admin-log/index', NULL, 'condor.route.view', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (114, 1, 18, 'core_crud_config', '获取配置', '', '/core/crud/config', NULL, 'condor.route.get_configuration', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (115, 1, 18, 'core_crud_fields', '表字段', '', '/core/crud/fields', NULL, 'condor.route.table_fields', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (116, 1, 18, 'core_crud_create', '创建', '', '/core/crud/create', NULL, 'condor.route.create', '', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1768722453, 1768722453, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (117, 0, 2, 'system_profile', '个人资料', 'material-symbols:account-box', '/system/profile', 'view.system_profile', 'route.system_profile', '', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 1, 1775918850, 1775920215, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (118, NULL, 117, 'core_common_update_profile', '更新资料', NULL, '/core/common/updateProfile', NULL, 'condor.route.update_profile', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1775927114, 1775927245, NULL);
INSERT INTO `con_system_menu_rule` (`id`, `is_keep`, `pid`, `name`, `title`, `icon`, `path`, `component`, `i18nkey`, `remark`, `hidden`, `redirect`, `menu_type`, `href`, `active_menu`, `multi_tab`, `fixed_tab_index`, `query`, `weigh`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (119, NULL, 5, 'core_common_getDict', '获取字典', NULL, '/core/common/getDict', NULL, 'condor.route.get_dict', '', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 1, 1775927413, 1775927413, NULL);
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
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 1, 0, 'superadmin', '', 1, 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 0, 1, 0, 'superadmin', NULL, 1, 1766417865, 1766487550, NULL);
INSERT INTO `con_system_role` (`id`, `is_sys`, `admin_id`, `pid`, `code`, `rules`, `status`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 0, 1, 2, 'test', '1,2,5,72,73,74,75,76,77,78,79,80,81,82,83,6,11,12,13,14,15,26,90,91,92,93,94,8,95,96,97,98,99,100,101,102,10,103,104,105,106,107,108,109,18,114,115,116,9,3,60,61,62,63,64,65,4,66,67,68,69,70,71,7,84,85,86,87,88,89,16,110,111,17,112,113,19,20,21,22,23,24,25', 1, 1766546252, 1775899666, NULL);
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
-- Table structure for con_system_role_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_role_translations`;
CREATE TABLE `con_system_role_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '角色名称',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='角色语言表';

-- ----------------------------
-- Records of con_system_role_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 1, 'zh-cn', '超级管理员', 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 1, 'en-us', 'super admin', 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 2, 'zh-cn', '超级管理员', 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (4, 2, 'en-us', 'super admin', 1762870065, 1762870065, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (5, 3, 'zh-cn', '测试', 1762870065, 1772641255, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (6, 3, 'en-us', 'test', 1762870065, 1772641255, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (7, 3, 'en-us', 'test', 1775899666, 1775899666, NULL);
INSERT INTO `con_system_role_translations` (`id`, `main_id`, `locale`, `name`, `createtime`, `updatetime`, `deleted_at`) VALUES (8, 3, 'zh-cn', '测试', 1775899666, 1775899666, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_test
-- ----------------------------
DROP TABLE IF EXISTS `con_system_test`;
CREATE TABLE `con_system_test` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `price` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '价格',
  `views` int unsigned DEFAULT '0' COMMENT '点击',
  `activitytime` bigint DEFAULT NULL COMMENT '活动时间',
  `refreshtime` bigint DEFAULT NULL COMMENT '刷新时间',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试';

-- ----------------------------
-- Records of con_system_test
-- ----------------------------
BEGIN;
INSERT INTO `con_system_test` (`id`, `price`, `views`, `activitytime`, `refreshtime`, `createtime`, `updatetime`, `deleted_at`) VALUES (1, 5.00, 4, 1772090868000, 1769758065000, 1769930702, 1771002436, 1771002436);
INSERT INTO `con_system_test` (`id`, `price`, `views`, `activitytime`, `refreshtime`, `createtime`, `updatetime`, `deleted_at`) VALUES (2, 3.13, 4, 1770968843000, 1770968844000, 1770971546, 1771002273, NULL);
INSERT INTO `con_system_test` (`id`, `price`, `views`, `activitytime`, `refreshtime`, `createtime`, `updatetime`, `deleted_at`) VALUES (3, 3.13, 4, 1770968843000, 1770968844000, 1770971546, 1771002273, NULL);
COMMIT;

-- ----------------------------
-- Table structure for con_system_test_translations
-- ----------------------------
DROP TABLE IF EXISTS `con_system_test_translations`;
CREATE TABLE `con_system_test_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `main_id` int unsigned NOT NULL DEFAULT '0' COMMENT '主表 ID',
  `locale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '语言',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '目标',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片',
  `images` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片组',
  `attachfile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '附件',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '描述',
  `createtime` bigint DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `locale_main_id` (`main_id`,`locale`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试';

-- ----------------------------
-- Records of con_system_test_translations
-- ----------------------------
BEGIN;
INSERT INTO `con_system_test_translations` (`id`, `main_id`, `locale`, `name`, `target`, `title`, `content`, `image`, `images`, `attachfile`, `keywords`, `description`, `createtime`, `updatetime`) VALUES (5, 2, 'zh-cn', '测试12', '收到老师12', '罗伟12', '<p>奥丝蓝黛减肥了12</p>', '/uploads/20260201/20260201152415_697eff9f2c1db.jpg', '/uploads/20260201/20260201152336_697eff78cdcdd.png', '/uploads/20260201/20260201152346_697eff827d6cf.png', '水电费12', '味道发生的发12', 1771002273, 1771002273);
INSERT INTO `con_system_test_translations` (`id`, `main_id`, `locale`, `name`, `target`, `title`, `content`, `image`, `images`, `attachfile`, `keywords`, `description`, `createtime`, `updatetime`) VALUES (6, 2, 'en-us', 'werwer12', 'sghstwert12', 'ersdgertweg12', '<p>sdfgwertdfg12</p>', '/uploads/20260201/20260201152336_697eff78cdcdd.png', '/uploads/20260201/20260201152346_697eff827d6cf.png', '/uploads/20260201/20260201152415_697eff9f2c1db.jpg', 'ergsdf12', 'ergsdfgsd12', 1771002273, 1771002273);
COMMIT;

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
INSERT INTO `con_system_user` (`id`, `pid`, `vip_id`, `username`, `nickname`, `password`, `email`, `mobile`, `avatar`, `level`, `gender`, `money`, `score`, `invite_code`, `consecutive_login_days`, `logintime`, `loginip`, `loginfailure`, `register_ip`, `createtime`, `updatetime`, `status`, `deleted_at`) VALUES (1, 0, 0, 'test', '', '$2y$10$tKV6FTt9SOSPWDw/ru1i8.yqGVzIpbQp2NqQZybBbuPtuIzcND9cS', '', '', '', 0, 0, 0.0000, 0, 'B64235', 1, NULL, '', 0, '127.0.0.1', 1776501745, 1776501745, 1, NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
