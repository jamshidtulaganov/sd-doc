-- MySQL dump 10.13  Distrib 8.0.45, for Linux (aarch64)
--
-- Host: localhost    Database: sd_main
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authassignment`
--

DROP TABLE IF EXISTS `authassignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authassignment` (
  `itemname` varchar(64) NOT NULL,
  `userid` varchar(64) NOT NULL,
  `bizrule` text,
  `data` text,
  `filial_id` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`itemname`,`userid`,`filial_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authitem`
--

DROP TABLE IF EXISTS `authitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authitem` (
  `name` varchar(64) NOT NULL,
  `type` int NOT NULL,
  `description` text,
  `bizrule` text,
  `data` text,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authitemchild`
--

DROP TABLE IF EXISTS `authitemchild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authitemchild` (
  `parent` varchar(64) NOT NULL,
  `child` varchar(64) NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_audit`
--

DROP TABLE IF EXISTS `d0_adt_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_audit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `REQUIRED` tinyint NOT NULL DEFAULT '0' COMMENT '0-no required, 1-required',
  `FACE_CHECK` varchar(1) NOT NULL,
  `PRICE_CHECK` varchar(1) NOT NULL,
  `SOLD_CHECK` varchar(1) NOT NULL,
  `STORE_CHECK` varchar(1) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL,
  `IS_PUBLIC` tinyint NOT NULL DEFAULT '1',
  `SHOW_ON_STORECHECK` varchar(1) NOT NULL DEFAULT 'Y',
  `POLL_ID` int DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `FACE_REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  `STORE_REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  `SOLD_REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  `PRICE_REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_audit_bind_products`
--

DROP TABLE IF EXISTS `d0_adt_audit_bind_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_audit_bind_products` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AUDIT_ID` int NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AUDIT_ID` (`AUDIT_ID`),
  KEY `PRODUCT_ID` (`PRODUCT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1937 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_audit_bind_users`
--

DROP TABLE IF EXISTS `d0_adt_audit_bind_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_audit_bind_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AUDIT_ID` int NOT NULL,
  `AUDITOR_ID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AUDIT_ID` (`AUDIT_ID`),
  KEY `AUDITOR_ID` (`AUDITOR_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_audit_result`
--

DROP TABLE IF EXISTS `d0_adt_audit_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_audit_result` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISIT_ID` int NOT NULL,
  `FILIAL_ID` int DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `POSITION_ID` int NOT NULL,
  `AUDIT_ID` int NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `TOKEN` varchar(124) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_audit_result_data`
--

DROP TABLE IF EXISTS `d0_adt_audit_result_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_audit_result_data` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `RESULT_ID` int NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `PRICE` decimal(12,2) DEFAULT NULL,
  `FACE` decimal(12,2) DEFAULT NULL,
  `SOLD` decimal(12,2) DEFAULT NULL,
  `STORE` decimal(12,2) DEFAULT NULL,
  `AVAILABLE` tinyint NOT NULL,
  `OUT_OF_STOCK` int NOT NULL DEFAULT '0',
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `RESULT_ID` (`RESULT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10360 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_brand`
--

DROP TABLE IF EXISTS `d0_adt_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_brand` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `XML_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_comment`
--

DROP TABLE IF EXISTS `d0_adt_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_comment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_comment_result`
--

DROP TABLE IF EXISTS `d0_adt_comment_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_comment_result` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISIT_ID` int NOT NULL,
  `FILIAL_ID` int DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `POSITION_ID` int NOT NULL,
  `COMMENT_ID` int NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `COMMENT_ID` (`COMMENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_config`
--

DROP TABLE IF EXISTS `d0_adt_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_config` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER` varchar(50) NOT NULL,
  `TYPE` varchar(50) NOT NULL DEFAULT 'audit',
  `CONFIG` varchar(50) NOT NULL,
  `GROUP` varchar(50) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  `FILIAL` int DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=677 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_note_result`
--

DROP TABLE IF EXISTS `d0_adt_note_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_note_result` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISIT_ID` int NOT NULL,
  `FILIAL_ID` int DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `POSITION_ID` int NOT NULL,
  `NOTE` varchar(500) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_pack`
--

DROP TABLE IF EXISTS `d0_adt_pack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_pack` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_params`
--

DROP TABLE IF EXISTS `d0_adt_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_params` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PROPERTY1` varchar(255) DEFAULT NULL,
  `PROPERTY2` varchar(255) DEFAULT NULL,
  `PARAM1` varchar(255) DEFAULT NULL,
  `PARAM2` varchar(255) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll`
--

DROP TABLE IF EXISTS `d0_adt_poll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TEXT` varchar(255) NOT NULL,
  `DESCRIPTION` text,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `REQUIRED` tinyint NOT NULL DEFAULT '0' COMMENT '0-no required, 1-required',
  `SHOW_ON_REPORT` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `SORT` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll_bind`
--

DROP TABLE IF EXISTS `d0_adt_poll_bind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll_bind` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int DEFAULT NULL,
  `POLL_ID` int NOT NULL,
  `AUDITOR_ID` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `AUDITOR_ID` (`AUDITOR_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll_question`
--

DROP TABLE IF EXISTS `d0_adt_poll_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll_question` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `POLL_ID` int NOT NULL,
  `TEXT` varchar(500) NOT NULL,
  `TYPE` int NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `DESCRIPTION` text,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `IS_REQUIRED` tinyint NOT NULL DEFAULT '0',
  `SYSTEMNAME` varchar(100) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll_result`
--

DROP TABLE IF EXISTS `d0_adt_poll_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll_result` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISIT_ID` int NOT NULL,
  `DATE` datetime NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `POSITION_ID` int NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `FILIAL_ID` int DEFAULT NULL,
  `POLL_ID` int NOT NULL,
  `TOKEN` varchar(124) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll_result_data`
--

DROP TABLE IF EXISTS `d0_adt_poll_result_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll_result_data` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `RESULT_ID` int NOT NULL,
  `QUESTION_ID` int NOT NULL,
  `VARIANT_ID` int DEFAULT NULL,
  `VALUE` varchar(250) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `RESULT_ID` (`RESULT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_poll_variant`
--

DROP TABLE IF EXISTS `d0_adt_poll_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_poll_variant` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TEXT` varchar(500) NOT NULL,
  `QUES_ID` int NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `IS_OUR` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_producer`
--

DROP TABLE IF EXISTS `d0_adt_producer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_producer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `COUNTRY` varchar(255) NOT NULL DEFAULT '',
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_property`
--

DROP TABLE IF EXISTS `d0_adt_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_property` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_property1`
--

DROP TABLE IF EXISTS `d0_adt_property1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_property1` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_property2`
--

DROP TABLE IF EXISTS `d0_adt_property2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_property2` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_reports`
--

DROP TABLE IF EXISTS `d0_adt_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_reports` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CODE` varchar(100) NOT NULL,
  `VISIBLE` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_segment`
--

DROP TABLE IF EXISTS `d0_adt_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_segment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_adt_unit`
--

DROP TABLE IF EXISTS `d0_adt_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_adt_unit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(100) NOT NULL,
  `SHORT` varchar(50) NOT NULL,
  `CODE` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_afacing`
--

DROP TABLE IF EXISTS `d0_afacing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_afacing` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_agent`
--

DROP TABLE IF EXISTS `d0_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_agent` (
  `AGENT_ID` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FIO` varchar(200) NOT NULL,
  `TEL` varchar(20) NOT NULL,
  `PASSPORT_COPY` varchar(255) NOT NULL,
  `DATE_BIRTH` date NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `PHOTO` varchar(255) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `VAN_SELLING` tinyint NOT NULL DEFAULT '0' COMMENT '1-van-selling, 0-not van selling',
  `AUDIT` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `FILTER` char(1) NOT NULL DEFAULT '1',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `PAY_CONFIRM` int NOT NULL DEFAULT '0',
  `CASHBOX` int NOT NULL,
  `FIRST_VISIT` date DEFAULT NULL,
  `APP_VERSION` varchar(20) DEFAULT NULL,
  `DEVICE_MODEL` varchar(100) DEFAULT NULL,
  `LAST_SYNC_TIME` datetime DEFAULT NULL,
  `IP_ADDRESS` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`AGENT_ID`),
  KEY `ID` (`ID`),
  KEY `XML_ID` (`XML_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_agent_paket`
--

DROP TABLE IF EXISTS `d0_agent_paket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_agent_paket` (
  `AGENT_PAKET_ID` varchar(60) NOT NULL,
  `AGENT_ID` varchar(200) NOT NULL,
  `PRODUCT_ID` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CITY_ID` varchar(10000) NOT NULL,
  `PRICE_TYPE` varchar(1000) NOT NULL,
  `VS_PRICE_TYPE` text,
  `CONTROLL_TYPE` varchar(60) NOT NULL DEFAULT '',
  `SETTINGS` text NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`AGENT_PAKET_ID`),
  KEY `ID` (`ID`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_agent_plan`
--

DROP TABLE IF EXISTS `d0_agent_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_agent_plan` (
  `AGENT_PLAN_ID` varchar(200) NOT NULL,
  `AGENT_ID` varchar(200) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `TYPE` varchar(200) NOT NULL,
  `PLAN` int NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `USER_ID` varchar(200) NOT NULL,
  `DILER_ID` varchar(200) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AGENT_PLAN_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_agent_settings`
--

DROP TABLE IF EXISTS `d0_agent_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_agent_settings` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `SETTINGS` text NOT NULL,
  `CREATE_BY` varchar(60) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_akb_category`
--

DROP TABLE IF EXISTS `d0_akb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_akb_category` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `FILTER_ID` int NOT NULL,
  `SORT` int DEFAULT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FILTER_ID` (`FILTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_akb_category_product`
--

DROP TABLE IF EXISTS `d0_akb_category_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_akb_category_product` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CATEGORY_ID` int NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CATEGORY_ID` (`CATEGORY_ID`),
  KEY `PRODUCT_ID` (`PRODUCT_ID`),
  KEY `CAT_PROD` (`ID`,`CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_akb_filter`
--

DROP TABLE IF EXISTS `d0_akb_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_akb_filter` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_apelsin_transaction`
--

DROP TABLE IF EXISTS `d0_apelsin_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_apelsin_transaction` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(200) NOT NULL,
  `TRANS_ID` bigint NOT NULL,
  `TRANS_TYPE` varchar(200) NOT NULL DEFAULT 'pay',
  `AMOUNT` double(16,2) NOT NULL,
  `PAYMENT_ID` varchar(200) DEFAULT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aproduct`
--

DROP TABLE IF EXISTS `d0_aproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aproduct` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_asku`
--

DROP TABLE IF EXISTS `d0_asku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_asku` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_brands`
--

DROP TABLE IF EXISTS `d0_aud_brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_brands` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(500) NOT NULL,
  `SORT` int NOT NULL,
  `OWNER` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `TIME` int unsigned NOT NULL,
  `SYNC` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_category`
--

DROP TABLE IF EXISTS `d0_aud_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_category` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PRODUCT_CAT_ID` varchar(500) NOT NULL,
  `SORT` int NOT NULL,
  `NAME` varchar(1000) NOT NULL,
  `BRAND` int NOT NULL,
  `MIN` int NOT NULL,
  `MAX` int NOT NULL,
  `PARENT` int NOT NULL,
  `FACING_CHECK` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `TIME` int unsigned NOT NULL,
  `SYNC` char(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `BRAND` (`BRAND`),
  KEY `PARENT` (`PARENT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_facing`
--

DROP TABLE IF EXISTS `d0_aud_facing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_facing` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `BRAND_ID` int NOT NULL,
  `PARENT_CAT_ID` int unsigned NOT NULL,
  `CAT_ID` int NOT NULL,
  `PLACE_ID` int NOT NULL,
  `COUNT` float NOT NULL,
  `DATE` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `CITY_ID` (`CITY_ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `BRAND_ID` (`BRAND_ID`),
  KEY `CAT_ID` (`CAT_ID`),
  KEY `DATE` (`DATE`),
  KEY `CLIENT_CAT` (`CLIENT_CAT`),
  KEY `PARENT_CAT_ID` (`PARENT_CAT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_place_type`
--

DROP TABLE IF EXISTS `d0_aud_place_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_place_type` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` varchar(255) NOT NULL,
  `TIME` int unsigned NOT NULL,
  `SYNC` char(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_product`
--

DROP TABLE IF EXISTS `d0_aud_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_product` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(1000) NOT NULL,
  `AUD_CAT_ID` int unsigned NOT NULL,
  `PRODUCT_ID` varchar(255) NOT NULL,
  `PRODUCT_CAT_ID` varchar(255) NOT NULL,
  `BRAND_ID` int unsigned NOT NULL,
  `SORT` int NOT NULL,
  `OWNER` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `TIME` int unsigned NOT NULL,
  `SYNC` char(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AUD_CAT_ID` (`AUD_CAT_ID`),
  KEY `BRAND_ID` (`BRAND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_aud_sku`
--

DROP TABLE IF EXISTS `d0_aud_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_aud_sku` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `BRAND_ID` int NOT NULL,
  `PARENT_CAT_ID` int NOT NULL,
  `CAT_ID` int NOT NULL,
  `PRODUCT_ID` int NOT NULL,
  `PRICE` float(12,2) NOT NULL,
  `DATE` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `CITY_ID` (`CITY_ID`),
  KEY `CLIENT_CAT` (`CLIENT_CAT`),
  KEY `USER_ID` (`USER_ID`),
  KEY `BRAND_ID` (`BRAND_ID`),
  KEY `PARENT_CAT_ID` (`PARENT_CAT_ID`),
  KEY `CAT_ID` (`CAT_ID`),
  KEY `DATE` (`DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_audit_storchek_cat`
--

DROP TABLE IF EXISTS `d0_audit_storchek_cat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_audit_storchek_cat` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CAT_ID` varchar(60) NOT NULL,
  `TOTAL_INDEX` float(8,2) NOT NULL,
  `MML_PRODUCT` text NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_auditor`
--

DROP TABLE IF EXISTS `d0_auditor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_auditor` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `FIO` varchar(200) NOT NULL,
  `TEL` varchar(20) NOT NULL,
  `PASSPORT_COPY` varchar(255) NOT NULL,
  `DATE_BIRTH` date NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `PHOTO` varchar(255) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus`
--

DROP TABLE IF EXISTS `d0_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus` (
  `BONUS_ID` varchar(50) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `BONUS_TYPE` int NOT NULL,
  `MANUAL` char(1) NOT NULL DEFAULT '0',
  `PRODUCT` varchar(10000) NOT NULL,
  `CLIENT_CAT` varchar(500) NOT NULL,
  `CURRENCY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CLIENT_TYPE` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_CHANNEL` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIN_COUNT` decimal(12,1) NOT NULL,
  `MAX_COUNT` decimal(12,3) NOT NULL DEFAULT '0.000',
  `VALUE` decimal(12,1) NOT NULL,
  `BONUS` decimal(12,1) NOT NULL,
  `BONUS_PRODUCTS` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGENT_ID` varchar(500) NOT NULL,
  `CITY` varchar(500) NOT NULL,
  `PRICE_TYPE` varchar(500) NOT NULL,
  `IS_PUBLIC` varchar(50) NOT NULL,
  `ONLY_ONE_TIME` tinyint NOT NULL DEFAULT '0' COMMENT '1-Yes, 0-No',
  `PARENT` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(20) NOT NULL,
  `SYNC` varchar(20) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` varchar(50) NOT NULL,
  `MAX_BONUS` decimal(10,2) NOT NULL,
  `IN_BLOCK` tinyint NOT NULL DEFAULT '0',
  `BOGO` int DEFAULT '0',
  PRIMARY KEY (`BONUS_ID`),
  KEY `ID` (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=486 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_agent`
--

DROP TABLE IF EXISTS `d0_bonus_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_agent` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BONUS_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `BONUS_ID` (`BONUS_ID`,`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_city`
--

DROP TABLE IF EXISTS `d0_bonus_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_city` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BONUS_ID` varchar(50) NOT NULL,
  `CITY_ID` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `BONUS_ID` (`BONUS_ID`,`CITY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_exclude`
--

DROP TABLE IF EXISTS `d0_bonus_exclude`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_exclude` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PARENT_ID` varchar(32) NOT NULL,
  `EXCLUDED_BONUS_ID` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(32) NOT NULL,
  `UPDATE_BY` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `parentId` (`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_filial`
--

DROP TABLE IF EXISTS `d0_bonus_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BONUS_ID` varchar(50) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_limit`
--

DROP TABLE IF EXISTS `d0_bonus_limit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_limit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BONUS_PARENT` varchar(50) NOT NULL,
  `COUNT` decimal(20,2) NOT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `BONUS_PARENT` (`BONUS_PARENT`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_order`
--

DROP TABLE IF EXISTS `d0_bonus_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_order` (
  `BONUS_ORDER_ID` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `CLIENT_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `COUNT` float NOT NULL,
  `VOLUME` float NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DATE_LOAD` datetime NOT NULL,
  `STATUS` int NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `COMMENT` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  PRIMARY KEY (`BONUS_ORDER_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `STATUS` (`STATUS`),
  KEY `DATE_LOAD` (`DATE_LOAD`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1719 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_order_detail`
--

DROP TABLE IF EXISTS `d0_bonus_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_order_detail` (
  `BONUS_ORDER_DET_ID` varchar(50) NOT NULL,
  `BONUS_ORDER_ID` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `BONUS_ID` varchar(255) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `VOLUME` float NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`BONUS_ORDER_DET_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `BONUS_ORDER_ID` (`BONUS_ORDER_ID`),
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `PRODUCT_CAT` (`PRODUCT_CAT`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `PRODUCT` (`PRODUCT`),
  KEY `ix_bonus_order_detail_oid_prod` (`ORDER_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=8975 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_order_history`
--

DROP TABLE IF EXISTS `d0_bonus_order_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_order_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(50) NOT NULL,
  `BONUS_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `COUNT` float NOT NULL,
  `ACTION` text NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `TIME` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13681 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_bonus_relation`
--

DROP TABLE IF EXISTS `d0_bonus_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_bonus_relation` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PARENT_ID` varchar(32) NOT NULL,
  `RELATED_BONUS_ID` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(32) NOT NULL,
  `UPDATE_BY` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `parentId` (`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_brand`
--

DROP TABLE IF EXISTS `d0_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_cache`
--

DROP TABLE IF EXISTS `d0_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_cache` (
  `MODELS` varchar(250) NOT NULL,
  `CACHE_KEY` varchar(2000) NOT NULL,
  `RESULT` longtext NOT NULL,
  `TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `TOKEN` varchar(500) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CACHE_KEY` (`CACHE_KEY`(255)),
  KEY `MODELS` (`MODELS`),
  KEY `TOKEN` (`TOKEN`(255))
) ENGINE=InnoDB AUTO_INCREMENT=3721 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_cars`
--

DROP TABLE IF EXISTS `d0_cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_cars` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(1000) DEFAULT NULL,
  `MODEL` varchar(1000) DEFAULT NULL COMMENT 'manufacturer',
  `COLOR` varchar(50) DEFAULT NULL,
  `YEAR` year DEFAULT NULL COMMENT 'year of manufacture',
  `TYPE` varchar(50) DEFAULT NULL COMMENT 'car bodies type',
  `LOAD_CAPACITY` int DEFAULT NULL COMMENT 'kg',
  `WIDTH` int DEFAULT NULL COMMENT 'cm',
  `HEIGHT` int DEFAULT NULL COMMENT 'cm',
  `LENGHT` int DEFAULT NULL COMMENT 'cm',
  `PLATE_NUMBER` varchar(50) DEFAULT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `INFO` text,
  `USER_ID` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_cashbox`
--

DROP TABLE IF EXISTS `d0_cashbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_cashbox` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `KASSIR` varchar(50) DEFAULT NULL,
  `CS_ID` text,
  `SORT` int NOT NULL DEFAULT '500',
  `XML_ID` varchar(48) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_cashbox_displacement`
--

DROP TABLE IF EXISTS `d0_cashbox_displacement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_cashbox_displacement` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CB_FROM` int NOT NULL COMMENT 'Cashbox From',
  `CB_TO` int NOT NULL COMMENT 'Cashbox To',
  `CURRENCY` varchar(50) NOT NULL,
  `TO_CURRENCY` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL COMMENT 'Transfer sum',
  `RATE` decimal(10,2) NOT NULL COMMENT 'currency exchange rate',
  `CO_SUMMA` decimal(12,3) NOT NULL,
  `STATUS` tinyint NOT NULL DEFAULT '1' COMMENT 'cancel/done',
  `COMMENT` text NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_catalog_product`
--

DROP TABLE IF EXISTS `d0_catalog_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_catalog_product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `description` text,
  `photo_ext` varchar(10) DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `sort` int DEFAULT '500',
  `PACK_QUANTITY` float DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `SELL_IN_BLOCKS` char(1) DEFAULT 'N',
  `MIN_SALES` int DEFAULT NULL,
  `MAX_SALES` int DEFAULT NULL,
  `TG_BOT_ID` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2516 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_catalog_product_bind`
--

DROP TABLE IF EXISTS `d0_catalog_product_bind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_catalog_product_bind` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bot_product_id` int DEFAULT NULL,
  `product_id` varchar(60) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `TG_BOT_ID` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2888 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_catalog_section`
--

DROP TABLE IF EXISTS `d0_catalog_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_catalog_section` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sort` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `photo_ext` varchar(10) DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `emoji` varchar(100) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `TG_BOT_ID` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_catalog_state`
--

DROP TABLE IF EXISTS `d0_catalog_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_catalog_state` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `basket` text,
  `lang` varchar(4) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `username` varchar(40) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `TG_BOT_ID` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_cises_info`
--

DROP TABLE IF EXISTS `d0_cises_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_cises_info` (
  `CIS` varchar(31) NOT NULL,
  `GTIN` char(14) NOT NULL DEFAULT '',
  `QUANTITY` int NOT NULL DEFAULT '0',
  `PRODUCT_GROUP_ID` tinyint NOT NULL,
  `PACKAGE_TYPE` tinyint NOT NULL,
  `EMISSION_TYPE` tinyint NOT NULL,
  `STATUS` tinyint NOT NULL,
  `OWNER_INN` varchar(14) NOT NULL,
  `PARENT` varchar(31) NOT NULL DEFAULT '',
  `CHILD` text NOT NULL,
  `ORDER_ID` varchar(30) NOT NULL DEFAULT '',
  `TIMESTAMP_X` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CIS`),
  KEY `idx_order_id` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_city`
--

DROP TABLE IF EXISTS `d0_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_city` (
  `CITY_ID` varchar(60) NOT NULL,
  `REGION_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `NAME` varchar(500) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `FILTER` tinyint(1) NOT NULL DEFAULT '1',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `LAT` float NOT NULL DEFAULT '0',
  `LON` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`CITY_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_click_transaction`
--

DROP TABLE IF EXISTS `d0_click_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_click_transaction` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TRANS_ID` bigint NOT NULL,
  `PAYDOC_ID` bigint NOT NULL,
  `AMOUNT` decimal(16,2) NOT NULL,
  `STATUS` tinyint NOT NULL,
  `PAYMENT_ID` varchar(200) DEFAULT NULL,
  `ORDER_ID` int NOT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TRANS_ID` (`TRANS_ID`),
  KEY `ORDER_ID` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client`
--

DROP TABLE IF EXISTS `d0_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client` (
  `CLIENT_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `TEL` varchar(200) NOT NULL,
  `FIRM_NAME` varchar(255) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `ADRESS` varchar(255) NOT NULL,
  `CLIENT_CAT` varchar(255) NOT NULL,
  `ORIENT` varchar(255) NOT NULL,
  `REGION` varchar(30) NOT NULL,
  `CITY` varchar(60) NOT NULL,
  `CONTACT_PERSON` varchar(255) NOT NULL,
  `FORM_SOB` varchar(255) NOT NULL,
  `BALANS` decimal(16,2) NOT NULL,
  `PRICE_TYPE_ID` varchar(250) NOT NULL,
  `BONUS_ID` varchar(50) NOT NULL,
  `DISCOUNT_ID` varchar(50) NOT NULL,
  `ROYALTY_ID` varchar(50) NOT NULL,
  `DATE_EXP` datetime NOT NULL,
  `LON` decimal(9,6) DEFAULT NULL,
  `LAT` decimal(9,6) DEFAULT NULL,
  `ALLOW_CONSIG` int NOT NULL DEFAULT '1',
  `ALLOW_KREDIT` int NOT NULL DEFAULT '1',
  `COMMENT` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `AUDIT_ID` varchar(100) DEFAULT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SORT` int NOT NULL DEFAULT '500',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `BAR_CODE` varchar(40) NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `PHOTO` varchar(255) NOT NULL,
  `ACCOUNT` varchar(100) NOT NULL,
  `BANK` varchar(250) NOT NULL,
  `MFO` varchar(50) NOT NULL,
  `OKED` varchar(50) NOT NULL,
  `CODE_NDS` varchar(50) NOT NULL,
  `NSP_CODE` varchar(50) NOT NULL DEFAULT '50',
  `PINFL` varchar(127) NOT NULL,
  `CONTRACT` varchar(500) NOT NULL,
  `CONTRACT_DATE` date DEFAULT NULL,
  `CHANNEL` int DEFAULT NULL,
  `CLASS` int DEFAULT NULL,
  `NEED_TO_AUDIT` varchar(1) NOT NULL DEFAULT 'N',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TYPE` int NOT NULL,
  `SALES_CAT` varchar(500) NOT NULL,
  `CONTRAGENT` varchar(50) NOT NULL,
  `CODE_2` varchar(255) DEFAULT NULL,
  `TGIS_ID` varchar(30) DEFAULT NULL,
  `CONFIRMED_BY` varchar(50) DEFAULT NULL,
  `CONFIRMED_AT` datetime DEFAULT NULL,
  `DELETED_DUPLICATES` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CLIENT_ID`),
  KEY `ID` (`ID`),
  KEY `CITY` (`CITY`),
  KEY `XML_ID` (`XML_ID`),
  KEY `CLIENT_CAT` (`CLIENT_CAT`),
  KEY `DATE_EXP` (`DATE_EXP`),
  KEY `ACTIVE` (`ACTIVE`)
) ENGINE=InnoDB AUTO_INCREMENT=18202 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_active_log`
--

DROP TABLE IF EXISTS `d0_client_active_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_active_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `OLD_VALUE` varchar(1) NOT NULL,
  `NEW_VALUE` varchar(1) NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=15622 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_category`
--

DROP TABLE IF EXISTS `d0_client_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_category` (
  `CLIENT_CAT_ID` varchar(60) NOT NULL,
  `NAME` varchar(500) NOT NULL,
  `DESCRIPTION` varchar(500) NOT NULL,
  `TIMESTAMP_X` int NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `COLOR` varchar(20) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SORT` int NOT NULL DEFAULT '500',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`CLIENT_CAT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_channel`
--

DROP TABLE IF EXISTS `d0_client_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_channel` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `XML_ID` varchar(255) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_class`
--

DROP TABLE IF EXISTS `d0_client_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_class` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL,
  `SORT` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_finans`
--

DROP TABLE IF EXISTS `d0_client_finans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_finans` (
  `CLIENT_FIN_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `BALANS` decimal(16,2) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  `TYPE` varchar(10) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `UNDISTRIBUTED_SUMMA` decimal(20,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`CLIENT_FIN_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=880 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_firm`
--

DROP TABLE IF EXISTS `d0_client_firm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_firm` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) DEFAULT NULL,
  `NAME` text,
  `FIRM_NAME` text,
  `ADDRESS` varchar(100) DEFAULT NULL,
  `TEL` varchar(200) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  `BANK` varchar(50) DEFAULT NULL,
  `OKED` varchar(50) DEFAULT NULL,
  `CONTRACT` varchar(500) DEFAULT NULL,
  `MFO` varchar(50) DEFAULT NULL,
  `PINFL` varchar(50) DEFAULT NULL,
  `FORM_SOB` varchar(255) DEFAULT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_kaspi_transaction`
--

DROP TABLE IF EXISTS `d0_client_kaspi_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_kaspi_transaction` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `KASPI_TRANS_ID` varchar(18) NOT NULL,
  `AMOUNT` decimal(20,4) NOT NULL,
  `ACCOUNT_TYPE` varchar(30) NOT NULL,
  `ORDER_ID` varchar(16) NOT NULL,
  `TRANS_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `CREATE_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `REQUEST_BODY` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_log`
--

DROP TABLE IF EXISTS `d0_client_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `FIELD` varchar(50) NOT NULL,
  `OLD_VALUE` text NOT NULL,
  `NEW_VALUE` text NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_date` (`UPDATED_AT`)
) ENGINE=InnoDB AUTO_INCREMENT=563836 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_odengi_transaction`
--

DROP TABLE IF EXISTS `d0_client_odengi_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_odengi_transaction` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `ODENGI_TRANS_ID` varchar(16) NOT NULL,
  `STATUS_PAY` int NOT NULL,
  `AMOUNT` decimal(20,4) NOT NULL,
  `SITE_ID` varchar(16) NOT NULL,
  `ORDER_ID` varchar(16) NOT NULL,
  `CURRENCY` varchar(6) NOT NULL,
  `MKTIME` bigint NOT NULL,
  `ACCOUNT_ID` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_optima_transaction`
--

DROP TABLE IF EXISTS `d0_client_optima_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_optima_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_paket`
--

DROP TABLE IF EXISTS `d0_client_paket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_paket` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(200) NOT NULL,
  `SETTINGS` text NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_AT` datetime NOT NULL,
  `UPDATED_BY` varchar(200) DEFAULT NULL,
  `CREATED_BY` varchar(200) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=694 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_payme_transactions`
--

DROP TABLE IF EXISTS `d0_client_payme_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_payme_transactions` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PAYME_TRANSACTION_ID` varchar(25) NOT NULL,
  `PAYME_CREATE_TIME` bigint DEFAULT NULL,
  `PAYME_PAY_TIME` bigint DEFAULT NULL,
  `PAYME_CANCEL_TIME` bigint DEFAULT NULL,
  `PAYME_STATE` tinyint DEFAULT NULL,
  `PAYME_TYPE` tinyint DEFAULT NULL,
  `AMOUNT` int DEFAULT NULL,
  `MERCHANT_ID` char(24) DEFAULT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `FISCAL_DATA` text,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PAYME_TRANSACTION_ID` (`PAYME_TRANSACTION_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_pending`
--

DROP TABLE IF EXISTS `d0_client_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_pending` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TEL` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_CAT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIENT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REGION` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_PERSON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_SOB` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LON` float DEFAULT NULL,
  `LAT` float DEFAULT NULL,
  `COMMENT` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `TIMESTAMP_X` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `XML_ID` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BAR_CODE` varchar(40) DEFAULT NULL,
  `PHOTO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCOUNT` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BANK` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MFO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OKED` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CODE_NDS` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NSP_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '50',
  `PINFL` varchar(127) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTRACT` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANNEL` int DEFAULT NULL,
  `CREATE_BY` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `TYPE` int DEFAULT NULL,
  `SALES_CAT` text,
  `WEEK_TYPE` int DEFAULT NULL,
  `WEEK_POSITION` int DEFAULT NULL,
  `WEEK_DAYS` varchar(50) DEFAULT NULL,
  `CONTRACT_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_client_pending_create_by` (`CREATE_BY`),
  KEY `idx_client_pending_timestamp` (`TIMESTAMP_X`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_phones`
--

DROP TABLE IF EXISTS `d0_client_phones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_phones` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(200) NOT NULL,
  `PHONE` varchar(100) NOT NULL,
  `UPDATE_AT` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_AT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `UPDATE_BY` varchar(200) DEFAULT NULL,
  `CREATE_BY` varchar(200) NOT NULL,
  `TG_CHAT_ID` bigint DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `add_clientid_to_client_phone` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=801 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_photo`
--

DROP TABLE IF EXISTS `d0_client_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_photo` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(20) NOT NULL,
  `URL` varchar(500) NOT NULL,
  `SORT` int DEFAULT NULL,
  `MAIN` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=573 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_stock`
--

DROP TABLE IF EXISTS `d0_client_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_stock` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `USER_ID` varchar(60) NOT NULL,
  `COUNT` float(12,3) NOT NULL,
  `SALE` decimal(12,3) NOT NULL DEFAULT '0.000',
  `DATE` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `CREATE_BY` varchar(60) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=672 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_transaction`
--

DROP TABLE IF EXISTS `d0_client_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_transaction` (
  `CLIENT_TRANS_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `SALE_POINT` varchar(50) DEFAULT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `IDEN` varchar(60) NOT NULL,
  `TRANS_TYPE` tinyint NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_EXP` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TYPE` int NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  `CURRENCY_RATE` decimal(12,4) NOT NULL,
  `CONVERTATION` decimal(12,4) NOT NULL,
  `COMISSION` decimal(12,4) NOT NULL,
  `STATUS` varchar(50) NOT NULL,
  `COMPUTATION` decimal(12,2) NOT NULL,
  `HISTORY` text NOT NULL,
  `CASHBOX` int NOT NULL,
  `DATE_CLOSE` datetime NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  `XML_ID` varchar(255) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `OFD_ID` varchar(500) NOT NULL,
  `CONFIRM_ID` int NOT NULL DEFAULT '0',
  `CONFIRM_USER` int NOT NULL DEFAULT '0',
  `USD_RATE` decimal(16,2) DEFAULT NULL,
  `FIRM_ID` int DEFAULT NULL,
  `ONLINE_PAYMENT_ID` int DEFAULT NULL,
  PRIMARY KEY (`CLIENT_TRANS_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `IDEN` (`IDEN`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7746 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_transaction_history`
--

DROP TABLE IF EXISTS `d0_client_transaction_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_transaction_history` (
  `TRANS_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `TYPE` int NOT NULL,
  `IDEN` varchar(50) NOT NULL,
  `TRANS_TYPE` varchar(50) NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_EXP` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `CONVERTATION` decimal(12,0) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `CASHBOX` int NOT NULL,
  `TRADE_ID` varchar(20) NOT NULL,
  `DATE_CLOSE` datetime NOT NULL,
  `OFD_ID` int NOT NULL,
  `CONFIRM_ID` int NOT NULL,
  `CONFIRM_USER` int NOT NULL,
  `OLD_TRANS_ID` varchar(60) NOT NULL,
  PRIMARY KEY (`TRANS_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_client_type`
--

DROP TABLE IF EXISTS `d0_client_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_client_type` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(500) NOT NULL,
  `COLOR` varchar(20) DEFAULT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_closed`
--

DROP TABLE IF EXISTS `d0_closed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_closed` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL` varchar(200) NOT NULL,
  `DATE` datetime NOT NULL,
  `DAY` int NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `ROLES` varchar(50) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_config`
--

DROP TABLE IF EXISTS `d0_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_config` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) DEFAULT NULL,
  `CATEGORY` varchar(255) DEFAULT NULL,
  `PARAM` varchar(255) NOT NULL,
  `VALUE` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PARAM` (`PARAM`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_consumption`
--

DROP TABLE IF EXISTS `d0_consumption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_consumption` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CAT_PARENT` int NOT NULL,
  `CAT_CHILD` int NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `COMMENT` text NOT NULL,
  `DATE` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `MODIF_BY` varchar(50) NOT NULL,
  `CASHBOX` int NOT NULL,
  `TYPE` int NOT NULL DEFAULT '0',
  `XML_ID` varchar(255) DEFAULT NULL,
  `TRANS_TYPE` int NOT NULL DEFAULT '1',
  `IDEN` int NOT NULL DEFAULT '0',
  `SHIPPER_TRANS_ID` int NOT NULL DEFAULT '0',
  `EXCLUDE_PNL` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `idx_consumption_exclude_pnl` (`EXCLUDE_PNL`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_consumption_child`
--

DROP TABLE IF EXISTS `d0_consumption_child`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_consumption_child` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PARENT` int NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SORT` int DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `MODIF_BY` varchar(50) NOT NULL,
  `XML_ID` varchar(255) DEFAULT NULL,
  `SYSTEM` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_consumption_history`
--

DROP TABLE IF EXISTS `d0_consumption_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_consumption_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CONSUMPTION_ID` int NOT NULL,
  `ACTION_TYPE` enum('UPDATE','DELETE') NOT NULL,
  `CHANGED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `CHANGED_BY` varchar(50) DEFAULT NULL,
  `OLD_DATA` text,
  `NEW_DATA` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_consumption_parent`
--

DROP TABLE IF EXISTS `d0_consumption_parent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_consumption_parent` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SORT` int DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `MODIF_BY` varchar(50) NOT NULL,
  `XML_ID` varchar(255) DEFAULT NULL,
  `SYSTEM` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contact`
--

DROP TABLE IF EXISTS `d0_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contact` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL` varchar(100) NOT NULL,
  `CHAT_ID` bigint DEFAULT NULL,
  `NICKNAME` varchar(100) DEFAULT NULL,
  `FIRST_NAME` varchar(100) DEFAULT NULL,
  `LAST_NAME` varchar(100) DEFAULT NULL,
  `TEL` varchar(100) DEFAULT NULL,
  `COMMAND` varchar(100) DEFAULT NULL,
  `COMMENT` varchar(200) DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `LANG` varchar(3) NOT NULL DEFAULT 'ru',
  `REFERRER_ID` int DEFAULT NULL,
  `TEL_WEBAPP` varchar(100) DEFAULT NULL,
  `NAME_WEBAPP` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contact_client`
--

DROP TABLE IF EXISTS `d0_contact_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contact_client` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL_ID` varchar(60) NOT NULL,
  `CONTACT_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contract`
--

DROP TABLE IF EXISTS `d0_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contract` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` text NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `SUMMA` float(12,2) NOT NULL,
  `BALANS` float(12,2) NOT NULL,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `DATE_PATENT` datetime NOT NULL,
  `DATE_PASSPORT` datetime NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contragent`
--

DROP TABLE IF EXISTS `d0_contragent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contragent` (
  `CLIENT_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `TEL` varchar(200) NOT NULL,
  `FIRM_NAME` varchar(255) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `ADRESS` varchar(255) NOT NULL,
  `CLIENT_CAT` varchar(255) NOT NULL,
  `ORIENT` varchar(255) NOT NULL,
  `REGION` varchar(30) NOT NULL,
  `CITY` varchar(60) NOT NULL,
  `CONTACT_PERSON` varchar(255) NOT NULL,
  `FORM_SOB` varchar(255) NOT NULL,
  `BALANS` decimal(16,2) NOT NULL,
  `DATE_EXP` datetime NOT NULL,
  `LON` float NOT NULL,
  `LAT` float NOT NULL,
  `COMMENT` text NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `PHOTO` varchar(100) NOT NULL,
  `ACCOUNT` varchar(100) NOT NULL,
  `BANK` varchar(250) NOT NULL,
  `MFO` varchar(50) NOT NULL,
  `OKED` varchar(50) NOT NULL,
  `CODE_NDS` varchar(50) NOT NULL,
  `PINFL` int unsigned NOT NULL,
  `CONTRACT` varchar(500) NOT NULL,
  `CONTRACT_DATE` date DEFAULT NULL,
  `NSP_CODE` varchar(50) NOT NULL DEFAULT '50',
  `CHANNEL` int DEFAULT NULL,
  `NEED_TO_AUDIT` varchar(1) NOT NULL DEFAULT 'N',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TYPE` int NOT NULL,
  PRIMARY KEY (`CLIENT_ID`),
  KEY `ID` (`ID`),
  KEY `CITY` (`CITY`),
  KEY `XML_ID` (`XML_ID`),
  KEY `CLIENT_CAT` (`CLIENT_CAT`),
  KEY `DATE_EXP` (`DATE_EXP`),
  KEY `ACTIVE` (`ACTIVE`)
) ENGINE=InnoDB AUTO_INCREMENT=15034 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contragent_history`
--

DROP TABLE IF EXISTS `d0_contragent_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contragent_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CONTRAGENT` varchar(60) NOT NULL,
  `FROM_DATE` datetime NOT NULL,
  `TO_DATE` datetime NOT NULL,
  `ACTIVE` varchar(60) DEFAULT 'Y',
  `CREATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_BY` varchar(60) DEFAULT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_contragent_log`
--

DROP TABLE IF EXISTS `d0_contragent_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_contragent_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `FIELD` varchar(50) NOT NULL,
  `OLD_VALUE` text NOT NULL,
  `NEW_VALUE` text NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_conversion`
--

DROP TABLE IF EXISTS `d0_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_conversion` (
  `CURRENCY_RATE` varchar(20) NOT NULL,
  `CONVERSION_TYPE` varchar(60) NOT NULL,
  `RATE` int NOT NULL,
  `DATE` datetime NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `COMMENT` varchar(60) NOT NULL,
  `ACTIVE` varchar(60) NOT NULL,
  PRIMARY KEY (`CURRENCY_RATE`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_created_stores`
--

DROP TABLE IF EXISTS `d0_created_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_created_stores` (
  `CREATED_STORE_ID` varchar(50) NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `NAME` varchar(1000) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `ROLE` int NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `TIMESTAMP_X` datetime NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  PRIMARY KEY (`CREATED_STORE_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `STORE_ID` (`STORE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1890 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_currency`
--

DROP TABLE IF EXISTS `d0_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_currency` (
  `CURRENCY_ID` varchar(500) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `CODE` varchar(250) NOT NULL,
  `CSS_CLASS` varchar(250) NOT NULL,
  `TITLE` varchar(250) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `TYPE` char(1) DEFAULT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`CURRENCY_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_debt_finans`
--

DROP TABLE IF EXISTS `d0_debt_finans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_debt_finans` (
  `DEBT_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `SUMMA` float(12,2) NOT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `DATE` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DEBT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_defect_detail_log`
--

DROP TABLE IF EXISTS `d0_defect_detail_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_defect_detail_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DEFECT_ID` varchar(60) NOT NULL,
  `DEFECT_DETAIL_ID` varchar(60) NOT NULL,
  `FIELD` varchar(50) NOT NULL,
  `OLD_VALUE` text NOT NULL,
  `NEW_VALUE` text NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16273 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_defects`
--

DROP TABLE IF EXISTS `d0_defects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_defects` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(20) NOT NULL,
  `COUNT` decimal(12,3) NOT NULL,
  `CLIENT_ID` varchar(20) NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  `PRODUCT_ID` varchar(20) NOT NULL,
  `OP_DATE` datetime NOT NULL,
  `TYPE` int NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_diler`
--

DROP TABLE IF EXISTS `d0_diler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_diler` (
  `DILER_ID` varchar(60) NOT NULL,
  `REGION` varchar(255) NOT NULL,
  `PRICE_TYPE` varchar(60) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `FIRM_NAME` varchar(255) NOT NULL,
  `TEL` varchar(20) NOT NULL,
  `ADDRESS` varchar(255) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `SHIPPER` varchar(500) NOT NULL,
  `BANK` varchar(500) NOT NULL,
  `ACCOUNT` varchar(50) NOT NULL,
  `MFO` varchar(50) NOT NULL,
  `OKED` varchar(50) NOT NULL,
  `INN` varchar(20) NOT NULL,
  `DIRECTOR` varchar(200) NOT NULL,
  `ACCOUNTANT` varchar(200) NOT NULL,
  `BANK_CITY` varchar(100) NOT NULL,
  `CODE_NDS` varchar(50) NOT NULL,
  `GOODS_REL` varchar(200) NOT NULL,
  PRIMARY KEY (`DILER_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_doctor_strike`
--

DROP TABLE IF EXISTS `d0_doctor_strike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_doctor_strike` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `FACT` decimal(16,3) unsigned NOT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT_GROUP` int NOT NULL,
  `DAY_1` text NOT NULL,
  `DAY_2` text NOT NULL,
  `DAY_3` text NOT NULL,
  `DAY_4` text NOT NULL,
  `DAY_5` text NOT NULL,
  `DAY_6` text NOT NULL,
  `DAY_7` text NOT NULL,
  `DAY_8` text NOT NULL,
  `DAY_9` text NOT NULL,
  `DAY_10` text NOT NULL,
  `DAY_11` text NOT NULL,
  `DAY_12` text NOT NULL,
  `DAY_13` text NOT NULL,
  `DAY_14` text NOT NULL,
  `DAY_15` text NOT NULL,
  `DAY_16` text NOT NULL,
  `DAY_17` text NOT NULL,
  `DAY_18` text NOT NULL,
  `DAY_19` text NOT NULL,
  `DAY_20` text NOT NULL,
  `DAY_21` text NOT NULL,
  `DAY_22` text NOT NULL,
  `DAY_23` text NOT NULL,
  `DAY_24` text NOT NULL,
  `DAY_25` text NOT NULL,
  `DAY_26` text NOT NULL,
  `DAY_27` text NOT NULL,
  `DAY_28` text NOT NULL,
  `DAY_29` text NOT NULL,
  `DAY_30` text NOT NULL,
  `DAY_31` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_doctor_volume`
--

DROP TABLE IF EXISTS `d0_doctor_volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_doctor_volume` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `FACT` decimal(16,3) unsigned NOT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT_GROUP` int NOT NULL,
  `DAY_1` decimal(16,3) unsigned NOT NULL,
  `DAY_2` decimal(16,3) unsigned NOT NULL,
  `DAY_3` decimal(16,3) unsigned NOT NULL,
  `DAY_4` decimal(16,3) unsigned NOT NULL,
  `DAY_5` decimal(16,3) unsigned NOT NULL,
  `DAY_6` decimal(16,3) unsigned NOT NULL,
  `DAY_7` decimal(16,3) unsigned NOT NULL,
  `DAY_8` decimal(16,3) unsigned NOT NULL,
  `DAY_9` decimal(16,3) unsigned NOT NULL,
  `DAY_10` decimal(16,3) unsigned NOT NULL,
  `DAY_11` decimal(16,3) unsigned NOT NULL,
  `DAY_12` decimal(16,3) unsigned NOT NULL,
  `DAY_13` decimal(16,3) unsigned NOT NULL,
  `DAY_14` decimal(16,3) unsigned NOT NULL,
  `DAY_15` decimal(16,3) unsigned NOT NULL,
  `DAY_16` decimal(16,3) unsigned NOT NULL,
  `DAY_17` decimal(16,3) unsigned NOT NULL,
  `DAY_18` decimal(16,3) unsigned NOT NULL,
  `DAY_19` decimal(16,3) unsigned NOT NULL,
  `DAY_20` decimal(16,3) unsigned NOT NULL,
  `DAY_21` decimal(16,3) unsigned NOT NULL,
  `DAY_22` decimal(16,3) unsigned NOT NULL,
  `DAY_23` decimal(16,3) unsigned NOT NULL,
  `DAY_24` decimal(16,3) unsigned NOT NULL,
  `DAY_25` decimal(16,3) unsigned NOT NULL,
  `DAY_26` decimal(16,3) unsigned NOT NULL,
  `DAY_27` decimal(16,3) unsigned NOT NULL,
  `DAY_28` decimal(16,3) unsigned NOT NULL,
  `DAY_29` decimal(16,3) unsigned NOT NULL,
  `DAY_30` decimal(16,3) unsigned NOT NULL,
  `DAY_31` decimal(16,3) unsigned NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_entity_xml_map`
--

DROP TABLE IF EXISTS `d0_entity_xml_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_entity_xml_map` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SD_ID` varchar(100) NOT NULL,
  `MODEL` varchar(200) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  `XML_ID` varchar(200) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_exchange`
--

DROP TABLE IF EXISTS `d0_exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_exchange` (
  `EXCHANGE_ID` int NOT NULL AUTO_INCREMENT,
  `FROM_STORE` varchar(50) NOT NULL,
  `TO_STORE` varchar(50) NOT NULL,
  `COUNT` decimal(12,3) NOT NULL,
  `DATE` datetime NOT NULL,
  `RESPONSIBLE` varchar(200) DEFAULT NULL,
  `TYPE` tinyint NOT NULL DEFAULT '1',
  `OPERATION` tinyint NOT NULL DEFAULT '1',
  `MODEL` varchar(50) NOT NULL,
  `MODEL_ID` varchar(24) NOT NULL,
  `DATE_RETURN` datetime DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` varchar(10) NOT NULL,
  `SYNC` varchar(10) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `VS_EXCHANGE` int DEFAULT NULL,
  `VS_TYPE` varchar(2) DEFAULT NULL COMMENT 'N-new, C-cancel, R-return, E-edit',
  `VS_RETURN` int DEFAULT NULL,
  `XML_ID` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`EXCHANGE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1823 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_exchange_detail`
--

DROP TABLE IF EXISTS `d0_exchange_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_exchange_detail` (
  `EXCHANGE_DET_ID` int NOT NULL AUTO_INCREMENT,
  `EXCHANGE_ID` int NOT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `VOLUME` float(20,4) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` varchar(255) NOT NULL,
  `SYNC` varchar(255) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`EXCHANGE_DET_ID`),
  KEY `EXCHANGE_ID` (`EXCHANGE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3638 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_excretion`
--

DROP TABLE IF EXISTS `d0_excretion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_excretion` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `COMMENT` text NOT NULL,
  `RESPONSIBLE` varchar(16) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `MODIF_BY` varchar(50) NOT NULL,
  `PARENT_TIME` bigint NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `XML_ID` varchar(200) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ix_excretion_prod_store_date` (`PRODUCT`,`STORE_ID`,`DATE`,`TIMESTAMP_X`,`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor`
--

DROP TABLE IF EXISTS `d0_expeditor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor` (
  `EXPEDITOR_ID` varchar(60) NOT NULL,
  `FIO` varchar(200) NOT NULL,
  `TEL` varchar(20) NOT NULL,
  `PASSPORT_COPY` varchar(255) NOT NULL,
  `DATE_BIRTH` date NOT NULL,
  `PINFL` varchar(127) NOT NULL,
  `AUTONUM` varchar(100) NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `PHOTO` varchar(255) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CITY_ID` text NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  `ADD_FILTER` tinyint(1) NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `DEFECT_STORE` varchar(50) NOT NULL,
  `APP_VERSION` varchar(20) DEFAULT NULL,
  `DEVICE_MODEL` varchar(100) DEFAULT NULL,
  `LAST_SYNC_TIME` datetime DEFAULT NULL,
  `AUTOBRAND` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`EXPEDITOR_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_kpi_job`
--

DROP TABLE IF EXISTS `d0_expeditor_kpi_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_kpi_job` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `TYPE` tinyint NOT NULL,
  `CRITERIA` text,
  `PRODUCTS` text,
  `FLAGS` text,
  `REWARD_TYPE` varchar(60) DEFAULT NULL,
  `REWARD` decimal(14,2) DEFAULT NULL,
  `FRACTION` decimal(14,2) DEFAULT NULL,
  `STEPS` text,
  `COMMENT` varchar(1000) DEFAULT NULL,
  `ACTIVE` varchar(1) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(60) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_kpi_setup`
--

DROP TABLE IF EXISTS `d0_expeditor_kpi_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_kpi_setup` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MONTH` varchar(7) NOT NULL,
  `DETAILS` text NOT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(60) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_load`
--

DROP TABLE IF EXISTS `d0_expeditor_load`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_load` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EXPEDITOR_ID` varchar(60) NOT NULL,
  `CONFIRM` tinyint DEFAULT '0',
  `DATE` datetime NOT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_load_detail`
--

DROP TABLE IF EXISTS `d0_expeditor_load_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_load_detail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DOCUMENT_ID` int NOT NULL,
  `EXPEDITOR_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `MODEL` varchar(50) DEFAULT NULL,
  `COUNT` decimal(12,2) NOT NULL,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `ORDER_COUNT` decimal(12,2) DEFAULT NULL,
  `TYPE` int NOT NULL COMMENT '1- load\r\n2-order',
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_load_history`
--

DROP TABLE IF EXISTS `d0_expeditor_load_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_load_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EXPEDITOR_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `COUNT` decimal(12,2) NOT NULL,
  `DOCUMENT_ID` int NOT NULL,
  `DATE` bigint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_load_neo`
--

DROP TABLE IF EXISTS `d0_expeditor_load_neo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_load_neo` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_expeditor_paket`
--

DROP TABLE IF EXISTS `d0_expeditor_paket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_expeditor_paket` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EXPEDITOR_ID` varchar(200) NOT NULL,
  `SETTINGS` text NOT NULL,
  `UPDATED_AT` datetime NOT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(200) DEFAULT NULL,
  `CREATED_BY` varchar(200) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_feedbacks`
--

DROP TABLE IF EXISTS `d0_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_feedbacks` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CHAT_ID` bigint NOT NULL,
  `FEEDBACK` varchar(4096) NOT NULL,
  `DATE` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial`
--

DROP TABLE IF EXISTS `d0_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `domain` varchar(100) NOT NULL,
  `active` varchar(1) NOT NULL DEFAULT 'Y',
  `is_main` tinyint NOT NULL DEFAULT '0',
  `prefix` varchar(100) NOT NULL DEFAULT '',
  `xml_id` varchar(255) DEFAULT NULL,
  `sort` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UniqueDomain` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial_client`
--

DROP TABLE IF EXISTS `d0_filial_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial_client` (
  `FILIAL_ID` int NOT NULL,
  `CLIENT_ID` varchar(200) NOT NULL,
  UNIQUE KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial_currency`
--

DROP TABLE IF EXISTS `d0_filial_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial_currency` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int NOT NULL,
  `CURRENCY_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_filial` (`FILIAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial_order`
--

DROP TABLE IF EXISTS `d0_filial_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial_order` (
  `ORDER_ID` varchar(200) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  `MAIN_FILIAL_ID` int NOT NULL,
  `STATUS` tinyint NOT NULL DEFAULT '0',
  `TYPE` tinyint DEFAULT '1' COMMENT '1-Первичка, 2-перемещение',
  `PURCHASE_ID` varchar(200) DEFAULT NULL,
  `PUR_BONUS_ID` varchar(200) DEFAULT NULL,
  `COMMENT` text,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `filial_order_unique` (`ORDER_ID`,`FILIAL_ID`,`MAIN_FILIAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial_photo_category`
--

DROP TABLE IF EXISTS `d0_filial_photo_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial_photo_category` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int NOT NULL,
  `PR_CAT_ID` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_filial_product`
--

DROP TABLE IF EXISTS `d0_filial_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_filial_product` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_forecast_category`
--

DROP TABLE IF EXISTS `d0_forecast_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_forecast_category` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CAT_1` float(8,0) NOT NULL DEFAULT '0',
  `CAT_2` float(8,0) NOT NULL DEFAULT '100',
  `CAT_3` float(8,0) NOT NULL DEFAULT '200',
  `CAT_4` float(8,0) NOT NULL DEFAULT '300',
  `CAT_5` float(8,0) NOT NULL DEFAULT '400',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_gps`
--

DROP TABLE IF EXISTS `d0_gps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_gps` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(100) DEFAULT NULL,
  `TYPE` varchar(100) DEFAULT NULL,
  `ORDER_ID` varchar(100) DEFAULT NULL,
  `CLIENT_ID` varchar(100) DEFAULT NULL,
  `VISIT_ID` int unsigned DEFAULT NULL,
  `LAT` decimal(9,6) DEFAULT NULL,
  `LON` decimal(9,6) DEFAULT NULL,
  `BATTERY` int DEFAULT NULL,
  `PROVIDER` varchar(50) DEFAULT NULL,
  `SIGNAL` int DEFAULT NULL,
  `MODE` varchar(50) DEFAULT NULL,
  `INTERNET_STATUS` int DEFAULT NULL,
  `GPS_STATUS` int DEFAULT NULL,
  `MOB_TIMESTAMP` varchar(50) DEFAULT NULL,
  `TIMESTAMP_X` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `DATE` datetime NOT NULL,
  `DAY` date DEFAULT NULL,
  `DEVICE` varchar(100) DEFAULT NULL,
  `USER_ID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`,`DATE`),
  KEY `idx_user_date` (`USER_ID`,`DATE`)
) ENGINE=InnoDB AUTO_INCREMENT=621711 DEFAULT CHARSET=utf8mb3
/*!50100 PARTITION BY RANGE (year(`DATE`))
(PARTITION pd_2024 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION pd_2025 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION pd_2026 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION pd_max VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_gps_adt`
--

DROP TABLE IF EXISTS `d0_gps_adt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_gps_adt` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISIT_ID` int DEFAULT NULL,
  `POSITION_ID` int DEFAULT NULL,
  `ROLE` int NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) DEFAULT NULL,
  `TYPE` varchar(100) DEFAULT NULL,
  `LAT` float DEFAULT NULL,
  `LON` float DEFAULT NULL,
  `BATTERY` int DEFAULT NULL,
  `PROVIDER` varchar(50) DEFAULT NULL,
  `SIGNAL` int DEFAULT NULL,
  `MODE` varchar(50) DEFAULT NULL,
  `INTERNET_STATUS` int DEFAULT NULL,
  `GPS_STATUS` int DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DATE` datetime NOT NULL,
  `DEVICE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=935224 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_idokon_client_setting`
--

DROP TABLE IF EXISTS `d0_idokon_client_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_idokon_client_setting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `token` text NOT NULL,
  `price_type_id` varchar(100) NOT NULL,
  `agent_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_idokon_incoming_request`
--

DROP TABLE IF EXISTS `d0_idokon_incoming_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_idokon_incoming_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'pending, attached, rejected',
  `client_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_idokon_product`
--

DROP TABLE IF EXISTS `d0_idokon_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_idokon_product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `sd_product_id` varchar(100) DEFAULT NULL,
  `idokon_product_id` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_incoming_invoices`
--

DROP TABLE IF EXISTS `d0_incoming_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_incoming_invoices` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `OPERATOR_ID` tinyint NOT NULL,
  `DOCUMENT_ID` varchar(100) NOT NULL,
  `ROAMING_ID` varchar(30) NOT NULL,
  `CORRECTED_ROUMING_ID` varchar(30) NOT NULL DEFAULT '',
  `INVOICE_NUMBER` varchar(50) DEFAULT NULL,
  `INVOICE_DATE` date NOT NULL,
  `CONTRACT_NUMBER` varchar(50) DEFAULT NULL,
  `CONTRACT_DATE` date DEFAULT NULL,
  `INVOICE_STATUS` tinyint NOT NULL,
  `CISES_STATUS` tinyint NOT NULL,
  `ACCEPTANCE_STATUS` tinyint NOT NULL,
  `SENDER_NAME` varchar(60) NOT NULL,
  `SENDER_TIN` varchar(9) NOT NULL DEFAULT '',
  `SENDER_PINFL` varchar(14) NOT NULL DEFAULT '',
  `SUMMA` decimal(16,2) DEFAULT NULL,
  `TIMESTAMP_X` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ROAMING_ID` (`ROAMING_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_incoming_invoices_details`
--

DROP TABLE IF EXISTS `d0_incoming_invoices_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_incoming_invoices_details` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `PARENT_ID` int NOT NULL,
  `ITEM_NAME` varchar(100) NOT NULL,
  `IKPU_NAME` varchar(50) NOT NULL DEFAULT '',
  `IKPU_CODE` varchar(17) NOT NULL,
  `UNIT` varchar(20) NOT NULL DEFAULT '',
  `QUANTITY` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `SUMMA` decimal(16,2) NOT NULL DEFAULT '0.00',
  `CISES` text NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_parent_id` (`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_incoming_invoices_scanned_cises`
--

DROP TABLE IF EXISTS `d0_incoming_invoices_scanned_cises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_incoming_invoices_scanned_cises` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `PARENT_ID` int NOT NULL,
  `CIS` varchar(31) NOT NULL,
  `IS_DEFECT` tinyint(1) NOT NULL,
  `SCANNED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SCANNED_BY` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uc_pair` (`PARENT_ID`,`CIS`),
  KEY `idx_parent_id` (`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_integrations`
--

DROP TABLE IF EXISTS `d0_integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_integrations` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SERVICE` varchar(20) NOT NULL,
  `USER_ID` varchar(60) NOT NULL,
  `ACL` text COMMENT 'Access Control List',
  `SETTINGS` json NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UC_Document` (`SERVICE`,`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory`
--

DROP TABLE IF EXISTS `d0_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory` (
  `INVENTORY_ID` varchar(60) NOT NULL,
  `INV_TYPE_ID` varchar(250) NOT NULL,
  `DILER_ID` varchar(60) DEFAULT NULL,
  `NAME` varchar(250) NOT NULL,
  `MODEL` varchar(250) NOT NULL,
  `SERIAL_NUM` varchar(250) NOT NULL,
  `INV_NO` varchar(250) DEFAULT NULL,
  `DATE_PRODUCTION` date DEFAULT NULL,
  `FOTO` varchar(250) DEFAULT NULL,
  `COMMENT` text,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`INVENTORY_ID`),
  KEY `ID` (`ID`),
  KEY `INV_TYPE_ID` (`INV_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory_check`
--

DROP TABLE IF EXISTS `d0_inventory_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory_check` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `INVENTORY_ID` varchar(60) NOT NULL,
  `INVENTORY_HIST_ID` varchar(60) DEFAULT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `LAT` double DEFAULT NULL,
  `LON` double DEFAULT NULL,
  `COMMENT` varchar(512) DEFAULT NULL,
  `SCANNED_AT` datetime NOT NULL,
  `QRDATA` varchar(1024) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory_check_photo`
--

DROP TABLE IF EXISTS `d0_inventory_check_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory_check_photo` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `INVENTORY_CHECK_ID` int NOT NULL,
  `FILE_NAME` varchar(128) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FILE_NAME` (`FILE_NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory_group`
--

DROP TABLE IF EXISTS `d0_inventory_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory_history`
--

DROP TABLE IF EXISTS `d0_inventory_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory_history` (
  `INVENTORY_HIST_ID` varchar(60) NOT NULL,
  `INVENTORY_ID` varchar(60) NOT NULL,
  `INV_TYPE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) DEFAULT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `STATUS` tinyint NOT NULL DEFAULT '1',
  `CONDITION` varchar(250) NOT NULL,
  `DATE_FROM` date DEFAULT NULL,
  `DATE_TO` date DEFAULT NULL,
  `FOTO` varchar(250) NOT NULL,
  `COMMENT` text NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`INVENTORY_HIST_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `INV_TYPE_ID` (`INV_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=676 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_inventory_type`
--

DROP TABLE IF EXISTS `d0_inventory_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_inventory_type` (
  `INV_TYPE_ID` varchar(60) NOT NULL,
  `INV_GROUP` int NOT NULL DEFAULT '1',
  `DILER_ID` varchar(60) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `CODE` varchar(250) NOT NULL,
  `CSS_CLASS` varchar(250) NOT NULL,
  `TITLE` varchar(250) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `UNIQUE` tinyint NOT NULL DEFAULT '0',
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`INV_TYPE_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_invoice`
--

DROP TABLE IF EXISTS `d0_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_invoice_detail`
--

DROP TABLE IF EXISTS `d0_invoice_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_invoice_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_invoice_template`
--

DROP TABLE IF EXISTS `d0_invoice_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_invoice_template` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `GROUP` varchar(100) NOT NULL,
  `DISPLAY_NAME` varchar(100) NOT NULL,
  `FILE_NAME` varchar(100) NOT NULL,
  `OUTPUT_FORMAT` varchar(50) DEFAULT NULL,
  `CREATE_BY` varchar(100) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_BY` varchar(100) NOT NULL,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FILE_NAME` (`FILE_NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_knowledge_bind`
--

DROP TABLE IF EXISTS `d0_knowledge_bind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_knowledge_bind` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ROLE` tinyint NOT NULL,
  `BIND_ID` int NOT NULL COMMENT 'Category or Post',
  `TYPE` varchar(2) NOT NULL COMMENT 'C - Category, P-Post',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_knowledge_bind_dealer`
--

DROP TABLE IF EXISTS `d0_knowledge_bind_dealer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_knowledge_bind_dealer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int NOT NULL,
  `BIND_ID` int NOT NULL COMMENT 'Category or Post',
  `TYPE` varchar(2) NOT NULL COMMENT 'C - Category, P-Post',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_knowledge_categories`
--

DROP TABLE IF EXISTS `d0_knowledge_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_knowledge_categories` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `ACTIVE` varchar(2) NOT NULL DEFAULT 'Y',
  `CODE` varchar(50) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_knowledge_post`
--

DROP TABLE IF EXISTS `d0_knowledge_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_knowledge_post` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(200) NOT NULL,
  `CATEGORY_ID` int NOT NULL,
  `CONTENT` text NOT NULL,
  `ACTIVE` varchar(2) NOT NULL DEFAULT 'Y',
  `CODE` varchar(50) DEFAULT NULL,
  `PHOTO_URL` varchar(200) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `CREATED_BY` varchar(50) NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi`
--

DROP TABLE IF EXISTS `d0_kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi` (
  `KPI_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `KPI_TYPE` varchar(255) NOT NULL,
  `FIX_SALARY` decimal(16,2) NOT NULL,
  `TEAM_TYPE` varchar(255) NOT NULL,
  `TEAM` varchar(1000) NOT NULL,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `MONTH` varchar(50) NOT NULL,
  `YEAR` varchar(50) NOT NULL,
  `COMMENT` text NOT NULL,
  `MARK` char(1) NOT NULL,
  `MARK2` decimal(9,2) DEFAULT NULL,
  `MARK1` decimal(9,2) DEFAULT NULL,
  `MARK1_TEXT` text NOT NULL,
  `MARK2_TEXT` text NOT NULL,
  `MARK3` decimal(9,2) DEFAULT NULL,
  `MARK3_TEXT` text NOT NULL,
  `MARK4` decimal(9,2) DEFAULT NULL,
  `MARK4_TEXT` text NOT NULL,
  `MARK5` decimal(9,2) DEFAULT NULL,
  `MARK5_TEXT` text NOT NULL,
  `MARK6` decimal(9,2) DEFAULT NULL,
  `MARK6_TEXT` text NOT NULL,
  `MARK7` decimal(9,2) DEFAULT NULL,
  `MARK7_TEXT` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `SUPERVISER` tinyint(1) NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`KPI_ID`),
  KEY `ID` (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi_group`
--

DROP TABLE IF EXISTS `d0_kpi_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi_group_link`
--

DROP TABLE IF EXISTS `d0_kpi_group_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi_group_link` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `GR_ID` int NOT NULL,
  `T_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi_task`
--

DROP TABLE IF EXISTS `d0_kpi_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi_task` (
  `KPI_TASK_ID` varchar(60) NOT NULL,
  `KPI_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `TASK_TYPE` varchar(255) NOT NULL,
  `VALUE` float NOT NULL DEFAULT '0',
  `MAX_BONUS` decimal(9,2) NOT NULL,
  `COMMENT` text NOT NULL,
  `DATE_TYPE` varchar(255) NOT NULL,
  `STATUS` varchar(255) NOT NULL,
  `PRODUCT_ID` mediumtext,
  `CLIENT_CAT` varchar(1000) NOT NULL,
  `CLIENT_CLASS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CLIENT_CHANNEL` varchar(1000) DEFAULT NULL,
  `CLIENT_TYPE` varchar(1000) DEFAULT NULL,
  `PRICE_TYPE` varchar(1000) NOT NULL,
  `CITY_ID` varchar(1000) NOT NULL,
  `AGENT` varchar(1000) DEFAULT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `TRADE` varchar(255) NOT NULL,
  `KPI_SHARE` float NOT NULL DEFAULT '0',
  `BONUS_TYPE` varchar(255) NOT NULL DEFAULT 'N',
  `BONUS` float NOT NULL,
  `MARK` char(1) NOT NULL DEFAULT 'N',
  `MARK1` decimal(9,2) DEFAULT NULL,
  `MARK1_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK1_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK2` decimal(9,2) DEFAULT NULL,
  `MARK2_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK2_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK3` decimal(9,2) DEFAULT NULL,
  `MARK3_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK3_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK4` decimal(9,2) DEFAULT NULL,
  `MARK4_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK4_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK5` decimal(9,2) DEFAULT NULL,
  `MARK5_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK5_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK6` decimal(9,2) DEFAULT NULL,
  `MARK6_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK6_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK7` decimal(9,2) DEFAULT NULL,
  `MARK7_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MARK7_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `PRODUCT_CAT` varchar(1000) NOT NULL,
  `TEMPLATE_ID` int NOT NULL,
  `AUDIT_SHARE` int NOT NULL DEFAULT '100',
  PRIMARY KEY (`KPI_TASK_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `KPI_ID` (`KPI_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=649 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi_task_template`
--

DROP TABLE IF EXISTS `d0_kpi_task_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi_task_template` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(60) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `TASK_TYPE` varchar(255) NOT NULL,
  `COMMENT` text NOT NULL,
  `DATE_TYPE` varchar(255) NOT NULL,
  `STATUS` varchar(255) NOT NULL,
  `PRODUCT_ID` mediumtext,
  `CLIENT_CAT` varchar(1000) NOT NULL,
  `CLIENT_CLASS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CLIENT_CHANNEL` varchar(1000) DEFAULT NULL,
  `CLIENT_TYPE` varchar(1000) DEFAULT NULL,
  `PRICE_TYPE` varchar(1000) NOT NULL,
  `CITY_ID` varchar(1000) NOT NULL,
  `AGENT` varchar(1000) DEFAULT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `TRADE` varchar(255) NOT NULL,
  `KPI_SHARE` float NOT NULL DEFAULT '0',
  `BONUS_TYPE` varchar(255) NOT NULL DEFAULT 'N',
  `BONUS` float NOT NULL,
  `MARK` char(1) NOT NULL DEFAULT 'N',
  `MARK1` decimal(9,2) DEFAULT NULL,
  `MARK1_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK1_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK2` decimal(9,2) DEFAULT NULL,
  `MARK2_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK2_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK3` decimal(9,2) DEFAULT NULL,
  `MARK3_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK3_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK4` decimal(9,2) DEFAULT NULL,
  `MARK4_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK4_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK5` decimal(9,2) DEFAULT NULL,
  `MARK5_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK5_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK6` decimal(9,2) DEFAULT NULL,
  `MARK6_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK6_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `MARK7` decimal(9,2) DEFAULT NULL,
  `MARK7_KPI_SHARE` decimal(9,2) DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MARK7_BONUS_SHARE` decimal(9,2) DEFAULT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `PRODUCT_CAT` varchar(1000) NOT NULL,
  `MIN_SUM` decimal(14,2) DEFAULT '0.00',
  `ACCESS_TO_OTHERS` tinyint(1) NOT NULL DEFAULT '1',
  `NEW_CLIENTS` tinyint(1) DEFAULT '0',
  `REPLACEMENTS` tinyint(1) DEFAULT '0',
  `SUPERVISER` tinyint(1) NOT NULL DEFAULT '0',
  `MAX_BONUS` decimal(14,2) DEFAULT NULL,
  `ACCESS_TO_USE` tinyint(1) NOT NULL DEFAULT '1',
  `COPY` tinyint(1) NOT NULL DEFAULT '0',
  `ACCESS_TO_EDIT` tinyint(1) NOT NULL DEFAULT '1',
  `DEACTIVATED_CLIENT` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_kpi_task_template_group`
--

DROP TABLE IF EXISTS `d0_kpi_task_template_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_kpi_task_template_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `TASK_TYPE` varchar(50) NOT NULL,
  `KPI_TASK_TEMPLATE_ID` text NOT NULL,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `MAIN_ID` varchar(12) DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_license_limit`
--

DROP TABLE IF EXISTS `d0_license_limit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_license_limit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FILIAL_ID` int NOT NULL,
  `TYPE` varchar(50) NOT NULL,
  `LIMIT` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_log`
--

DROP TABLE IF EXISTS `d0_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `DEVICE_TOKEN` varchar(500) NOT NULL,
  `REQUEST` longtext NOT NULL,
  `RESPONSE` longtext NOT NULL,
  `ERRORS` text NOT NULL,
  `STATUS` varchar(30) NOT NULL,
  `MESSAGE` text NOT NULL,
  `DATE` datetime NOT NULL,
  `URL` varchar(500) NOT NULL,
  `CONTROLLER` varchar(50) NOT NULL,
  `ACTION` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `DATE` (`DATE`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `CONTROLLER` (`CONTROLLER`),
  KEY `agentController` (`AGENT_ID`(6),`CONTROLLER`(6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_lot`
--

DROP TABLE IF EXISTS `d0_lot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_lot` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LOT_DOCUMENT` varchar(50) NOT NULL,
  `LOT_DOCUMENT_ID` varchar(50) NOT NULL,
  `LOT_DOCUMENT_DETAIL_ID` varchar(50) NOT NULL,
  `WAREHOUSE_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `EXP_DATE` date DEFAULT NULL,
  `MFG_DATE` date DEFAULT NULL,
  `COST_PRICE` decimal(16,4) NOT NULL,
  `CONSUMED` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `AVAILABLE` decimal(16,4) NOT NULL,
  `FROZEN` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4309 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_lot_distribution`
--

DROP TABLE IF EXISTS `d0_lot_distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_lot_distribution` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LOT_DOCUMENT` varchar(50) NOT NULL,
  `LOT_DOCUMENT_ID` varchar(50) NOT NULL,
  `LOT_DOCUMENT_DETAIL_ID` varchar(50) NOT NULL,
  `SALE_DOCUMENT` varchar(50) NOT NULL,
  `SALE_DOCUMENT_ID` varchar(50) NOT NULL,
  `SALE_DOCUMENT_DETAIL_ID` varchar(50) NOT NULL,
  `WAREHOUSE_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `COST_PRICE` decimal(16,4) NOT NULL,
  `SELLING_PRICE` decimal(16,4) NOT NULL,
  `LOT_DATE` datetime NOT NULL,
  `SALE_DATE` datetime NOT NULL,
  `EXP_DATE` date DEFAULT NULL,
  `MFG_DATE` date DEFAULT NULL,
  `QUANTITY` decimal(16,4) NOT NULL,
  `STOCK_MODEL` varchar(10) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_triple_sale` (`SALE_DOCUMENT`,`SALE_DOCUMENT_ID`,`SALE_DOCUMENT_DETAIL_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21931 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_loyalty_program`
--

DROP TABLE IF EXISTS `d0_loyalty_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_loyalty_program` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `FROM_DATE` date NOT NULL,
  `TO_DATE` date NOT NULL,
  `BONUS_TYPE` tinyint NOT NULL,
  `TYPE` tinyint NOT NULL,
  `CURRENCY_ID` varchar(100) NOT NULL,
  `ACTIVE` tinyint NOT NULL,
  `CREATED_BY` varchar(100) NOT NULL,
  `UPDATED_BY` varchar(100) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_loyalty_program_detail`
--

DROP TABLE IF EXISTS `d0_loyalty_program_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_loyalty_program_detail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LOYALTY_ID` int NOT NULL,
  `PRODUCT_ID` varchar(100) NOT NULL,
  `BONUS` decimal(16,2) NOT NULL,
  `CREATED_BY` varchar(100) NOT NULL,
  `UPDATED_BY` varchar(100) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_loyalty_transactions`
--

DROP TABLE IF EXISTS `d0_loyalty_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_loyalty_transactions` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LOYALTY_PROGRAM` int NOT NULL,
  `ORDER_ID` varchar(200) NOT NULL,
  `CONTACT_ID` int NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `BONUS` decimal(16,2) NOT NULL,
  `TYPE` tinyint NOT NULL,
  `CLIENT_ID` varchar(200) DEFAULT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_manufacture`
--

DROP TABLE IF EXISTS `d0_manufacture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_manufacture` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_model_log`
--

DROP TABLE IF EXISTS `d0_model_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_model_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL` varchar(50) NOT NULL,
  `GUID` varchar(40) NOT NULL,
  `CREATE_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_model` (`MODEL`),
  KEY `idx_guid` (`GUID`)
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_model_tags`
--

DROP TABLE IF EXISTS `d0_model_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_model_tags` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL` varchar(50) NOT NULL,
  `MODEL_ID` varchar(50) NOT NULL,
  `TAG_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_notification`
--

DROP TABLE IF EXISTS `d0_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_notification` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(200) NOT NULL,
  `PREVIEW` varchar(200) NOT NULL,
  `DETAIL` text,
  `TYPE` tinyint NOT NULL,
  `FROM_SYSTEM` varchar(200) NOT NULL,
  `FROM_USER` varchar(200) DEFAULT NULL,
  `TO_USER` varchar(200) DEFAULT NULL,
  `TO_ROLE` tinyint NOT NULL,
  `AUTO` tinyint NOT NULL DEFAULT '0',
  `SYNC_ID` int DEFAULT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_notify_read`
--

DROP TABLE IF EXISTS `d0_notify_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_notify_read` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(200) NOT NULL,
  `NOTIFY_ID` int NOT NULL,
  `STATUS` int DEFAULT '0',
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_old_price`
--

DROP TABLE IF EXISTS `d0_old_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_old_price` (
  `PRICE_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `OLD_PRICE_TYPE_ID` varchar(50) NOT NULL,
  `PRICE_TYPE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `PRODUCT_ID` varchar(60) NOT NULL,
  `PRICE` decimal(16,4) DEFAULT NULL,
  `CONVERSION` float NOT NULL,
  `CONVERSION_TYPE` varchar(50) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`PRICE_ID`),
  KEY `ID` (`ID`),
  KEY `OLD_PRICE_TYPE_ID` (`OLD_PRICE_TYPE_ID`),
  KEY `PRICE_TYPE_ID` (`PRICE_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=30300 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_old_price_type`
--

DROP TABLE IF EXISTS `d0_old_price_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_old_price_type` (
  `OLD_PRICE_TYPE_ID` varchar(60) NOT NULL,
  `PRICE_TYPE_ID` varchar(60) NOT NULL,
  `TYPE` varchar(50) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `PARENT` varchar(50) NOT NULL DEFAULT '0',
  `FILIAL` int NOT NULL,
  `DILER` varchar(60) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`OLD_PRICE_TYPE_ID`),
  KEY `ID` (`ID`),
  KEY `PRICE_TYPE_ID` (`PRICE_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=445 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_online_order`
--

DROP TABLE IF EXISTS `d0_online_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_online_order` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CONTACT_ID` int NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL DEFAULT '0.00',
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DATE_LOAD` varchar(100) DEFAULT NULL,
  `STATUS` tinyint NOT NULL,
  `COMMENT` varchar(500) DEFAULT NULL,
  `PAYMENT_TYPE` varchar(60) NOT NULL,
  `LOCATION` varchar(100) DEFAULT NULL,
  `ADDRESS` varchar(100) DEFAULT NULL,
  `ORDER_ID` varchar(60) DEFAULT NULL,
  `CLIENT_ID` varchar(60) DEFAULT NULL,
  `SOURCE` varchar(100) NOT NULL,
  `MESSAGE_ID` bigint DEFAULT NULL,
  `LAST_MESSAGE_ID` varchar(100) DEFAULT NULL,
  `PAY` varchar(100) DEFAULT NULL,
  `COMMENT_OPERATOR` varchar(500) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CONTENT_WEBAPP` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_online_order_detail`
--

DROP TABLE IF EXISTS `d0_online_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_online_order_detail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ONLINE_ORDER_ID` int NOT NULL,
  `COUNT` decimal(14,2) NOT NULL DEFAULT '0.00',
  `PRICE` decimal(14,2) NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL,
  `PRODUCT` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_online_payments`
--

DROP TABLE IF EXISTS `d0_online_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_online_payments` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TRANSACTION_ID` int NOT NULL,
  `SERVICE_TYPE` varchar(10) NOT NULL,
  `AMOUNT` decimal(16,2) NOT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order`
--

DROP TABLE IF EXISTS `d0_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order` (
  `ORDER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `CLIENT_ID` varchar(60) NOT NULL,
  `CONTRAGENT` varchar(60) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `PRICE_TYPE` varchar(60) NOT NULL,
  `OLD_PRICE_TYPE` varchar(60) NOT NULL,
  `COUNT` float NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL,
  `DISCOUNT` decimal(14,2) NOT NULL,
  `CLOSED_SUMMA` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `DATE` datetime NOT NULL,
  `STATUS` tinyint NOT NULL,
  `SUB_STATUS` int NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `DATE_CANCEL` datetime NOT NULL,
  `DATE_STATUS` datetime NOT NULL,
  `DEBT` float(12,2) NOT NULL,
  `REPLACE_ID` varchar(20) NOT NULL,
  `DEFECT_ID` varchar(20) NOT NULL,
  `BONUS_ORDER_ID` varchar(20) NOT NULL,
  `BONUS_TYPE` varchar(50) NOT NULL DEFAULT '-1',
  `DISCOUNT_TYPE` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 discount, 0 without discount',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `COMMENT` text NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `TRADE_ID` int NOT NULL DEFAULT '1',
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `TRIP_NUMBER` int NOT NULL DEFAULT '1',
  `TYPE` char(1) NOT NULL,
  `CONTRACT_ID` varchar(50) NOT NULL,
  `COMMENT_2` int DEFAULT NULL,
  `CONSIGNMENT` char(1) NOT NULL DEFAULT '0',
  `XML_ID` varchar(64) DEFAULT NULL,
  `REAL_ID` varchar(200) DEFAULT NULL,
  `INVOICE_NUMBER` varchar(50) DEFAULT NULL,
  `CONSIG_DATE` datetime NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  `DEFECT` varchar(12) NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `SOURCE` text,
  `STOCKMAN_ID` varchar(60) DEFAULT NULL,
  `CISES_STATUS` tinyint NOT NULL DEFAULT '0',
  `RELATED_TO_TYPE` tinyint DEFAULT NULL,
  `URGENT` tinyint DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `CITY_ID` (`CITY_ID`),
  KEY `PRICE_TYPE` (`PRICE_TYPE`),
  KEY `DATE_LOAD` (`DATE_LOAD`),
  KEY `STATUS` (`STATUS`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `DATE` (`DATE`),
  KEY `ix_order_type_status_date` (`TYPE`,`STATUS`,`DATE_LOAD`,`TIMESTAMP_X`,`STORE_ID`,`ORDER_ID`,`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8446 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_cises`
--

DROP TABLE IF EXISTS `d0_order_cises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_cises` (
  `CIS` varchar(31) NOT NULL,
  `ORDER_ID` varchar(30) NOT NULL,
  `GTIN` char(14) DEFAULT NULL,
  `QUANTITY` int DEFAULT NULL,
  `PRODUCT_GROUP_ID` tinyint DEFAULT NULL,
  `PACKAGE_TYPE` tinyint DEFAULT NULL,
  `STATUS` tinyint DEFAULT NULL,
  `OWNER_INN` varchar(14) DEFAULT NULL,
  `PARENT` varchar(31) DEFAULT NULL,
  `CHILD` text,
  `CREATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CIS`),
  KEY `idx_order_id` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_cises_log`
--

DROP TABLE IF EXISTS `d0_order_cises_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_cises_log` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(30) NOT NULL,
  `CISES` json NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_order_id` (`ORDER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_code`
--

DROP TABLE IF EXISTS `d0_order_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_code` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SERVICE` varchar(20) NOT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `CODE` varchar(64) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UC_Document` (`SERVICE`,`ORDER_ID`),
  KEY `idx_order_id` (`SERVICE`,`ORDER_ID`),
  KEY `idx_code` (`SERVICE`,`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_comment`
--

DROP TABLE IF EXISTS `d0_order_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_comment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(256) NOT NULL,
  `XML_ID` text NOT NULL,
  `SORT` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(64) NOT NULL,
  `UPDATE_BY` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_defect`
--

DROP TABLE IF EXISTS `d0_order_defect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_defect` (
  `ORDER_DEFECT_ID` varchar(50) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `DEFECT_TYPE` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `REPLACE_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `CITY` varchar(50) NOT NULL,
  `COUNT` float NOT NULL,
  `PRICE_TYPE` varchar(50) NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL,
  `DISCOUNT` decimal(12,2) NOT NULL,
  `VOLUME` float NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `STATUS` int unsigned NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `COMMENT` text NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `ACTIVE` varchar(20) NOT NULL,
  `SYNC` varchar(20) NOT NULL,
  `REASON` int NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ORDER_DEFECT_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `REPLACE_ID` (`REPLACE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1731 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_defect_detail`
--

DROP TABLE IF EXISTS `d0_order_defect_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_defect_detail` (
  `ORDER_DEFECT_DETAIL_ID` varchar(50) NOT NULL,
  `ORDER_DEFECT_ID` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `PRICE` decimal(14,2) NOT NULL,
  `SUMMA` decimal(14,2) NOT NULL,
  `DISCOUNT` decimal(12,2) NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `EXPIRATION_DATE` date DEFAULT NULL,
  `REASON` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `SKIDKA_MANUAL_ID` varchar(255) NOT NULL,
  `MFG_DATE` date DEFAULT NULL,
  `EXP_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ORDER_DEFECT_DETAIL_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `ORDER_DEFECT_ID` (`ORDER_DEFECT_ID`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `PRODUCT` (`PRODUCT`),
  KEY `ix_order_defect_detail_oid_prod` (`ORDER_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=2746 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_detail`
--

DROP TABLE IF EXISTS `d0_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_detail` (
  `ORDER_DET_ID` varchar(60) NOT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `CLIENT_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `PRODUCT` varchar(60) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `PRICE` decimal(16,4) DEFAULT NULL,
  `SUMMA` decimal(20,4) DEFAULT NULL,
  `DISCOUNT` decimal(20,4) DEFAULT NULL,
  `DISCOUNT_ID` varchar(255) NOT NULL,
  `SKIDKA_MANUAL_ID` varchar(255) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) DEFAULT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `DEFECT` decimal(16,4) DEFAULT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `COMMENT` text,
  PRIMARY KEY (`ORDER_DET_ID`),
  KEY `ID` (`ID`),
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `PRODUCT_CAT` (`PRODUCT_CAT`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `PRODUCT` (`PRODUCT`),
  KEY `ix_order_detail_oid_prod` (`ORDER_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=11803 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_detail_history`
--

DROP TABLE IF EXISTS `d0_order_detail_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_detail_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_HISTORY_ID` int NOT NULL,
  `ORDER_DET_ID` varchar(60) NOT NULL,
  `ORDER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `PRODUCT` varchar(60) NOT NULL,
  `COUNT` decimal(12,2) NOT NULL,
  `PRICE` decimal(12,2) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `DISCOUNT` decimal(12,2) NOT NULL,
  `DISCOUNT_ID` varchar(255) NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  `DEFECT` decimal(12,3) NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18868 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_esf`
--

DROP TABLE IF EXISTS `d0_order_esf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_esf` (
  `ORDER_ID` varchar(30) NOT NULL,
  `ESF_OPERATOR` tinyint DEFAULT NULL COMMENT '1 - DIDOX, 2 - FAKTURA, 3 - SOLIQSERVIS',
  `ESF_DOCUMENT_ID` varchar(60) NOT NULL,
  `ESF_DOCUMENT_TYPE` tinyint NOT NULL COMMENT '1 - Стандартный, 2 - Корректировочный',
  `CISES` json DEFAULT NULL COMMENT 'Коды идентификации',
  `SIGNED` tinyint(1) NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(30) NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SIGNED_BY` varchar(30) DEFAULT NULL,
  `SIGNED_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_history`
--

DROP TABLE IF EXISTS `d0_order_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `PRICE_TYPE` varchar(60) NOT NULL,
  `COUNT` float NOT NULL,
  `SUMMA` float(12,2) NOT NULL,
  `DATE` datetime NOT NULL,
  `STATUS` int NOT NULL,
  `SUB_STATUS` int NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `DATE_CANCEL` datetime NOT NULL,
  `DATE_STATUS` datetime NOT NULL,
  `DEBT` float(12,2) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `COMMENT` text NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `DISCOUNT` decimal(14,2) NOT NULL,
  `EXPEDITOR` varchar(20) NOT NULL,
  `TYPE` char(1) NOT NULL,
  `CONSIGNMENT` char(1) NOT NULL,
  `CONSIG_DATE` datetime NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  `DEFECT` decimal(12,3) NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `XML_ID` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`),
  KEY `idx_order_history_order_id` (`ORDER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31125 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_idokon`
--

DROP TABLE IF EXISTS `d0_order_idokon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_idokon` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(100) NOT NULL,
  `idokon_id` varchar(100) NOT NULL,
  `status` tinyint NOT NULL,
  `comment` text,
  `created_by` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_idokon_index_by_order` (`order_id`),
  KEY `idx_order_idokon_unique` (`order_id`,`idokon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_replace`
--

DROP TABLE IF EXISTS `d0_order_replace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_replace` (
  `ORDER_REPLACE_ID` varchar(50) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `REPLACE_TYPE` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `DEFECT_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `CITY` varchar(50) NOT NULL,
  `COUNT` float NOT NULL,
  `PRICE_TYPE` varchar(50) NOT NULL,
  `SUMMA` float NOT NULL,
  `COMPENSATION` float NOT NULL,
  `VOLUME` float NOT NULL,
  `EXPEDITOR` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `STATUS` int unsigned NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `COMMENT` text NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `REASON` int NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ORDER_REPLACE_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `ORDER_ID` (`ORDER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=533 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_order_replace_detail`
--

DROP TABLE IF EXISTS `d0_order_replace_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_order_replace_detail` (
  `ORDER_REPLACE_DETAIL_ID` varchar(50) NOT NULL,
  `ORDER_REPLACE_ID` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(50) NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `PRICE` float NOT NULL,
  `SUMMA` float NOT NULL,
  `VOLUME` float NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `UNIT` varchar(50) NOT NULL,
  `UNIT_SYMBOL` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`ORDER_REPLACE_DETAIL_ID`),
  KEY `ID` (`ID`) USING BTREE,
  KEY `ORDER_REPLACE_ID` (`ORDER_REPLACE_ID`),
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `ix_order_replace_detail_oid_prod` (`ORDER_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=704 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_outlet_fact`
--

DROP TABLE IF EXISTS `d0_outlet_fact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_outlet_fact` (
  `O_FACT_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_CAT` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CITY` varchar(60) NOT NULL,
  `MONTH` datetime NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `SUMMA` float(12,2) NOT NULL,
  `SHARE_SUMMA` float(8,8) NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `SHARE_VOLUME` float(8,8) NOT NULL,
  `COUNT` float(12,1) NOT NULL,
  `SHARE_COUNT` float(8,8) NOT NULL,
  `ORDERS` text NOT NULL,
  `ID` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`O_FACT_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_outlet_plan`
--

DROP TABLE IF EXISTS `d0_outlet_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_outlet_plan` (
  `O_PLAN_ID` varchar(60) NOT NULL,
  `CLIENT_CAT` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CITY` varchar(60) NOT NULL,
  `MONTH` datetime NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `SUMMA` float(12,2) NOT NULL,
  `FACT_SUMMA` decimal(14,2) unsigned NOT NULL,
  `SHARE_SUMMA` float(8,8) NOT NULL,
  `VOLUME` float(12,3) NOT NULL,
  `FACT_VOLUME` float(12,3) NOT NULL,
  `FACT_VOLUME_PERCENT` float(12,8) NOT NULL,
  `SHARE_VOLUME` float(8,8) NOT NULL,
  `COUNT` float(12,1) NOT NULL,
  `FACT_COUNT` decimal(12,3) unsigned NOT NULL,
  `SHARE_COUNT` float(8,8) NOT NULL,
  `ORDERS` float(12,0) NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`O_PLAN_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB AUTO_INCREMENT=8362 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_parent_photo_report`
--

DROP TABLE IF EXISTS `d0_parent_photo_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_parent_photo_report` (
  `PR_CAT_ID` varchar(60) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `PARENT` varchar(60) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`PR_CAT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_partner`
--

DROP TABLE IF EXISTS `d0_partner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_partner` (
  `PARTNER_CAT_ID` varchar(60) NOT NULL,
  `USER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`PARTNER_CAT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_payme_transaction`
--

DROP TABLE IF EXISTS `d0_payme_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_payme_transaction` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` int NOT NULL,
  `STATUS` int NOT NULL,
  `AMOUNT` decimal(16,2) DEFAULT NULL,
  `TRANS_ID` varchar(255) DEFAULT NULL,
  `TRANS_CREATE_TIME` bigint DEFAULT NULL,
  `TRANS_PERFORM_TIME` bigint DEFAULT NULL,
  `TRANS_CANCEL_TIME` bigint DEFAULT NULL,
  `PAYMENT_ID` varchar(200) DEFAULT NULL,
  `REASON` tinyint DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PAYMENT_ID` (`PAYMENT_ID`),
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `TRANS_ID` (`TRANS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_payment_deliver`
--

DROP TABLE IF EXISTS `d0_payment_deliver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_payment_deliver` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `SALE_POINT` varchar(50) DEFAULT NULL,
  `ORDER_ID` varchar(20) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `CURRENCY` varchar(60) NOT NULL,
  `DATE` datetime NOT NULL,
  `USER_ID` varchar(20) NOT NULL,
  `AGENT_ID` varchar(20) NOT NULL,
  `TERM` datetime NOT NULL,
  `CONFIRM` char(1) NOT NULL DEFAULT '0',
  `COMMENT` text,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `TYPE` int NOT NULL DEFAULT '1',
  `TRADE_ID` int NOT NULL DEFAULT '1',
  `APPROVED_BY` int DEFAULT NULL,
  `SIBL_MSGS` text,
  `REQUEST_ID` text,
  `CREATE_SOURCE` text,
  `UPDATE_SOURCE` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2148 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_payment_displacement`
--

DROP TABLE IF EXISTS `d0_payment_displacement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_payment_displacement` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CL_FROM` varchar(50) NOT NULL,
  `CL_TO` varchar(50) NOT NULL,
  `TRANS_FROM` varchar(50) NOT NULL,
  `TRANS_TO` varchar(50) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `STATUS` tinyint(1) NOT NULL DEFAULT '1',
  `COMMENT` text NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_payment_transfer`
--

DROP TABLE IF EXISTS `d0_payment_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_payment_transfer` (
  `PAYMENT_TRANSFER_ID` int NOT NULL AUTO_INCREMENT,
  `DOCUMENT_ID` int NOT NULL,
  `OPERATION_ID` tinyint NOT NULL,
  `FILIAL_ID` smallint NOT NULL,
  `CURRENCY_ID` varchar(6) NOT NULL,
  `SUMMA` decimal(15,2) NOT NULL,
  `STATUS` tinyint NOT NULL DEFAULT '1',
  `COMMENT` text,
  `REASON` text,
  `CREATE_AT` datetime NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  PRIMARY KEY (`PAYMENT_TRANSFER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_photo_inventory`
--

DROP TABLE IF EXISTS `d0_photo_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_photo_inventory` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `INV_ID` varchar(50) NOT NULL,
  `PHOTO` varchar(500) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_photo_report`
--

DROP TABLE IF EXISTS `d0_photo_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_photo_report` (
  `PR_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(60) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `PARENT` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `CLIENT_CAT_ID` varchar(60) NOT NULL,
  `CITY` varchar(60) NOT NULL,
  `HOST` varchar(255) DEFAULT 'distr',
  `URL` varchar(255) NOT NULL,
  `DATE` datetime NOT NULL,
  `COMMENT` text NOT NULL,
  `STATUS` int NOT NULL DEFAULT '0',
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  `RATING` int DEFAULT '0',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `DELETED` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`PR_ID`),
  KEY `ID` (`ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1573 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_plan`
--

DROP TABLE IF EXISTS `d0_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_plan` (
  `PLAN_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `PLAN` varchar(255) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `PLAN_COMPLETED` varchar(255) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`PLAN_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_plan_product`
--

DROP TABLE IF EXISTS `d0_plan_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_plan_product` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DATE` date NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `REGION_ID` varchar(60) NOT NULL,
  `BRAND_ID` varchar(60) NOT NULL,
  `UNIT` tinyint NOT NULL,
  `VALUE` float NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` varchar(60) DEFAULT '0',
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=111261 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning`
--

DROP TABLE IF EXISTS `d0_planning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL DEFAULT '0',
  `USER_ID` varchar(50) NOT NULL DEFAULT '0',
  `SUMMA` decimal(15,2) NOT NULL DEFAULT '0.00',
  `COUNT` int NOT NULL DEFAULT '0',
  `VOLUME` decimal(9,0) NOT NULL DEFAULT '0',
  `AKB` int NOT NULL DEFAULT '0',
  `STRIKE` int NOT NULL DEFAULT '0',
  `PRODUCT_CAT_ID` varchar(50) NOT NULL DEFAULT '0',
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`),
  KEY `MONTH` (`MONTH`) USING BTREE,
  KEY `YEAR` (`YEAR`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1870 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning_history`
--

DROP TABLE IF EXISTS `d0_planning_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `HISTORY` int NOT NULL DEFAULT '3',
  `YEAR` int NOT NULL,
  `MONTH` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning_min_plan`
--

DROP TABLE IF EXISTS `d0_planning_min_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning_min_plan` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRODUCT_CAT_ID` varchar(50) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `SUMMA_MIN` decimal(15,2) NOT NULL,
  `COUNT_MIN` int NOT NULL,
  `VOLUME_MIN` decimal(9,0) NOT NULL,
  `SUMMA_RATIO` decimal(15,2) NOT NULL,
  `COUNT_RATIO` int NOT NULL,
  `VOLUME_RATIO` decimal(9,0) NOT NULL,
  `PLAN_TYPE` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`),
  KEY `MONTH` (`MONTH`),
  KEY `YEAR` (`YEAR`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning_outlet`
--

DROP TABLE IF EXISTS `d0_planning_outlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning_outlet` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRODUCT_CAT_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `SUMMA` decimal(15,2) NOT NULL,
  `COUNT` int NOT NULL,
  `VOLUME` decimal(9,0) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `idx_year` (`YEAR`),
  KEY `idx_month` (`MONTH`)
) ENGINE=InnoDB AUTO_INCREMENT=759584 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning_percent_day`
--

DROP TABLE IF EXISTS `d0_planning_percent_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning_percent_day` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(32) NOT NULL,
  `DAY` tinyint NOT NULL,
  `PERCENT` decimal(5,2) NOT NULL,
  `MONTH` tinyint NOT NULL,
  `YEAR` int NOT NULL,
  `CREATED_BY` varchar(32) NOT NULL,
  `UPDATED_BY` varchar(32) NOT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_planning_pulse`
--

DROP TABLE IF EXISTS `d0_planning_pulse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_planning_pulse` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `PERCENT` decimal(3,0) DEFAULT NULL,
  `DATE` date NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED_BY` varchar(100) NOT NULL,
  `UPDATED_BY` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3 COMMENT='"Пульс" планирования';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_poll`
--

DROP TABLE IF EXISTS `d0_poll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_poll` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `TEXT` text NOT NULL,
  `USERS` text NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` varchar(255) NOT NULL,
  `TIME` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_poll_question`
--

DROP TABLE IF EXISTS `d0_poll_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_poll_question` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `POLL_ID` int NOT NULL,
  `TEXT` text NOT NULL,
  `TYPE` int NOT NULL,
  `SORT` int NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` varchar(255) NOT NULL,
  `TIME` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `POLL_ID` (`POLL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_poll_result`
--

DROP TABLE IF EXISTS `d0_poll_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_poll_result` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) NOT NULL,
  `CITY_ID` varchar(50) NOT NULL,
  `CLIENT_CAT` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `QUES_ID` int NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  `VALUE_TEXT` varchar(255) NOT NULL,
  `DATE` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `CITY_ID` (`CITY_ID`),
  KEY `CLIENT_CAT` (`CLIENT_CAT`),
  KEY `USER_ID` (`USER_ID`),
  KEY `QUES_ID` (`QUES_ID`),
  KEY `VALUE` (`VALUE`),
  KEY `DATE` (`DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_poll_variant`
--

DROP TABLE IF EXISTS `d0_poll_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_poll_variant` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `TEXT` text NOT NULL,
  `QUES_ID` int NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  `ACTIVE` varchar(255) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `TIME` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `QUES_ID` (`QUES_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_price`
--

DROP TABLE IF EXISTS `d0_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_price` (
  `PRICE_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PRICE_TYPE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `PRODUCT_ID` varchar(60) NOT NULL,
  `PRICE` decimal(16,5) DEFAULT NULL,
  `CONVERSION` float NOT NULL,
  `CONVERSION_TYPE` varchar(60) NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `CODE_DOCUMENT` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`PRICE_ID`),
  KEY `ID` (`ID`),
  KEY `PRICE_TYPE_ID` (`PRICE_TYPE_ID`),
  KEY `PRODUCT_ID` (`PRODUCT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=33713 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_price_change_log`
--

DROP TABLE IF EXISTS `d0_price_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_price_change_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` varchar(100) NOT NULL,
  `price_type_id` varchar(100) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `old_value` varchar(200) DEFAULT NULL,
  `new_value` varchar(200) DEFAULT NULL,
  `time` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_price_log_to_price_type_id_column` (`price_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1829 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_price_type`
--

DROP TABLE IF EXISTS `d0_price_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_price_type` (
  `PRICE_TYPE_ID` varchar(60) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `PARENT` varchar(50) NOT NULL DEFAULT '0',
  `TYPE` varchar(50) NOT NULL,
  `FOR_CLIENT` int DEFAULT NULL,
  `OLD_PRICE_TYPE` varchar(50) NOT NULL,
  `FILIAL` int NOT NULL,
  `DILER` varchar(60) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `SORT` int NOT NULL DEFAULT '500',
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `HAND_EDIT` char(1) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VALYUTA_ID` int DEFAULT NULL,
  `DEALER_PRICE` tinyint NOT NULL DEFAULT '0',
  `MIN_PRICE_TYPE_ID` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PRICE_TYPE_ID`),
  KEY `ID` (`ID`),
  KEY `d0_price_type_MIN_PRICE_TYPE_ID_index` (`MIN_PRICE_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_price_type_filial`
--

DROP TABLE IF EXISTS `d0_price_type_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_price_type_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRICE_TYPE_ID` varchar(60) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_printer`
--

DROP TABLE IF EXISTS `d0_printer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_printer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `URL` varchar(512) NOT NULL,
  `NAME` varchar(256) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `DESCRIPTION` varchar(256) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_printer_attach`
--

DROP TABLE IF EXISTS `d0_printer_attach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_printer_attach` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL,
  `PRINTER_ID` int NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product`
--

DROP TABLE IF EXISTS `d0_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product` (
  `PRODUCT_ID` varchar(60) NOT NULL,
  `TRADE_ID` int NOT NULL DEFAULT '1',
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `NAME` varchar(500) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `VOLUME` decimal(10,6) NOT NULL,
  `PACK_QUANTITY` float NOT NULL,
  `SAP_CODE` varchar(50) NOT NULL,
  `BAR_CODE` varchar(50) NOT NULL,
  `IKPU` varchar(17) DEFAULT NULL,
  `TARA_ID` int NOT NULL DEFAULT '0',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `WEIGHT` float(10,3) NOT NULL,
  `CS_PRODUCT` varchar(50) NOT NULL,
  `CS_ID` int NOT NULL,
  `PRODUCT_GROUP_ID` int NOT NULL,
  `SUB_CAT_ID` int NOT NULL,
  `CASE_TYPE_ID` int DEFAULT NULL,
  `CS_CAT_ID` int NOT NULL DEFAULT '0',
  `IS_MML` varchar(1) NOT NULL DEFAULT 'N',
  `POWER_SKU` tinyint(1) NOT NULL DEFAULT '0',
  `PHOTO` varchar(255) DEFAULT NULL,
  `UNIT_ID` varchar(60) DEFAULT NULL,
  `PACK` int NOT NULL DEFAULT '1',
  `SEGMENT` int NOT NULL DEFAULT '1',
  `BRAND` int NOT NULL DEFAULT '1',
  `PRODUCER` int NOT NULL DEFAULT '1',
  `IS_OUR` varchar(1) NOT NULL DEFAULT 'Y',
  `IS_LOCAL` varchar(1) NOT NULL DEFAULT 'Y',
  `PROPERTY` int NOT NULL DEFAULT '1',
  `PROPERTY1` int NOT NULL DEFAULT '1',
  `PROPERTY2` int NOT NULL DEFAULT '1',
  `BY_BLOCK` varchar(1) NOT NULL DEFAULT 'N',
  `BLOCKS_IN_BOX` int DEFAULT NULL,
  `SHELF_LIFE` int DEFAULT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  `ETTN_CODE` varchar(48) DEFAULT NULL,
  `VAT_RATE` decimal(5,2) DEFAULT NULL,
  `EXCISE_RATE` decimal(8,2) DEFAULT NULL,
  `EXCISE_RATE_TYPE` tinyint DEFAULT NULL COMMENT '0 = fixed, 1 = combined',
  `IKPU_PACK_CODE` varchar(20) DEFAULT NULL,
  `IKPU_UNIT_CODE` varchar(20) DEFAULT NULL,
  `GTIN` varchar(14) DEFAULT NULL,
  `DEMAND_DAYS` int NOT NULL DEFAULT '0',
  `PRODUCTION_CAPACITY` int NOT NULL DEFAULT '0',
  `WIDTH` int DEFAULT NULL,
  `HEIGHT` int DEFAULT NULL,
  `LENGTH` int DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  KEY `ID` (`ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`),
  CONSTRAINT `CHECK_VAT_RATE` CHECK ((`VAT_RATE` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=42682 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_case_type`
--

DROP TABLE IF EXISTS `d0_product_case_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_case_type` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `SHORT` varchar(100) DEFAULT NULL,
  `ACTIVE` varchar(2) NOT NULL DEFAULT 'Y',
  `XML_ID` varchar(255) DEFAULT NULL,
  `UPDATE_BY` varchar(100) DEFAULT NULL,
  `CREATE_BY` varchar(100) NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_AT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_cat_group`
--

DROP TABLE IF EXISTS `d0_product_cat_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_cat_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRODUCT_CAT_ID` text NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `UNIT` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_category`
--

DROP TABLE IF EXISTS `d0_product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_category` (
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `UNIT` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`PRODUCT_CAT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_competitor`
--

DROP TABLE IF EXISTS `d0_product_competitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_competitor` (
  `PRODUCT_ID` varchar(60) NOT NULL,
  `TRADE_ID` int NOT NULL DEFAULT '1',
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `NAME` varchar(500) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `VOLUME` decimal(10,3) NOT NULL,
  `PACK_QUANTITY` float NOT NULL,
  `SAP_CODE` varchar(50) NOT NULL,
  `BAR_CODE` varchar(50) NOT NULL,
  `TARA_ID` int NOT NULL DEFAULT '0',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `WEIGHT` float(10,3) NOT NULL,
  `CS_PRODUCT` varchar(50) NOT NULL,
  `CS_ID` int NOT NULL,
  `CS_CAT_ID` int NOT NULL DEFAULT '0',
  `CS_RATE` int NOT NULL DEFAULT '1',
  `PRODUCT_GROUP_ID` int NOT NULL DEFAULT '1',
  `CASE_TYPE_ID` int DEFAULT NULL,
  `IS_MML` varchar(1) NOT NULL DEFAULT 'N',
  `PHOTO` varchar(255) DEFAULT NULL,
  `UNIT_ID` varchar(60) DEFAULT NULL,
  `PACK` int NOT NULL DEFAULT '1',
  `SEGMENT` int NOT NULL DEFAULT '1',
  `BRAND` int NOT NULL DEFAULT '1',
  `PRODUCER` int NOT NULL DEFAULT '1',
  `IS_LOCAL` varchar(1) NOT NULL DEFAULT 'Y',
  `PROPERTY` int NOT NULL DEFAULT '1',
  `PROPERTY1` int NOT NULL DEFAULT '1',
  `PROPERTY2` int NOT NULL DEFAULT '1',
  `PARAM1` varchar(255) DEFAULT NULL,
  `PARAM2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  KEY `PRODUCT_CAT_ID` (`PRODUCT_CAT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_group`
--

DROP TABLE IF EXISTS `d0_product_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `NAME` varchar(255) NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `CS_ID` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_price_markup`
--

DROP TABLE IF EXISTS `d0_product_price_markup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_price_markup` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PRODUCT` varchar(60) NOT NULL,
  `PRICE_TYPE` varchar(60) NOT NULL,
  `BASE_PRICE_TYPE` varchar(60) NOT NULL,
  `MARKUP` float NOT NULL,
  `ROUND_METHOD` tinyint DEFAULT NULL,
  `ROUND_ACCURACY` float DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_subcategory`
--

DROP TABLE IF EXISTS `d0_product_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_subcategory` (
  `SUB_CAT_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `UNIT` varchar(50) NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`SUB_CAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_unit`
--

DROP TABLE IF EXISTS `d0_product_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_unit` (
  `UNIT_ID` bigint NOT NULL AUTO_INCREMENT,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `UNIT_NAME` varchar(255) DEFAULT NULL,
  `UNIT_CODE` varchar(60) NOT NULL,
  `MULTIPLIER` tinyint NOT NULL,
  `WIDTH_MM` int NOT NULL,
  `LENGTH_MM` int NOT NULL,
  `HEIGHT_MM` int NOT NULL,
  `BARCODE` varchar(255) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`UNIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_units`
--

DROP TABLE IF EXISTS `d0_product_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_units` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `WIDTH_MM` int NOT NULL,
  `LENGTH_MM` int NOT NULL,
  `HEIGHT_MM` int NOT NULL,
  `UNIT_CODE` varchar(60) NOT NULL,
  `MULTIPLIER` int NOT NULL,
  `BARCODE` varchar(255) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  `UPDATE_BY` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_product_values`
--

DROP TABLE IF EXISTS `d0_product_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_product_values` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PROPERTY_ID` int NOT NULL,
  `MODEL_ID` varchar(50) NOT NULL,
  `VALUE` text NOT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_properties`
--

DROP TABLE IF EXISTS `d0_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_properties` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `MODEL` varchar(50) NOT NULL,
  `TYPE` varchar(50) NOT NULL,
  `SORT` int NOT NULL DEFAULT '500',
  `ACTIVE` char(1) NOT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_purchase`
--

DROP TABLE IF EXISTS `d0_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_purchase` (
  `PURCHASE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `FILIAL_ID` varchar(60) NOT NULL,
  `COUNT` decimal(12,3) NOT NULL,
  `PRICE_TYPE` varchar(50) DEFAULT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `DATE_CANCEL` datetime NOT NULL,
  `DATE_STATUS` datetime NOT NULL,
  `STATUS` int NOT NULL,
  `TYPE` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Поступление, 2-Перемещение товаров между филиалами,3-Первичная продажа',
  `DEBT` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `COMMENT` text,
  `CURRENCY` varchar(50) DEFAULT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `SHIPPER_ID` int NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `NUMBER_PARISH` varchar(200) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `EXTRA_EXPENSE` decimal(16,4) DEFAULT NULL,
  PRIMARY KEY (`PURCHASE_ID`),
  KEY `ID` (`ID`),
  KEY `ix_purchase_date` (`PURCHASE_ID`,`DATE`,`TIMESTAMP_X`,`STORE_ID`,`COUNT`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_purchase_detail`
--

DROP TABLE IF EXISTS `d0_purchase_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_purchase_detail` (
  `PURCHASE_DET_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PURCHASE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `PRODUCT` varchar(60) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `PRICE` decimal(16,4) DEFAULT NULL,
  `SELLING_PRICE` decimal(12,2) DEFAULT NULL,
  `SUMMA` decimal(20,4) DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` decimal(12,3) NOT NULL,
  `CURRENCY` varchar(50) DEFAULT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  `UNIT` varchar(50) DEFAULT NULL,
  `UNIT_SYMBOL` varchar(50) DEFAULT NULL,
  `MFG_DATE` date DEFAULT NULL,
  `EXP_DATE` date DEFAULT NULL,
  PRIMARY KEY (`PURCHASE_DET_ID`),
  KEY `ID` (`ID`),
  KEY `PURCHASE_ID` (`PURCHASE_ID`),
  KEY `ix_purchase_detail_pid_prod` (`PURCHASE_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=1754 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_purchase_draft`
--

DROP TABLE IF EXISTS `d0_purchase_draft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_purchase_draft` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `COUNT` double NOT NULL DEFAULT '0',
  `PRICE_TYPE_ID` varchar(50) DEFAULT NULL,
  `SELLING_PRICE_TYPE_ID` varchar(50) DEFAULT NULL,
  `SUMMA` double NOT NULL DEFAULT '0',
  `DATE` datetime DEFAULT NULL,
  `STATUS` int NOT NULL DEFAULT '1',
  `COMMENT` text,
  `CURRENCY_ID` varchar(50) DEFAULT NULL,
  `STORE_ID` varchar(50) DEFAULT NULL,
  `DETAILS` longtext,
  `SHIPPER_ID` int DEFAULT NULL,
  `EXTRA_EXPENSE` double DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_purchase_refund`
--

DROP TABLE IF EXISTS `d0_purchase_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_purchase_refund` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(60) NOT NULL,
  `FILIAL_ID` varchar(60) NOT NULL,
  `COUNT` decimal(12,2) NOT NULL,
  `PRICE_TYPE` varchar(50) DEFAULT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `DATE` datetime NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `DATE_DELIVERED` datetime NOT NULL,
  `DATE_CANCEL` datetime NOT NULL,
  `DATE_STATUS` datetime NOT NULL,
  `STATUS` int NOT NULL,
  `TYPE` tinyint NOT NULL DEFAULT '1' COMMENT '1-Supplier return, 2-Movement of goods between branches',
  `DEBT` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `COMMENT` text NOT NULL,
  `CURRENCY` varchar(50) NOT NULL,
  `CURRENCY_SYMBOL` varchar(50) NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `SHIPPER_ID` int NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `COMM_FOR_RCVR` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`),
  KEY `ix_purchase_refund_status_date` (`STATUS`,`DATE`,`TIMESTAMP_X`,`STORE_ID`,`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_purchase_refund_detail`
--

DROP TABLE IF EXISTS `d0_purchase_refund_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_purchase_refund_detail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PURCHASE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `PRODUCT_CAT` varchar(60) NOT NULL,
  `PRODUCT` varchar(60) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `PRICE` decimal(12,2) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `VOLUME` decimal(12,2) NOT NULL,
  `CURRENCY` varchar(50) DEFAULT NULL,
  `CURRENCY_SYMBOL` varchar(50) DEFAULT NULL,
  `UNIT` varchar(50) DEFAULT NULL,
  `UNIT_SYMBOL` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`),
  KEY `PURCHASE_ID` (`PURCHASE_ID`),
  KEY `ix_purchase_refund_detail_pid_prod` (`PURCHASE_ID`,`PRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_push_subscriptions`
--

DROP TABLE IF EXISTS `d0_push_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_push_subscriptions` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(10) DEFAULT NULL,
  `USER_AGENT` varchar(100) DEFAULT NULL,
  `TECHNOLOGY` varchar(10) DEFAULT NULL,
  `SUBSCRIPTION` varchar(600) DEFAULT NULL,
  `CREATE_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SUBSCRIPTION` (`SUBSCRIPTION`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_question_result`
--

DROP TABLE IF EXISTS `d0_question_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_question_result` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_question_variants`
--

DROP TABLE IF EXISTS `d0_question_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_question_variants` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_questions`
--

DROP TABLE IF EXISTS `d0_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rates`
--

DROP TABLE IF EXISTS `d0_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rates` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `RATED_ID` varchar(60) NOT NULL,
  `ROLE` tinyint NOT NULL,
  `RATE` tinyint NOT NULL,
  `DATE` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rating`
--

DROP TABLE IF EXISTS `d0_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rating` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rating_comment`
--

DROP TABLE IF EXISTS `d0_rating_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rating_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rating_question`
--

DROP TABLE IF EXISTS `d0_rating_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rating_question` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rating_result`
--

DROP TABLE IF EXISTS `d0_rating_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rating_result` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_region`
--

DROP TABLE IF EXISTS `d0_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_region` (
  `REGION_ID` varchar(60) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `USER_ID` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `LAT` float NOT NULL,
  `LON` float NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`REGION_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_reject`
--

DROP TABLE IF EXISTS `d0_reject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_reject` (
  `REJECT_ID` varchar(60) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`REJECT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_reject_client`
--

DROP TABLE IF EXISTS `d0_reject_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_reject_client` (
  `REJECT_CLIENT_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `REJECT_ID` varchar(50) NOT NULL,
  `COMMENT` varchar(500) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`REJECT_CLIENT_ID`),
  KEY `ID` (`ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `REJECT_ID` (`REJECT_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=479 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_reject_defect`
--

DROP TABLE IF EXISTS `d0_reject_defect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_reject_defect` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(250) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_reject_diler`
--

DROP TABLE IF EXISTS `d0_reject_diler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_reject_diler` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_reject_expeditor`
--

DROP TABLE IF EXISTS `d0_reject_expeditor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_reject_expeditor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `REASON_ID` int NOT NULL,
  `DATE` datetime NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rlp`
--

DROP TABLE IF EXISTS `d0_rlp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rlp` (
  `RLP_ID` varchar(60) NOT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `RLP_BONUS_ID` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`RLP_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_rlp_bonus`
--

DROP TABLE IF EXISTS `d0_rlp_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_rlp_bonus` (
  `RLP_BONUS_ID` varchar(60) NOT NULL,
  `NAME` varchar(500) NOT NULL,
  `BONUS` float NOT NULL,
  `PRODUCT_ID` text,
  `SUMMA` int NOT NULL DEFAULT '0',
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(50) NOT NULL,
  `TIMESTAMP_X` datetime NOT NULL,
  `SYNC` varchar(50) NOT NULL,
  `TIME` int NOT NULL,
  `DATE_FROM` date DEFAULT NULL,
  `DATE_TO` date DEFAULT NULL,
  `FILIAL_ID` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`RLP_BONUS_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_royalty`
--

DROP TABLE IF EXISTS `d0_royalty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_royalty` (
  `ROYALTY_ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `ROYALTY_TYPE` int NOT NULL,
  `TYPE` int NOT NULL,
  `MANUAL` char(1) NOT NULL DEFAULT '0',
  `PRODUCT` varchar(10000) NOT NULL,
  `CLIENT_CAT` varchar(1000) NOT NULL,
  `AGENT` varchar(500) NOT NULL,
  `CURRENCY` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MIN_COUNT` decimal(12,3) NOT NULL,
  `MAX_ROYALTY` decimal(10,2) NOT NULL,
  `VALUE` decimal(12,1) NOT NULL,
  `ROYALTY` decimal(12,1) NOT NULL,
  `CITY` varchar(500) NOT NULL,
  `PRICE_TYPE` varchar(500) NOT NULL,
  `IS_PUBLIC` varchar(50) NOT NULL,
  `PARENT` int NOT NULL,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `ACTIVE` varchar(20) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` varchar(50) NOT NULL,
  PRIMARY KEY (`ROYALTY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_royalty_filial`
--

DROP TABLE IF EXISTS `d0_royalty_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_royalty_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ROYALTY_ID` int NOT NULL,
  `FILIAL_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_royalty_transaction`
--

DROP TABLE IF EXISTS `d0_royalty_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_royalty_transaction` (
  `ROYALTY_TRANS_ID` int NOT NULL AUTO_INCREMENT,
  `ROYALTY_ID` int NOT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `STATUS` tinyint NOT NULL,
  `TYPE` char(1) NOT NULL,
  `COUNT` decimal(12,2) NOT NULL,
  `COMMENT` text NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  PRIMARY KEY (`ROYALTY_TRANS_ID`),
  KEY `ROYALTY_ID` (`ROYALTY_ID`),
  KEY `ORDER_ID` (`ORDER_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=816 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sales_category`
--

DROP TABLE IF EXISTS `d0_sales_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sales_category` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(256) NOT NULL,
  `CAT_ID` varchar(256) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(64) NOT NULL,
  `UPDATE_BY` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1282 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_setting_template`
--

DROP TABLE IF EXISTS `d0_setting_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_setting_template` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `KEY` varchar(255) NOT NULL,
  `RESULT` longtext NOT NULL,
  `DESCRIPTION` varchar(256) NOT NULL,
  `USER` varchar(256) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_shipper`
--

DROP TABLE IF EXISTS `d0_shipper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_shipper` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(20) NOT NULL,
  `USER_ID` varchar(20) NOT NULL,
  `FIO` varchar(200) NOT NULL,
  `TEL` varchar(20) NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SORT` int NOT NULL DEFAULT '500',
  `CREATE_DATE` datetime NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `UPDATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `XML_ID` varchar(200) DEFAULT NULL,
  `JWT_SECRET` varchar(255) DEFAULT NULL,
  `SYSTEM_TYPE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_shipper_transaction`
--

DROP TABLE IF EXISTS `d0_shipper_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_shipper_transaction` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(20) NOT NULL,
  `SHIPPER_ID` varchar(20) NOT NULL,
  `CURRENCY_ID` varchar(20) NOT NULL,
  `SUMMA` decimal(16,2) NOT NULL,
  `TYPE` int NOT NULL,
  `DATE` datetime NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `COMMENT` text NOT NULL,
  `PURCHASE_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=406 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka`
--

DROP TABLE IF EXISTS `d0_skidka`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka` (
  `SKIDKA_ID` varchar(50) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `SKIDKA_TYPE` int NOT NULL,
  `PRODUCT` varchar(10000) NOT NULL,
  `CLIENT_CAT` varchar(500) NOT NULL,
  `CURRENCY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CLIENT_TYPE` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_CHANNEL` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY` varchar(255) DEFAULT NULL,
  `VALUE` decimal(12,2) NOT NULL,
  `MAX_VALUE` int NOT NULL DEFAULT '0',
  `SKIDKA` decimal(12,2) NOT NULL,
  `PRICE_TYPE` varchar(500) NOT NULL,
  `IS_PUBLIC` varchar(50) NOT NULL,
  `ONLY_ONE_TIME` tinyint NOT NULL DEFAULT '0' COMMENT '1-Yes, 0-No',
  `N_TYPE` tinyint NOT NULL,
  `N_STATUS` varchar(25) NOT NULL DEFAULT '2,3',
  `N_VALUE` int NOT NULL DEFAULT '1',
  `N_MIN_SUMMA` decimal(20,2) NOT NULL DEFAULT '0.00',
  `PARENT` varchar(50) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `DATE_FROM` datetime NOT NULL,
  `DATE_TO` datetime NOT NULL,
  `BUDGET` decimal(12,2) NOT NULL DEFAULT '0.00',
  `MIN_SKU` int NOT NULL DEFAULT '0',
  `CALC_TYPE` tinyint NOT NULL DEFAULT '0',
  `NUM_CATEGORIES` int DEFAULT '0',
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(20) NOT NULL,
  `SYNC` varchar(20) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` varchar(50) NOT NULL,
  PRIMARY KEY (`SKIDKA_ID`),
  KEY `ID` (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_agent`
--

DROP TABLE IF EXISTS `d0_skidka_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_agent` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKIDKA_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_budget`
--

DROP TABLE IF EXISTS `d0_skidka_budget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_budget` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKIDKA_PARENT` varchar(50) DEFAULT NULL,
  `BUDGET` decimal(14,2) DEFAULT NULL,
  `STATUS` tinyint unsigned NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_exclude`
--

DROP TABLE IF EXISTS `d0_skidka_exclude`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_exclude` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PARENT_ID` varchar(32) NOT NULL,
  `EXCLUDED_SKIDKA_ID` varchar(32) NOT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(32) NOT NULL,
  `UPDATE_BY` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_filial`
--

DROP TABLE IF EXISTS `d0_skidka_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKIDKA_ID` varchar(50) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_manual`
--

DROP TABLE IF EXISTS `d0_skidka_manual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_manual` (
  `SKIDKA_ID` varchar(50) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `SKIDKA` decimal(4,2) NOT NULL,
  `PRODUCT` varchar(10000) NOT NULL,
  `PRICE_TYPE` varchar(10000) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` varchar(20) NOT NULL,
  `SYNC` varchar(20) NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `COMMENT` varchar(50) NOT NULL,
  `AGENT` varchar(512) NOT NULL,
  PRIMARY KEY (`SKIDKA_ID`),
  KEY `ID` (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_manual_agent`
--

DROP TABLE IF EXISTS `d0_skidka_manual_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_manual_agent` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKIDKA_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKIDKA_ID` (`SKIDKA_ID`,`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_manual_filial`
--

DROP TABLE IF EXISTS `d0_skidka_manual_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_manual_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKIDKA_ID` varchar(50) NOT NULL,
  `FILIAL_ID` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_order`
--

DROP TABLE IF EXISTS `d0_skidka_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_order` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `SKIDKA_ID` varchar(50) DEFAULT NULL,
  `SKIDKA_PARENT` varchar(50) DEFAULT NULL,
  `PRODUCT_ID` varchar(50) DEFAULT NULL,
  `COUNT` decimal(14,3) DEFAULT NULL,
  `SUMMA` decimal(16,2) DEFAULT NULL,
  `DISCOUNT` decimal(16,2) DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `UPDATE_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5460 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_relation`
--

DROP TABLE IF EXISTS `d0_skidka_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_relation` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PARENT_ID` varchar(32) NOT NULL,
  `RELATED_SKIDKA_ID` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(32) NOT NULL,
  `UPDATE_BY` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `parentId` (`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_skidka_store`
--

DROP TABLE IF EXISTS `d0_skidka_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_skidka_store` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKIDKA_ID` varchar(20) NOT NULL,
  `STORE_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uc_pair` (`SKIDKA_ID`,`STORE_ID`),
  KEY `idx_skidka_id` (`SKIDKA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sms_message`
--

DROP TABLE IF EXISTS `d0_sms_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sms_message` (
  `id` int NOT NULL AUTO_INCREMENT,
  `template_id` int NOT NULL,
  `sms_count` int NOT NULL,
  `client_count` int NOT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'waiting' COMMENT 'waiting, sent, draft',
  `created_by` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_template_id` (`template_id`),
  CONSTRAINT `d0_sms_message_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `d0_sms_template` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sms_message_item`
--

DROP TABLE IF EXISTS `d0_sms_message_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sms_message_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message_id` int NOT NULL,
  `phone` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'waiting',
  `client_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sms_pending`
--

DROP TABLE IF EXISTS `d0_sms_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sms_pending` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(200) NOT NULL,
  `USER_TYPE` varchar(100) NOT NULL DEFAULT 'client',
  `TEMPLATE` varchar(100) NOT NULL,
  `STATE` varchar(50) NOT NULL DEFAULT 'draft',
  `NAME` varchar(255) NOT NULL,
  `PHONE` varchar(50) NOT NULL,
  `TEXT` text NOT NULL,
  `DATE` date NOT NULL,
  `UPDATED_BY` varchar(200) DEFAULT NULL,
  `CREATED_BY` varchar(200) NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sms_template`
--

DROP TABLE IF EXISTS `d0_sms_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sms_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `type` varchar(100) NOT NULL COMMENT 'debt, payment, notification',
  `template` text NOT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'moderation' COMMENT 'default, moderation, ready',
  `template_id` int DEFAULT NULL COMMENT 'eskiz template id',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_stock_exp`
--

DROP TABLE IF EXISTS `d0_stock_exp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_stock_exp` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store`
--

DROP TABLE IF EXISTS `d0_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store` (
  `STORE_ID` varchar(60) NOT NULL,
  `STORE_TYPE` tinyint NOT NULL DEFAULT '0',
  `DILER_ID` varchar(60) NOT NULL,
  `COUNT` int NOT NULL,
  `TIMESTAMP_X` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `FILTER` char(1) DEFAULT '1',
  `VAN_SELLING` tinyint NOT NULL DEFAULT '0' COMMENT '1-van-selling, 0-not van selling',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `NAME` varchar(1000) NOT NULL,
  `XML_ID` varchar(100) NOT NULL,
  `STOCKMAN` varchar(20) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `NEGATIVE_COUNT` char(1) NOT NULL DEFAULT '0',
  `ETTN_CODE` varchar(48) DEFAULT NULL,
  `SORT_ORDER` int NOT NULL DEFAULT '500',
  `DISABLE_STOCK_CHECK` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`STORE_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store_corrector`
--

DROP TABLE IF EXISTS `d0_store_corrector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store_corrector` (
  `CORRECTOR_ID` varchar(50) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `COMMENT` text NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `PARENT` varchar(50) NOT NULL,
  `COUNT` decimal(16,4) DEFAULT NULL,
  `STORE_ID` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `DATE` datetime NOT NULL,
  `PRICE` decimal(10,2) NOT NULL DEFAULT '0.00',
  `TYPE` char(1) NOT NULL,
  `ARMOR` decimal(12,3) NOT NULL,
  `AVAILABLE` decimal(12,3) NOT NULL,
  `FACT` decimal(12,3) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `XML_ID` varchar(250) DEFAULT NULL,
  `MFG_DATE` date DEFAULT NULL,
  `EXP_DATE` date DEFAULT NULL,
  `effective_date` datetime GENERATED ALWAYS AS ((case when (`DATE` = _utf8mb4'0000-00-00 00:00:00') then `TIMESTAMP_X` else `DATE` end)) STORED,
  PRIMARY KEY (`CORRECTOR_ID`),
  KEY `ID` (`ID`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `ix_store_corrector_effective` (`PRODUCT_ID`,`STORE_ID`,`effective_date`,`TIMESTAMP_X`,`CORRECTOR_ID`),
  KEY `ix_store_corrector_prod_store_date` (`PRODUCT_ID`,`STORE_ID`,`DATE`,`TIMESTAMP_X`,`CORRECTOR_ID`,`COUNT`)
) ENGINE=InnoDB AUTO_INCREMENT=2012 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store_detail`
--

DROP TABLE IF EXISTS `d0_store_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store_detail` (
  `STORE_DETAIL_ID` varchar(60) NOT NULL,
  `STORE_ID` varchar(60) NOT NULL,
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `COUNT` decimal(20,4) DEFAULT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`STORE_DETAIL_ID`),
  KEY `ID` (`ID`),
  KEY `STORE_ID` (`STORE_ID`),
  KEY `PRODUCT_ID` (`PRODUCT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=68111 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store_history`
--

DROP TABLE IF EXISTS `d0_store_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store_history` (
  `STORE_HIS_ID` int NOT NULL AUTO_INCREMENT,
  `STORE_ID` varchar(60) NOT NULL,
  `RESULT` text NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`STORE_HIS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store_log`
--

DROP TABLE IF EXISTS `d0_store_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MODEL` varchar(50) NOT NULL,
  `MODEL_ID` varchar(50) NOT NULL,
  `STORE_ID` varchar(50) NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `COUNT` decimal(20,4) DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DATE_LOAD` datetime NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ModelModelId` (`MODEL`(20),`MODEL_ID`(18)),
  KEY `PRODUCT_ID` (`PRODUCT_ID`),
  KEY `STORE_ID` (`STORE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=43705 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_store_stats`
--

DROP TABLE IF EXISTS `d0_store_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_store_stats` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DATE` date NOT NULL,
  `PRODUCT` varchar(50) NOT NULL,
  `OUTGO_SYSTEM` float(8,0) NOT NULL,
  `OUTGO_HAND` float(8,0) NOT NULL,
  `AFTER_SHIP_HAND` float(8,0) NOT NULL,
  `RETURN_HAND` float(8,0) NOT NULL,
  `INCOME_HAND` float(8,0) NOT NULL,
  `FIN_VALUE` float(8,0) NOT NULL,
  `STORE` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `COMMENT` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_structure_filial`
--

DROP TABLE IF EXISTS `d0_structure_filial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_structure_filial` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(50) DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `FILIAL` int DEFAULT NULL,
  `PARENT` int DEFAULT NULL,
  `ROLE` tinyint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_supervayzer`
--

DROP TABLE IF EXISTS `d0_supervayzer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_supervayzer` (
  `SV_AGENT_ID` varchar(60) NOT NULL,
  `USER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `POSITION_ID` int DEFAULT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`SV_AGENT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=819 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sync`
--

DROP TABLE IF EXISTS `d0_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sync` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(200) NOT NULL,
  `TIME` bigint NOT NULL,
  `TABLE` varchar(50) NOT NULL,
  `STATUS` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sync_log`
--

DROP TABLE IF EXISTS `d0_sync_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sync_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(60) DEFAULT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `MOBILE_ORDER_ID` varchar(40) DEFAULT NULL,
  `TYPE` varchar(60) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL,
  `VERIFY_STATUS` int DEFAULT NULL COMMENT '1-waiting to verify\r\n2-verivied (confirmed)\r\n3-rejected\r\n4-recorrect',
  `VERIFY_COMMENT` varchar(512) DEFAULT NULL,
  `CONTENT` text,
  `DEVICE_TOKEN` varchar(200) DEFAULT NULL,
  `DAY` date NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `syncUnic` (`MOBILE_ORDER_ID`,`DEVICE_TOKEN`,`DAY`),
  KEY `MOBILE_ORDER_ID` (`MOBILE_ORDER_ID`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6864 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_sync_log_delete`
--

DROP TABLE IF EXISTS `d0_sync_log_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_sync_log_delete` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(60) NOT NULL DEFAULT 'd0_1',
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(60) DEFAULT NULL,
  `ORDER_ID` varchar(50) NOT NULL,
  `MOBILE_ORDER_ID` varchar(40) DEFAULT NULL,
  `TYPE` varchar(60) DEFAULT NULL,
  `STATUS` varchar(50) NOT NULL,
  `VERIFY_STATUS` int DEFAULT NULL COMMENT '1-waiting to verify\r\n2-verivied (confirmed)\r\n3-rejected\r\n4-recorrect',
  `VERIFY_COMMENT` varchar(512) DEFAULT NULL,
  `CONTENT` text,
  `DEVICE_TOKEN` varchar(200) DEFAULT NULL,
  `DAY` date NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `syncUnic` (`MOBILE_ORDER_ID`,`DEVICE_TOKEN`,`DAY`),
  KEY `MOBILE_ORDER_ID` (`MOBILE_ORDER_ID`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_system_log`
--

DROP TABLE IF EXISTS `d0_system_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_system_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(20) NOT NULL,
  `MODEL_NAME` varchar(60) NOT NULL,
  `MODEL_ID` varchar(20) NOT NULL,
  `DATE` datetime NOT NULL,
  `CONTENT` text NOT NULL,
  `ACTION` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=42413 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tableControl`
--

DROP TABLE IF EXISTS `d0_tableControl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tableControl` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(50) NOT NULL,
  `PAGE` varchar(500) NOT NULL,
  `SETTINGS` text NOT NULL,
  `ORDER_HEADER` text,
  `TIME` datetime NOT NULL,
  `ACTIVE` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_table_config`
--

DROP TABLE IF EXISTS `d0_table_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_table_config` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CATEGORY` varchar(250) NOT NULL,
  `GROUP` varchar(250) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `ACTIVE` tinyint NOT NULL,
  `FILTER` tinyint DEFAULT NULL,
  `USER` varchar(50) NOT NULL,
  `ORDER` int NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tags`
--

DROP TABLE IF EXISTS `d0_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tags` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `TYPE` tinyint NOT NULL DEFAULT '0',
  `ACTIVE` tinyint(1) NOT NULL DEFAULT '1',
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED_AT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tara`
--

DROP TABLE IF EXISTS `d0_tara`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tara` (
  `TARA_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(500) DEFAULT NULL,
  `SORT` int DEFAULT NULL,
  `DATE_CREATE` timestamp NULL DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `DATE_UPDATE` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TARA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tara_client`
--

DROP TABLE IF EXISTS `d0_tara_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tara_client` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) DEFAULT NULL,
  `AGENT` varchar(50) DEFAULT NULL,
  `TARA_ID` int unsigned DEFAULT NULL,
  `COUNT` int DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `DATE_LOAD` datetime DEFAULT NULL,
  `TYPE` int DEFAULT NULL,
  `STATUS` int DEFAULT NULL,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(50) DEFAULT NULL,
  `CREATE_DATE` timestamp NULL DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_DATE` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`) USING BTREE,
  KEY `TARA_ID` (`TARA_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3648 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tara_document`
--

DROP TABLE IF EXISTS `d0_tara_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tara_document` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TRANS_TYPE` int NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `ORDER_ID` varchar(50) DEFAULT NULL,
  `AGENT_ID` varchar(50) DEFAULT NULL,
  `EXPEDITOR_ID` varchar(50) DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `DATE_LOAD` datetime NOT NULL,
  `COMMENT` text,
  `CREATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2976 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tara_document_detail`
--

DROP TABLE IF EXISTS `d0_tara_document_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tara_document_detail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `OWNER_ID` varchar(50) NOT NULL,
  `OWNER_TYPE` int NOT NULL,
  `TARA_DOC_ID` int NOT NULL,
  `TARA_ID` int NOT NULL,
  `COUNT` int NOT NULL,
  `CREATE_AT` timestamp NULL DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `UPDATE_AT` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8005 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_target_akb`
--

DROP TABLE IF EXISTS `d0_target_akb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_target_akb` (
  `AKB_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `OKB` int NOT NULL,
  `PLAN_AKB` int NOT NULL,
  `FACT_AKB` int NOT NULL,
  `FACT_INDEX` float(4,2) NOT NULL,
  `PRODUCT_CATEGORY` varchar(60) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `USER_TYPE` int NOT NULL,
  `TYPE` int NOT NULL,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`AKB_ID`),
  KEY `ID` (`ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_target_coverage`
--

DROP TABLE IF EXISTS `d0_target_coverage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_target_coverage` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_target_sku`
--

DROP TABLE IF EXISTS `d0_target_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_target_sku` (
  `SKU_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `OKB` int unsigned NOT NULL,
  `PLAN_AKB` int unsigned NOT NULL,
  `PLAN_SKU` int NOT NULL,
  `FACT_SKU` float(6,4) NOT NULL,
  `FACT_STRIKE` float(6,4) NOT NULL,
  `FACT_AKB` float(6,4) NOT NULL,
  `FACT_OKB` float(6,4) NOT NULL,
  `FACT_INDEX` float(6,4) NOT NULL,
  `PRODUCT_CATEGORY` varchar(60) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `USER_TYPE` int NOT NULL,
  `TYPE` int NOT NULL,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`SKU_ID`),
  KEY `ID` (`ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_target_strike`
--

DROP TABLE IF EXISTS `d0_target_strike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_target_strike` (
  `ORDER_VOL_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `SHARE_IN_FACT` float(8,8) NOT NULL,
  `SHARE_IN_VOLUME` float(8,8) NOT NULL,
  `ORDER_PLAN` float(12,3) NOT NULL,
  `PRODUCT_CATEGORY` varchar(60) NOT NULL,
  `FACT` float(12,3) NOT NULL,
  `FACT_INDEX` float(4,2) NOT NULL,
  `VOLUME_MONTH` float(12,3) NOT NULL,
  `STRIKE_DAYS` int NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `USER_TYPE` int NOT NULL,
  `TYPE` int NOT NULL,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`ORDER_VOL_ID`),
  KEY `ID` (`ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_target_volume`
--

DROP TABLE IF EXISTS `d0_target_volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_target_volume` (
  `TAR_VOL_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(60) NOT NULL,
  `SHARE_IN_FACT` float(8,8) NOT NULL,
  `SHARE_IN_TARGET` float(8,8) NOT NULL,
  `TARGET_PLAN` float(12,3) NOT NULL,
  `PRODUCT_CATEGORY` varchar(60) NOT NULL,
  `FACT` float(12,3) NOT NULL,
  `FACT_INDEX` float(4,2) NOT NULL,
  `MONTH` int NOT NULL,
  `YEAR` int NOT NULL,
  `USER_TYPE` int NOT NULL,
  `TYPE` int NOT NULL,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`TAR_VOL_ID`),
  KEY `ID` (`ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `MONTH` (`MONTH`)
) ENGINE=InnoDB AUTO_INCREMENT=443 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_task_log`
--

DROP TABLE IF EXISTS `d0_task_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_task_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `OLD_VALUE` varchar(500) DEFAULT NULL,
  `NEW_VALUE` varchar(500) DEFAULT NULL,
  `ATTRIBUTE` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=460 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_task_type`
--

DROP TABLE IF EXISTS `d0_task_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_task_type` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) NOT NULL,
  `CATEGORY` varchar(24) NOT NULL DEFAULT 'other',
  `SORT` int NOT NULL,
  `ACTIVE` char(1) NOT NULL,
  `CTEATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tasks`
--

DROP TABLE IF EXISTS `d0_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tasks` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` text NOT NULL,
  `TYPE_ID` int DEFAULT NULL,
  `TASK_FROM` varchar(60) NOT NULL,
  `TASK_TO` varchar(60) NOT NULL,
  `DATE_CREATE` datetime NOT NULL,
  `DATE_DO` datetime DEFAULT NULL,
  `CLIENT_ID` varchar(60) NOT NULL,
  `IMAGE` varchar(500) DEFAULT NULL,
  `IMAGE_RESULT` varchar(500) DEFAULT NULL,
  `PR_ID` int NOT NULL,
  `COMMENT` text NOT NULL,
  `STATUS` int NOT NULL,
  `CONFIRM` char(1) NOT NULL,
  `COLOR` varchar(20) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `UPDATED_BY` varchar(60) DEFAULT NULL,
  `RATE` tinyint DEFAULT NULL,
  `COMMENT_R` text,
  `P_LAT` float DEFAULT NULL,
  `P_LON` float DEFAULT NULL,
  `IS_REQUIRED` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `TASK_FROM` (`TASK_FROM`),
  KEY `TASK_TO` (`TASK_TO`),
  KEY `CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=454 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tasks_status_log`
--

DROP TABLE IF EXISTS `d0_tasks_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tasks_status_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TASK_ID` int NOT NULL,
  `OLD_STATUS` int DEFAULT NULL,
  `NEW_STATUS` int NOT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_BY` varchar(60) NOT NULL,
  `COMMENT` text,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=445 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_telegram_function`
--

DROP TABLE IF EXISTS `d0_telegram_function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_telegram_function` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TG_GR_ID` int NOT NULL,
  `REPORT_ID` int NOT NULL,
  `PARAMS` text NOT NULL,
  `TYPE` int NOT NULL,
  `TIME` int NOT NULL,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TEMPLATE_ID` int NOT NULL DEFAULT '1',
  `TG_GR_TP_ID` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_telegram_group`
--

DROP TABLE IF EXISTS `d0_telegram_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_telegram_group` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(256) NOT NULL,
  `CHAT_ID` bigint NOT NULL,
  `NICKNAME` varchar(64) NOT NULL,
  `ACTIVE` varchar(1) NOT NULL DEFAULT 'Y',
  `TYPE` varchar(64) DEFAULT NULL,
  `HAS_TOPICS` tinyint(1) NOT NULL DEFAULT '0',
  `TG_BOT_ID` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_telegram_group_topic`
--

DROP TABLE IF EXISTS `d0_telegram_group_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_telegram_group_topic` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `THREAD_ID` bigint NOT NULL,
  `GROUP_ID` bigint NOT NULL,
  `NAME` varchar(50) NOT NULL,
  `COLOR` varchar(6) DEFAULT NULL,
  `ACTIVE` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_telegram_report`
--

DROP TABLE IF EXISTS `d0_telegram_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_telegram_report` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(256) NOT NULL,
  `FUNCTION` varchar(128) NOT NULL,
  `TYPE` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_telegram_sent_messages`
--

DROP TABLE IF EXISTS `d0_telegram_sent_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_telegram_sent_messages` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MESSAGE_ID` bigint NOT NULL,
  `CHAT_ID` bigint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_bot`
--

DROP TABLE IF EXISTS `d0_tg_bot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_bot` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) DEFAULT NULL,
  `TOKEN` varchar(200) DEFAULT NULL,
  `VERIFIED` char(1) DEFAULT 'N',
  `WEBHOOK` varchar(200) DEFAULT NULL,
  `NIK` varchar(200) DEFAULT NULL,
  `TYPE` varchar(50) NOT NULL,
  `PRICE_TYPE_ID` varchar(60) DEFAULT NULL,
  `CASHBOX_ID` int NOT NULL DEFAULT '1',
  `STORE_ID` varchar(60) DEFAULT NULL,
  `GROUP_ID` text,
  `OPTIONS` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_package`
--

DROP TABLE IF EXISTS `d0_tg_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_package` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(256) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_package_contact`
--

DROP TABLE IF EXISTS `d0_tg_package_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_package_contact` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CONTACT_ID` int NOT NULL,
  `PACK_ID` int NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_package_product`
--

DROP TABLE IF EXISTS `d0_tg_package_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_package_product` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PACK_ID` int NOT NULL,
  `PRODUCT_ID` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_regular`
--

DROP TABLE IF EXISTS `d0_tg_regular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_regular` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `REPORT_ID` int unsigned DEFAULT NULL,
  `USER_ID` varchar(50) DEFAULT NULL,
  `TIME` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_report`
--

DROP TABLE IF EXISTS `d0_tg_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_report` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(200) DEFAULT NULL,
  `DESCRIPTION` varchar(500) DEFAULT NULL,
  `COMMAND` varchar(200) DEFAULT NULL,
  `ROOT` varchar(200) DEFAULT NULL,
  `ARGS` varchar(500) DEFAULT NULL,
  `TYPE` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_tg_user_report`
--

DROP TABLE IF EXISTS `d0_tg_user_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_tg_user_report` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(50) DEFAULT NULL,
  `REPORT_ID` int unsigned DEFAULT NULL,
  `ARGS` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_trade_direction`
--

DROP TABLE IF EXISTS `d0_trade_direction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_trade_direction` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(256) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(64) NOT NULL,
  `UPDATE_BY` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_transaction_closed`
--

DROP TABLE IF EXISTS `d0_transaction_closed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_transaction_closed` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TR_FROM` varchar(20) NOT NULL,
  `TR_TO` varchar(20) NOT NULL,
  `SUMMA` decimal(16,2) NOT NULL,
  `DATE` datetime NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(20) NOT NULL,
  `UPDATE_BY` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3977 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_transaction_log`
--

DROP TABLE IF EXISTS `d0_transaction_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_transaction_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TR_ID` varchar(50) NOT NULL,
  `SUMMA` decimal(12,2) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(40) NOT NULL,
  `UPDATE_BY` varchar(40) NOT NULL,
  `DATE` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_units`
--

DROP TABLE IF EXISTS `d0_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_units` (
  `UNIT_ID` varchar(60) NOT NULL,
  `NAME` varchar(250) NOT NULL,
  `CODE` varchar(250) NOT NULL,
  `CSS_CLASS` varchar(250) NOT NULL,
  `TITLE` varchar(250) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `ETTN_CODE` varchar(7) NOT NULL DEFAULT '796',
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`UNIT_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_user`
--

DROP TABLE IF EXISTS `d0_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_user` (
  `USER_ID` varchar(60) NOT NULL,
  `NAME` varchar(200) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `CHAT_ID` varchar(50) DEFAULT NULL,
  `TEL` varchar(20) DEFAULT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `AGENT_ID` varchar(60) NOT NULL,
  `ROLE` int NOT NULL,
  `LOGIN` varchar(50) NOT NULL,
  `PASSWORD` varchar(200) NOT NULL,
  `CODE` int NOT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `XML_ID` varchar(50) NOT NULL,
  `PAY` tinyint NOT NULL DEFAULT '0' COMMENT 'supervayser va dostavchik \n 1 - pul tulaydi \n 0 - pul tulamay ishlatadi',
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `DEVICE_TOKEN` varchar(1000) NOT NULL,
  `FCM_TOKEN` varchar(500) DEFAULT NULL,
  `TIME` bigint NOT NULL,
  `APP_VERSION` varchar(20) DEFAULT NULL,
  `DEVICE_MODEL` varchar(100) DEFAULT NULL,
  `LAST_SYNC_TIME` datetime DEFAULT NULL,
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `LOGIN` (`LOGIN`),
  KEY `ID` (`ID`),
  KEY `AGENT_ID` (`AGENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=754 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_valyuta`
--

DROP TABLE IF EXISTS `d0_valyuta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_valyuta` (
  `VALYUTA_ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(250) NOT NULL,
  `CODE` varchar(250) NOT NULL,
  `XML_ID` varchar(50) NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL,
  `SYNC` char(1) NOT NULL,
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`VALYUTA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visit`
--

DROP TABLE IF EXISTS `d0_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AGENT_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `CLIENT_ID` varchar(50) NOT NULL,
  `POSITION_ID` int DEFAULT NULL,
  `ROLE` int DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `VISITED` char(1) NOT NULL DEFAULT '0',
  `ORDER` char(1) NOT NULL DEFAULT '0',
  `REJECT` char(1) NOT NULL DEFAULT '0',
  `PHOTO` char(1) NOT NULL DEFAULT '0',
  `AUDIT` char(1) NOT NULL DEFAULT '0',
  `LON` decimal(9,6) DEFAULT NULL,
  `LAT` decimal(9,6) DEFAULT NULL,
  `DISTANCE` int DEFAULT NULL COMMENT 'Distance (meter) to client location',
  `GPS_STATUS` int DEFAULT NULL COMMENT '1-client location null\r\n2-visit location null\r\n3-visit/client location null\r\n4-client location updated',
  `CHECK_IN_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CHECK_OUT_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `PLANED` char(1) NOT NULL DEFAULT '1',
  `STORE_CHECK` char(1) NOT NULL,
  `PAYMENT` char(1) NOT NULL,
  `DELIVERY` char(1) NOT NULL,
  `POLL` char(1) NOT NULL,
  `ORDER_REPLACE` char(1) NOT NULL,
  `ORDER_DEFECT` char(1) NOT NULL,
  `SYNC_TIME` datetime NOT NULL,
  `DAY` int NOT NULL,
  `FIRST_VISIT` char(1) DEFAULT '0',
  PRIMARY KEY (`ID`,`DATE`),
  UNIQUE KEY `uniqueClientUserDate` (`CLIENT_ID`(8),`USER_ID`(8),`DATE`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `DATE` (`DATE`),
  KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28962 DEFAULT CHARSET=utf8mb3
/*!50100 PARTITION BY RANGE (year(`DATE`))
(PARTITION pd_2021 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION pd_2022 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION pd_2023 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION pd_2024 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION pd_2025 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION pd_2026 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION pd_max VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visit_exp`
--

DROP TABLE IF EXISTS `d0_visit_exp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visit_exp` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `EXP_ID` varchar(60) NOT NULL,
  `USER_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `MAIN` char(1) NOT NULL DEFAULT '0',
  `CREATE_BY` varchar(60) NOT NULL,
  `UPDATE_BY` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `SOURCE` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1274 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visiting`
--

DROP TABLE IF EXISTS `d0_visiting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visiting` (
  `VISIT_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(50) NOT NULL,
  `DAY` varchar(5) NOT NULL,
  `SORT` float NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AGENT_ID` varchar(60) NOT NULL,
  `ID` int NOT NULL,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_AT` datetime NOT NULL,
  `TIME` bigint NOT NULL,
  `WEEK_TYPE` char(1) NOT NULL DEFAULT '0',
  `WEEK_POSITION` tinyint NOT NULL DEFAULT '0',
  `MONTH_TYPE` char(1) NOT NULL DEFAULT '0',
  `SOURCE` text,
  PRIMARY KEY (`VISIT_ID`),
  KEY `ID` (`ID`),
  KEY `CLIENT_ID` (`CLIENT_ID`),
  KEY `AGENT_ID` (`AGENT_ID`),
  KEY `DAY` (`DAY`)
) ENGINE=InnoDB AUTO_INCREMENT=72939 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visiting_aud`
--

DROP TABLE IF EXISTS `d0_visiting_aud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visiting_aud` (
  `VISIT_ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(60) NOT NULL,
  `DAY` varchar(5) NOT NULL,
  `FILIAL_ID` int DEFAULT NULL,
  `AUDITOR_ID` int NOT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `WEEK_TYPE` char(1) NOT NULL DEFAULT '0',
  `SOURCE` text,
  PRIMARY KEY (`VISIT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5300 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visiting_history`
--

DROP TABLE IF EXISTS `d0_visiting_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visiting_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `VISITOR_ID` varchar(50) NOT NULL COMMENT 'agent/auditor',
  `VISITOR_TYPE` tinyint NOT NULL COMMENT '1 = Agent, 2 = Auditor, 3 = Expediter',
  `CLIENT_ID` varchar(50) NOT NULL,
  `DAY` tinyint NOT NULL,
  `ACTION` tinyint NOT NULL COMMENT '1 = Update, 2 = Delete',
  `SOURCE` text NOT NULL,
  `CREATE_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATE_BY` varchar(50) NOT NULL,
  `IP_ADDRESS` varchar(45) NOT NULL,
  `USER_AGENT` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13038 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_visiting_month`
--

DROP TABLE IF EXISTS `d0_visiting_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_visiting_month` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CLIENT_ID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AGENT_ID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MONTH` int DEFAULT NULL,
  `DAY` int DEFAULT NULL,
  `CREATE_AT` datetime DEFAULT NULL,
  `CREATE_BY` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SOURCE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=914 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_vs_exchange`
--

DROP TABLE IF EXISTS `d0_vs_exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_vs_exchange` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `COUNT` decimal(16,3) NOT NULL DEFAULT '0.000',
  `AMOUNT` decimal(12,2) NOT NULL DEFAULT '0.00',
  `STATUS` tinyint NOT NULL,
  `FROM_STORE_ID` varchar(50) DEFAULT NULL,
  `TO_STORE_ID` varchar(50) DEFAULT NULL,
  `AGENT_ID` varchar(100) DEFAULT NULL,
  `PRICE_TYPE_ID` varchar(200) DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `DATE_LOAD` datetime DEFAULT NULL,
  `COMMENT` text,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `XML_ID` varchar(200) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_vs_exchange_details`
--

DROP TABLE IF EXISTS `d0_vs_exchange_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_vs_exchange_details` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `VS_EXCHANGE_ID` bigint NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `COUNT` decimal(16,3) NOT NULL,
  `PRICE` decimal(12,2) DEFAULT NULL,
  `AMOUNT` decimal(12,2) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=404 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_vs_return`
--

DROP TABLE IF EXISTS `d0_vs_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_vs_return` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `COUNT` decimal(16,3) NOT NULL DEFAULT '0.000',
  `AMOUNT` decimal(12,2) NOT NULL DEFAULT '0.00',
  `STATUS` tinyint NOT NULL,
  `AGENT_ID` varchar(100) NOT NULL,
  `PRICE_TYPE_ID` varchar(200) DEFAULT NULL,
  `FROM_STORE_ID` varchar(50) DEFAULT NULL,
  `TO_STORE_ID` varchar(50) DEFAULT NULL,
  `DATE` datetime NOT NULL,
  `DATE_RETURN` datetime DEFAULT NULL,
  `COMMENT` text,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_vs_return_details`
--

DROP TABLE IF EXISTS `d0_vs_return_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_vs_return_details` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `VS_RETURN_ID` bigint NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `COUNT` decimal(16,3) NOT NULL,
  `PRICE` decimal(12,2) DEFAULT NULL,
  `AMOUNT` decimal(12,2) DEFAULT NULL,
  `CREATE_BY` varchar(50) NOT NULL,
  `UPDATE_BY` varchar(50) DEFAULT NULL,
  `CREATE_AT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_warehouse`
--

DROP TABLE IF EXISTS `d0_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_warehouse` (
  `WAREHOUSE_ID` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `TYPE` varchar(60) DEFAULT NULL,
  `IDEN` varchar(60) DEFAULT NULL,
  `COUNT` int NOT NULL,
  `TYPE_LIMIT` int NOT NULL DEFAULT '1',
  `CONDITION` varchar(250) DEFAULT NULL,
  `COMMENT` text,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  `TIMESTAMP_X` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `NAME` varchar(250) NOT NULL,
  PRIMARY KEY (`WAREHOUSE_ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_warehouse_detail`
--

DROP TABLE IF EXISTS `d0_warehouse_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_warehouse_detail` (
  `WAREHOUSE_DETAIL_ID` varchar(60) NOT NULL,
  `WAREHOUSE_ID` varchar(60) NOT NULL,
  `COUNT` int NOT NULL,
  `PRODUCT_CAT_ID` varchar(60) NOT NULL,
  `PRODUCT_ID` varchar(60) NOT NULL,
  `TYPE` varchar(60) NOT NULL,
  `STORE_ID` varchar(1000) NOT NULL,
  `IDEN` varchar(60) NOT NULL,
  `DILER_ID` varchar(60) NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ACTIVE` char(1) NOT NULL DEFAULT 'Y',
  `SYNC` char(1) NOT NULL DEFAULT 'N',
  `TIME` bigint NOT NULL,
  PRIMARY KEY (`WAREHOUSE_DETAIL_ID`),
  KEY `ID` (`ID`),
  KEY `WAREHOUSE_ID` (`WAREHOUSE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_warehouse_location`
--

DROP TABLE IF EXISTS `d0_warehouse_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_warehouse_location` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `STORE_ID` varchar(20) NOT NULL,
  `PRODUCT_ID` varchar(20) NOT NULL,
  `LOCATION` varchar(30) NOT NULL,
  `CREATE_BY` varchar(30) NOT NULL,
  `CREATE_AT` datetime NOT NULL,
  `UPDATE_BY` varchar(30) DEFAULT NULL,
  `UPDATE_AT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uc_pair` (`STORE_ID`,`PRODUCT_ID`),
  KEY `idx_store_id` (`STORE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d0_working_days`
--

DROP TABLE IF EXISTS `d0_working_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `d0_working_days` (
  `WORKING_DAY_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `DILER_ID` varchar(50) NOT NULL,
  `YEAR` int NOT NULL,
  `MONTH` int NOT NULL,
  `DAY` int NOT NULL,
  `TIMESTAMP_X` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `ID` int NOT NULL,
  `ACTIVE` varchar(20) NOT NULL,
  `SYNC` varchar(20) NOT NULL,
  `TIME` int NOT NULL,
  PRIMARY KEY (`WORKING_DAY_ID`),
  KEY `ID` (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1118 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_migration`
--

DROP TABLE IF EXISTS `tbl_migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_migration` (
  `version` varchar(255) NOT NULL,
  `apply_time` int DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'sd_main'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-08  6:10:03
