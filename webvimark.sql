/*
Navicat MySQL Data Transfer

Source Server         : LOCAL
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : proyecto

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-10-23 01:16:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for auth_assignment
-- ----------------------------
DROP TABLE IF EXISTS `auth_assignment`;
CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_name`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `auth_assignment_ibfk_1` FOREIGN KEY (`item_name`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `auth_assignment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_assignment
-- ----------------------------

-- ----------------------------
-- Table structure for auth_item
-- ----------------------------
DROP TABLE IF EXISTS `auth_item`;
CREATE TABLE `auth_item` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `rule_name` varchar(64) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `group_code` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `rule_name` (`rule_name`),
  KEY `idx-auth_item-type` (`type`),
  KEY `fk_auth_item_group_code` (`group_code`),
  CONSTRAINT `auth_item_ibfk_1` FOREIGN KEY (`rule_name`) REFERENCES `auth_rule` (`name`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `auth_item_ibfk_2` FOREIGN KEY (`group_code`) REFERENCES `auth_item_group` (`code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_item
-- ----------------------------
INSERT INTO `auth_item` VALUES ('/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//controller', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//crud', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//extension', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//form', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//model', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('//module', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/asset/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/asset/compress', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/asset/template', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/cache/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/cache/flush', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/cache/flush-all', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/cache/flush-schema', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/cache/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/dashboard/*', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/dashboard/create', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/dashboard/delete', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/dashboard/index', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/dashboard/update', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/dashboard/view', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/*', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/default/*', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/default/db-explain', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/debug/default/download-mail', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/default/index', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/debug/default/toolbar', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/debug/default/view', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/debug/user/*', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/user/reset-identity', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/debug/user/set-identity', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/fixture/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/fixture/load', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/fixture/unload', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/action', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/diff', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/preview', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gii/default/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/gridview/*', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/gridview/export/*', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/gridview/export/download', '3', null, null, null, '1510367287', '1510367287', null);
INSERT INTO `auth_item` VALUES ('/hello/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/hello/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/help/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/help/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/message/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/message/config', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/message/extract', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/down', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/history', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/mark', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/new', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/redo', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/to', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/migrate/up', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/site/*', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/about', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/captcha', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/contact', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/dash', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/error', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/index', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/login', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/site/logout', '3', null, null, null, '1510367286', '1510367286', null);
INSERT INTO `auth_item` VALUES ('/user-management/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/bulk-activate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/bulk-deactivate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/bulk-delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/grid-page-size', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/grid-sort', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/toggle-attribute', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/update', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth-item-group/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/captcha', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/change-own-password', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/confirm-email', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/confirm-email-receive', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/confirm-registration-email', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/login', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/logout', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/password-recovery', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/password-recovery-receive', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/auth/registration', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/bulk-activate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/bulk-deactivate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/bulk-delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/grid-page-size', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/grid-sort', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/refresh-routes', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/set-child-permissions', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/set-child-routes', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/toggle-attribute', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/update', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/permission/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/bulk-activate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/bulk-deactivate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/bulk-delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/grid-page-size', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/grid-sort', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/set-child-permissions', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/set-child-roles', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/toggle-attribute', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/update', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/role/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-permission/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-permission/set', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-permission/set-roles', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/bulk-activate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/bulk-deactivate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/bulk-delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/grid-page-size', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/grid-sort', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/toggle-attribute', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/update', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user-visit-log/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/*', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/bulk-activate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/bulk-deactivate', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/bulk-delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/change-password', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/create', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/delete', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/grid-page-size', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/grid-sort', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/index', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/toggle-attribute', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/update', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('/user-management/user/view', '3', null, null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('Admin', '1', 'Admin', null, null, '1426062189', '1426062189', null);
INSERT INTO `auth_item` VALUES ('assignRolesToUsers', '2', 'Assign roles to users', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('bindUserToIp', '2', 'Bind user to IP', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('changeOwnPassword', '2', 'Change own password', null, null, '1426062189', '1426062189', 'userCommonPermissions');
INSERT INTO `auth_item` VALUES ('changeUserPassword', '2', 'Change user password', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('commonPermission', '2', 'Common permission', null, null, '1426062188', '1426062188', null);
INSERT INTO `auth_item` VALUES ('createUsers', '2', 'Create users', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('deleteUsers', '2', 'Delete users', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('editUserEmail', '2', 'Edit user email', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('editUsers', '2', 'Edit users', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('viewRegistrationIp', '2', 'View registration IP', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('viewUserEmail', '2', 'View user email', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('viewUserRoles', '2', 'View user roles', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('viewUsers', '2', 'View users', null, null, '1426062189', '1426062189', 'userManagement');
INSERT INTO `auth_item` VALUES ('viewVisitLog', '2', 'View visit log', null, null, '1426062189', '1426062189', 'userManagement');

-- ----------------------------
-- Table structure for auth_item_child
-- ----------------------------
DROP TABLE IF EXISTS `auth_item_child`;
CREATE TABLE `auth_item_child` (
  `parent` varchar(64) NOT NULL,
  `child` varchar(64) NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`),
  CONSTRAINT `auth_item_child_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `auth_item_child_ibfk_2` FOREIGN KEY (`child`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_item_child
-- ----------------------------
INSERT INTO `auth_item_child` VALUES ('Admin', 'assignRolesToUsers');
INSERT INTO `auth_item_child` VALUES ('Admin', 'changeOwnPassword');
INSERT INTO `auth_item_child` VALUES ('Admin', 'changeUserPassword');
INSERT INTO `auth_item_child` VALUES ('Admin', 'createUsers');
INSERT INTO `auth_item_child` VALUES ('Admin', 'deleteUsers');
INSERT INTO `auth_item_child` VALUES ('Admin', 'editUsers');
INSERT INTO `auth_item_child` VALUES ('Admin', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('assignRolesToUsers', '/user-management/user-permission/set');
INSERT INTO `auth_item_child` VALUES ('assignRolesToUsers', '/user-management/user-permission/set-roles');
INSERT INTO `auth_item_child` VALUES ('assignRolesToUsers', 'viewUserRoles');
INSERT INTO `auth_item_child` VALUES ('assignRolesToUsers', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('changeOwnPassword', '/user-management/auth/change-own-password');
INSERT INTO `auth_item_child` VALUES ('changeUserPassword', '/user-management/user/change-password');
INSERT INTO `auth_item_child` VALUES ('changeUserPassword', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('createUsers', '/user-management/user/create');
INSERT INTO `auth_item_child` VALUES ('createUsers', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('deleteUsers', '/user-management/user/bulk-delete');
INSERT INTO `auth_item_child` VALUES ('deleteUsers', '/user-management/user/delete');
INSERT INTO `auth_item_child` VALUES ('deleteUsers', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('editUserEmail', 'viewUserEmail');
INSERT INTO `auth_item_child` VALUES ('editUsers', '/user-management/user/bulk-activate');
INSERT INTO `auth_item_child` VALUES ('editUsers', '/user-management/user/bulk-deactivate');
INSERT INTO `auth_item_child` VALUES ('editUsers', '/user-management/user/update');
INSERT INTO `auth_item_child` VALUES ('editUsers', 'viewUsers');
INSERT INTO `auth_item_child` VALUES ('viewUsers', '/user-management/user/grid-page-size');
INSERT INTO `auth_item_child` VALUES ('viewUsers', '/user-management/user/index');
INSERT INTO `auth_item_child` VALUES ('viewUsers', '/user-management/user/view');
INSERT INTO `auth_item_child` VALUES ('viewVisitLog', '/user-management/user-visit-log/grid-page-size');
INSERT INTO `auth_item_child` VALUES ('viewVisitLog', '/user-management/user-visit-log/index');
INSERT INTO `auth_item_child` VALUES ('viewVisitLog', '/user-management/user-visit-log/view');

-- ----------------------------
-- Table structure for auth_item_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_item_group`;
CREATE TABLE `auth_item_group` (
  `code` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_item_group
-- ----------------------------
INSERT INTO `auth_item_group` VALUES ('userCommonPermissions', 'User common permission', '1426062189', '1426062189');
INSERT INTO `auth_item_group` VALUES ('userManagement', 'User management', '1426062189', '1426062189');

-- ----------------------------
-- Table structure for auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule` (
  `name` varchar(64) NOT NULL,
  `data` text DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_rule
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `auth_key` varchar(32) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `superadmin` smallint(1) DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `registration_ip` varchar(15) DEFAULT NULL,
  `bind_to_ip` varchar(255) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `email_confirmed` smallint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'superadmin', 'kz2px152FAWlkHbkZoCiXgBAd-S8SSjF', '$2y$13$MhlYe12xkGFnSeK0sO2up.Y9kAD9Ct6JS1i9VLP7YAqd1dFsSylz2', null, '1', '1', '1426062188', '1426062188', null, null, null, '0');

-- ----------------------------
-- Table structure for user_visit_log
-- ----------------------------
DROP TABLE IF EXISTS `user_visit_log`;
CREATE TABLE `user_visit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `language` char(2) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `visit_time` int(11) NOT NULL,
  `browser` varchar(30) DEFAULT NULL,
  `os` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_visit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_visit_log
-- ----------------------------
