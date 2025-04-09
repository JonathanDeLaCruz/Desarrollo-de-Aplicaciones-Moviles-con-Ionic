/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 110102
Source Host           : 127.0.0.1:3306
Source Database       : sws

Target Server Type    : MYSQL
Target Server Version : 110102
File Encoding         : 65001

Date: 2025-04-09 10:35:27
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for permiso
-- ----------------------------
DROP TABLE IF EXISTS `permiso`;
CREATE TABLE `permiso` (
  `per_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `per_vista` varchar(100) NOT NULL COMMENT 'Nombre de la vista',
  `per_rol` varchar(150) NOT NULL COMMENT 'Roles permitidos',
  PRIMARY KEY (`per_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of permiso
-- ----------------------------
INSERT INTO `permiso` VALUES ('1', 'tab1', 'cliente');
INSERT INTO `permiso` VALUES ('2', 'tab2/:matricul', 'cliente,Admin');
INSERT INTO `permiso` VALUES ('3', 'tab3', 'Admin');
INSERT INTO `permiso` VALUES ('4', 'tab4', 'vendedor');
