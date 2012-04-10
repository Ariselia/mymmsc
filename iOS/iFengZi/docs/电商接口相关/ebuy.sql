/*
MySQL Data Transfer
Source Host: localhost
Source Database: ebuy
Target Host: localhost
Target Database: ebuy
Date: 2012/1/17 14:04:16
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for info_news
-- ----------------------------
CREATE TABLE `info_news` (
  `INFO_NEWS_GUID` varchar(36) NOT NULL,
  `INFO_NEWS_ID` varchar(40) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `NEWS_TITLE` varchar(100) NOT NULL,
  `NEWS_PIC` varchar(100) DEFAULT NULL,
  `NEWS_CONTENT` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`INFO_NEWS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for item_e
-- ----------------------------
CREATE TABLE `item_e` (
  `ITEM_E_GUID` varchar(36) NOT NULL,
  `ITEM_E_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `ITEM_GUID` varchar(36) NOT NULL,
  `ORDER_ITEM_GUID` varchar(36) NOT NULL,
  `ORDER_GUID` varchar(36) DEFAULT NULL,
  `E_CONTENT` varchar(2000) DEFAULT NULL,
  `E_GRADE` int(11) DEFAULT NULL,
  `E_LOVE` int(11) DEFAULT NULL,
  `PICURL` varchar(100) DEFAULT NULL,
  `IS_EVALUATE` int(11) DEFAULT NULL,
  `NICK_NAME` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`ITEM_E_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for item_group
-- ----------------------------
CREATE TABLE `item_group` (
  `ITEM_GROUP_GUID` varchar(36) NOT NULL,
  `ITEM_GROUP_ID` varchar(40) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `GROUP_NAME` varchar(40) NOT NULL,
  `GROUP_SEQNO` varchar(60) NOT NULL,
  `IS_HOT` int(11) NOT NULL,
  `GROUP_DES` varchar(200) DEFAULT NULL,
  `HAS_CHILD` int(11) DEFAULT '0',
  PRIMARY KEY (`ITEM_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for item_main
-- ----------------------------
CREATE TABLE `item_main` (
  `ITEM_MAIN_GUID` varchar(36) NOT NULL,
  `ITEM_MAIN_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `ITEM_CNNAME` varchar(100) NOT NULL,
  `ITEM_SN` varchar(100) DEFAULT NULL,
  `ITEM_QTY` int(11) NOT NULL,
  `ITEM_UNIT` varchar(10) NOT NULL,
  `ITEM_PRICE` decimal(12,4) DEFAULT NULL,
  `ITEM_POSTAGE` decimal(10,2) DEFAULT NULL,
  `ITEM_MODEL` varchar(200) DEFAULT NULL,
  `ITEM_PFM` varchar(100) DEFAULT NULL,
  `ITEM_GROUP_GUID` varchar(36) NOT NULL,
  `ITEM_DEF_TYPE` varchar(100) DEFAULT NULL,
  `IS_2CODE` int(11) NOT NULL,
  `ITEM_DT` bigint(20) NOT NULL,
  `ITEM_PIC` varchar(100) DEFAULT NULL,
  `ITEM_DES` varchar(400) DEFAULT NULL,
  `ITEM_KEY1` varchar(100) DEFAULT NULL,
  `ITEM_KEY2` varchar(100) DEFAULT NULL,
  `ITEM_KEY3` varchar(100) DEFAULT NULL,
  `ITEM_KEY4` varchar(100) DEFAULT NULL,
  `ITEM_KEY5` varchar(100) DEFAULT NULL,
  `ITEM_STATUS` int(11) NOT NULL,
  `GOOD_CMT` int(11) DEFAULT NULL,
  `MDL_CMT` int(11) DEFAULT NULL,
  `POOR_CMT` int(11) DEFAULT NULL,
  `EXP_COUNT` int(11) DEFAULT NULL,
  `ITEM_INFO` varchar(400) DEFAULT NULL,
  `LIST_INFO` varchar(200) DEFAULT NULL,
  `ITEM_SERVICE` varchar(400) DEFAULT NULL,
  `IS_RECOMED` int(11) DEFAULT NULL,
  `RECOMED_DT` bigint(20) DEFAULT NULL,
  `ITEM_PIC2` varchar(100) DEFAULT NULL,
  `ITEM_PIC3` varchar(100) DEFAULT NULL,
  `ITEM_PIC4` varchar(100) DEFAULT NULL,
  `ITEM_PIC5` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ITEM_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
CREATE TABLE `order_item` (
  `ORDER_ITEM_GUID` varchar(36) NOT NULL,
  `ORDER_ITEM_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` varchar(36) NOT NULL,
  `ORDER_GUID` varchar(36) NOT NULL,
  `ITEM_GUID` varchar(36) NOT NULL,
  `ITEM_QTY` decimal(18,4) DEFAULT NULL,
  `ITEM_PRICE` decimal(18,4) DEFAULT NULL,
  `ITEM_POSTAGE` decimal(18,4) DEFAULT NULL,
  `SEQ_ID` int(11) NOT NULL,
  `ITEM_CNNAME` varchar(100) DEFAULT NULL,
  `ITEM_SN` varchar(100) DEFAULT NULL,
  `ITEM_UNIT` varchar(10) DEFAULT NULL,
  `ITEM_PIC` varchar(100) DEFAULT NULL,
  `ITEM_DES` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for order_main
-- ----------------------------
CREATE TABLE `order_main` (
  `ORDER_MAIN_GUID` varchar(36) NOT NULL,
  `ORDER_MAIN_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` varchar(36) NOT NULL,
  `ORDER_TITLE` varchar(100) NOT NULL,
  `ORDER_DT` bigint(20) DEFAULT NULL,
  `ORDER_STATUS` int(11) DEFAULT NULL COMMENT '0: 订单草稿\n            1: 订单交易成功\n            2: 已发货\n            3: 退货',
  `PAYMENT_WAY` varchar(10) DEFAULT NULL,
  `PAYMENT` decimal(18,4) DEFAULT NULL,
  `RECIV_ADDR` varchar(400) DEFAULT NULL,
  `RECEIVER` varchar(20) DEFAULT NULL,
  `RECIV_MOBILE` varchar(20) DEFAULT NULL,
  `RECIV_AREACODE` varchar(10) DEFAULT NULL,
  `ORDER_PRICE` decimal(18,4) DEFAULT NULL,
  `ORDER_POSTAGE` decimal(18,4) DEFAULT NULL,
  `ORDER_QTY` decimal(18,4) DEFAULT NULL,
  PRIMARY KEY (`ORDER_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shop_main
-- ----------------------------
CREATE TABLE `shop_main` (
  `SHOP_MAIN_GUID` varchar(36) NOT NULL,
  `SHOP_MAIN_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `OWNER_NAME` varchar(100) NOT NULL,
  `CARD_NO` varchar(20) NOT NULL,
  `SHOP_ADDR` varchar(400) DEFAULT NULL,
  `CONTACT` varchar(20) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `BANK` varchar(10) DEFAULT NULL,
  `BANK_ACC` varchar(20) DEFAULT NULL,
  `SHOP_CNNAME` varchar(100) DEFAULT NULL,
  `ITEMS_TYPE` varchar(40) DEFAULT NULL,
  `SHOP_DES` varchar(400) DEFAULT NULL,
  `SHOP_SUMMARY` varchar(400) DEFAULT NULL,
  `LOGO_URL` varchar(100) DEFAULT NULL,
  `SYS_USER_GUID` varchar(36) DEFAULT NULL,
  `SHOP_STATUS` int(11) DEFAULT NULL,
  PRIMARY KEY (`SHOP_MAIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
CREATE TABLE `sys_message` (
  `SYS_MESSAGE_GUID` varchar(36) NOT NULL,
  `SYS_MESSAGE_ID` varchar(40) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `RECEIVERID` varchar(40) NOT NULL,
  `RECEIVER` varchar(100) NOT NULL,
  `SENDERID` varchar(40) NOT NULL,
  `SENDER` varchar(100) NOT NULL,
  `MESSAGE_TITLE` varchar(200) NOT NULL,
  `MESSAGE_CONTENT` varchar(2000) DEFAULT NULL,
  `REPLY_CONTENT` varchar(2000) DEFAULT NULL,
  `SEND_DT` bigint(20) DEFAULT NULL,
  `REPLY_DT` bigint(20) DEFAULT NULL,
  `MESSAGE_TYPE` int(11) NOT NULL,
  PRIMARY KEY (`SYS_MESSAGE_GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user_collection
-- ----------------------------
CREATE TABLE `user_collection` (
  `USER_COLLECTION_GUID` varchar(36) NOT NULL,
  `USER_COLLECTION_ID` varchar(40) NOT NULL,
  `CREATED_BY` varchar(36) NOT NULL,
  `CREATED_DT` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(36) NOT NULL,
  `UPDATED_DT` bigint(20) NOT NULL,
  `CLIENT_GUID` varchar(36) NOT NULL,
  `IS_DELETED` int(11) NOT NULL,
  `ITEM_GUID` varchar(36) NOT NULL,
  `USER_GUID` varchar(36) NOT NULL,
  PRIMARY KEY (`USER_COLLECTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `info_news` VALUES ('1ab5025c-b2c5-432f-93df-28595b285a32', '1ab5025c-b2c5-432f-93df-28595b285a32', 'SYS', '1326292665084', 'SYS', '1326292665084', 'SYS', '0', '快报资讯00006', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00006\n快报资讯00006  \n快报资讯00006 +  +\n\n快报资讯00006');
INSERT INTO `info_news` VALUES ('28be1c6a-6539-479a-9dca-4094ff435109', '28be1c6a-6539-479a-9dca-4094ff435109', 'SYS', '1326292608253', 'SYS', '1326292608253', 'SYS', '0', '快报资讯00001', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00001\n快报资讯00001\n快报资讯00001  \n快报资讯00001 +  +\n\n快报资讯00001');
INSERT INTO `info_news` VALUES ('491ca7d8-3b21-40f0-acbb-a8c015834667', '491ca7d8-3b21-40f0-acbb-a8c015834667', 'SYS', '1326292684593', 'SYS', '1326292684593', 'SYS', '0', '快报资讯00008', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00008\n快报资讯00008  \n快报资讯00008 +  +\n\n快报资讯00008');
INSERT INTO `info_news` VALUES ('5d9e79d8-d266-4a88-828e-1a0355a2f1cc', '5d9e79d8-d266-4a88-828e-1a0355a2f1cc', 'SYS', '1326292674199', 'SYS', '1326292674199', 'SYS', '0', '快报资讯00007', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00007\n快报资讯00007  \n快报资讯00007 +  +\n\n快报资讯00007');
INSERT INTO `info_news` VALUES ('7644da64-a066-4aaa-b9e1-dd90878c947e', '7644da64-a066-4aaa-b9e1-dd90878c947e', 'SYS', '1326292695860', 'SYS', '1326292695860', 'SYS', '0', '快报资讯00009', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00009\n快报资讯00009  \n快报资讯00009 +  +\n\n快报资讯00009');
INSERT INTO `info_news` VALUES ('858a00a9-3b0e-4300-8101-2ebe2a3b4080', '858a00a9-3b0e-4300-8101-2ebe2a3b4080', 'SYS', '1326292637407', 'SYS', '1326292637407', 'SYS', '0', '快报资讯00003', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00003\n快报资讯00003  \n快报资讯00003 +  +\n\n快报资讯00003');
INSERT INTO `info_news` VALUES ('939eeeaf-4711-4d51-a465-72eba817b693', '939eeeaf-4711-4d51-a465-72eba817b693', 'SYS', '1326292622495', 'SYS', '1326292622495', 'SYS', '0', '快报资讯00002', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00002\n快报资讯00002\n快报资讯00002  \n快报资讯00002 +  +\n\n快报资讯00002');
INSERT INTO `info_news` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c33', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c33', 'SYS', '1326292708089', 'SYS', '1326293045407', 'SYS', '0', '快报资讯00010', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00010\n快报资讯00010  \n快报资讯00010 +  +\n\n快报资讯00010');
INSERT INTO `info_news` VALUES ('a1914324-84e1-45d8-9d63-c4b22f2f9be5', 'a1914324-84e1-45d8-9d63-c4b22f2f9be5', 'SYS', '1326292647072', 'SYS', '1326292647072', 'SYS', '0', '快报资讯00004', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00004\n快报资讯00004  \n快报资讯00004 +  +\n\n快报资讯00004');
INSERT INTO `info_news` VALUES ('d71ee68f-1d70-4f44-b35b-8ff02b9def64', 'd71ee68f-1d70-4f44-b35b-8ff02b9def64', 'SYS', '1326292656799', 'SYS', '1326292656799', 'SYS', '0', '快报资讯00005', 'http://localhost:8080/ebuy/UploadImg/20120111/6f06b671-e5f9-4bf4-8b5a-e4e6c9889712.png', '快报资讯00005\n快报资讯00005  \n快报资讯00005 +  +\n\n快报资讯00005');
INSERT INTO `item_e` VALUES ('6618d8d9-a366-44a1-9129-390cba0dcee3', '6618d8d9-a366-44a1-9129-390cba0dcee3', '1326730337681', 'SYS', '1326730337681', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5c65108-bef8-4722-88ba-e0500fb0e075', '23ecb2b8-dbb6-4d9a-bd9a-121c54e2d7d0', '', '-1', '-1', '', '1', 'SYS');
INSERT INTO `item_e` VALUES ('8f7a7880-d479-4451-a773-5bfe063e32bc', '8f7a7880-d479-4451-a773-5bfe063e32bc', '1326732618608', 'SYS', '1326732618608', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '7f4c4ee2-6451-4727-9b2b-cf4b09b1f3d0', 'f121ae3d-480b-41ac-a1d2-38d3c6d5bd2a', '', '-1', '-1', '', '1', 'SYS');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c110', '9845af85-7b77-4572-a71d-591c2926c110', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d45', 'aad90dca-adef-4e7b-9334-e0132b2bcad5', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c111', '9845af85-7b77-4572-a71d-591c2926c111', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d46', 'aad90dca-adef-4e7b-9334-e0132b2bcad6', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c112', '9845af85-7b77-4572-a71d-591c2926c112', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d47', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a1', '9845af85-7b77-4572-a71d-591c2926c1a1', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '3401c015-f3ef-4904-80d6-e79465a72151', '2a55385f-ba10-4ed4-ab83-5592a790e52c', '44ecc7a4-6e76-4dcc-bde9-970bc72bd7ca', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a2', '9845af85-7b77-4572-a71d-591c2926c1a2', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '2ed34598-d834-4496-9010-d1c7b7e439f2', '9845af85-7b77-4572-a71d-591c2926c17f', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a3', '9845af85-7b77-4572-a71d-591c2926c1a3', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '4bef7cbf-7e2a-4153-bb8f-948885b6b42f', '44ecc7a4-6e76-4dcc-bde9-970bc72bd7ca', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a4', '9845af85-7b77-4572-a71d-591c2926c1a4', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '3401c015-f3ef-4904-80d6-e79465a72151', '82d640c9-6f13-46ba-8994-66539f8cf356', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a5', '9845af85-7b77-4572-a71d-591c2926c1a5', '1325914229480', 'SYS', '1326599530627', 'SYS', 'SYS', '0', '3401c015-f3ef-4904-80d6-e79465a72151', '8c086e2c-dd15-46f9-af16-b60ea654bcc4', '9845af85-7b77-4572-a71d-591c2926c17f', 'asdfghjkl', '1', '1', '123', '0', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a6', '9845af85-7b77-4572-a71d-591c2926c1a6', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d41', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a7', '9845af85-7b77-4572-a71d-591c2926c1a7', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d42', 'aad90dca-adef-4e7b-9334-e0132b2bcad2', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a8', '9845af85-7b77-4572-a71d-591c2926c1a8', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d43', 'aad90dca-adef-4e7b-9334-e0132b2bcad3', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('9845af85-7b77-4572-a71d-591c2926c1a9', '9845af85-7b77-4572-a71d-591c2926c1a9', '1325914229480', 'SYS', '1325914229480', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d44', 'aad90dca-adef-4e7b-9334-e0132b2bcad4', null, null, null, 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '1', 'jimmy');
INSERT INTO `item_e` VALUES ('aaef07b8-09da-491f-a196-e5faed73046e', 'aaef07b8-09da-491f-a196-e5faed73046e', '1326730513687', 'SYS', '1326730513687', 'SYS', 'SYS', '0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '531b218d-21a4-408b-8cb0-cf4911214f04', 'd6b776f5-c687-4ebc-bf79-8be802404f20', '', '-1', '-1', '', '1', 'SYS');
INSERT INTO `item_e` VALUES ('b007f0b9-122f-4e28-8fd9-04940a105fee', 'b007f0b9-122f-4e28-8fd9-04940a105fee', '1326730337728', 'SYS', '1326730337728', 'SYS', 'SYS', '0', '3401c015-f3ef-4904-80d6-e79465a72151', 'ccbf67f2-7ac4-4b6d-b79a-a5f09253110c', '23ecb2b8-dbb6-4d9a-bd9a-121c54e2d7d0', '', '-1', '-1', '', '1', 'SYS');
INSERT INTO `item_group` VALUES ('06cdf5cb-95f5-4221-880a-ff60a549e173', '06cdf5cb-95f5-4221-880a-ff60a549e173', 'SYS', '1326594786657', 'SYS', '1326594786657', 'SYS', '0', '测试分类5', '106', '0', '测试分类5试分类5', '1');
INSERT INTO `item_group` VALUES ('11175fe9-b190-437a-b08e-345454872d4f', '11175fe9-b190-437a-b08e-345454872d4f', 'SYS', '1325044326310', 'SYS', '1325044326310', 'SYS', '0', '长裤子', '101100100', '0', '男装长裤子描述', '1');
INSERT INTO `item_group` VALUES ('2fe01a73-3c1b-431b-9952-fda35a136bbd', '2fe01a73-3c1b-431b-9952-fda35a136bbd', 'SYS', '1325044261083', 'SYS', '1325044261083', 'SYS', '0', '长裙子', '100100100', '0', '女装长裙子描述', '1');
INSERT INTO `item_group` VALUES ('3dcc0654-9987-4a3e-bcb6-1b83a8335f54', '3dcc0654-9987-4a3e-bcb6-1b83a8335f54', 'SYS', '1326594815519', 'SYS', '1326594815519', 'SYS', '0', '测试分类8', '109', '0', '测试分类8试分类8', '1');
INSERT INTO `item_group` VALUES ('503cf7db-787e-4a2d-a759-395ce5e5fed4', '503cf7db-787e-4a2d-a759-395ce5e5fed4', 'SYS', '1326594765868', 'SYS', '1326594765868', 'SYS', '0', '测试分类3', '104', '0', '测试分类3测试分类3', '1');
INSERT INTO `item_group` VALUES ('785cd628-c03d-4fe4-a5ff-4b9ea1507783', '785cd628-c03d-4fe4-a5ff-4b9ea1507783', 'SYS', '1325044304994', 'SYS', '1325044304994', 'SYS', '0', '男装', '101', '0', '男装描述', '0');
INSERT INTO `item_group` VALUES ('7a71ecd6-afcf-4226-8f3e-0a6e2c50c452', '7a71ecd6-afcf-4226-8f3e-0a6e2c50c452', 'SYS', '1326594797892', 'SYS', '1326594797892', 'SYS', '0', '测试分类6', '107', '0', '测试分类6试分类6', '1');
INSERT INTO `item_group` VALUES ('7ce00983-babc-4c5f-adb0-986605251f5b', '7ce00983-babc-4c5f-adb0-986605251f5b', 'SYS', '1326594806702', 'SYS', '1326594806702', 'SYS', '0', '测试分类7', '108', '0', '测试分类7试分类7', '1');
INSERT INTO `item_group` VALUES ('8be9da5d-3bd9-4511-b483-f93c184e2025', '8be9da5d-3bd9-4511-b483-f93c184e2025', 'SYS', '1325044230351', 'SYS', '1325044230351', 'SYS', '0', '女装', '100', '0', '女装描述', '0');
INSERT INTO `item_group` VALUES ('95ed5093-41eb-4a9e-9d3b-dd3604e71dff', '95ed5093-41eb-4a9e-9d3b-dd3604e71dff', 'SYS', '1326594776848', 'SYS', '1326594776848', 'SYS', '0', '测试分类4', '105', '0', '测试分类4试分类4', '1');
INSERT INTO `item_group` VALUES ('c7d86fa8-eee4-441e-911d-9fcd76a7c96c', 'c7d86fa8-eee4-441e-911d-9fcd76a7c96c', 'SYS', '1325044344159', 'SYS', '1325044344159', 'SYS', '0', '短裤子', '101100101', '1', '男装短裤子描述', '1');
INSERT INTO `item_group` VALUES ('cf5a58e9-1b65-4f5f-b245-916540d125bf', 'cf5a58e9-1b65-4f5f-b245-916540d125bf', 'SYS', '1325044315377', 'SYS', '1325044315377', 'SYS', '0', '裤子', '101100', '0', '男装裤子描述', '0');
INSERT INTO `item_group` VALUES ('dcd6ff77-0e1f-4ded-985e-98dfecc3de0d', 'dcd6ff77-0e1f-4ded-985e-98dfecc3de0d', 'SYS', '1325044245311', 'SYS', '1325044245311', 'SYS', '0', '裙子', '100100', '0', '女装裙子描述', '0');
INSERT INTO `item_group` VALUES ('e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'SYS', '1325044276955', 'SYS', '1325044276955', 'SYS', '0', '短裙子', '100100101', '1', '女装短裙子描述', '1');
INSERT INTO `item_group` VALUES ('f7f53ce9-5138-49a3-90c2-6fb45088205e', 'f7f53ce9-5138-49a3-90c2-6fb45088205e', 'SYS', '1326594755506', 'SYS', '1326594755506', 'SYS', '0', '测试分类2', '103', '0', '测试分类2测试分类2', '1');
INSERT INTO `item_group` VALUES ('fea9d63d-789c-49a6-aa2b-ab4efafeca8b', 'fea9d63d-789c-49a6-aa2b-ab4efafeca8b', 'SYS', '1326594742898', 'SYS', '1326594742898', 'SYS', '0', '测试分类1', '102', '0', '测试分类1测试分类1', '1');
INSERT INTO `item_main` VALUES ('3401c015-f3ef-4904-80d6-e79465a72151', '3401c015-f3ef-4904-80d6-e79465a72151', '1325127718169', 'SYS', '1325430106004', 'token', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '商品1', '编号1', '11', '盒', '11.1100', '10.00', '大', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'moda', '1', '1325127718169', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '快抢，好的,hahaha', '好东西', '', '', '', '', '2', null, null, null, null, '商品介绍商品介绍商品介绍商品介绍', '包装清单包装清单包装清单', '售后服务售后服务售后服务包装清单包装清单包装清单', '1', '1325404830591', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('8ae40e1a-73fb-469a-8123-dcd973bf6264', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1325061665837', 'SYS', '1325916744932', 'token', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '商品名称', '编号：', '10', '数量单位', '10.1100', '5.12', '规格', '性能', 'cf5a58e9-1b65-4f5f-b245-916540d125bf', '自定义类别', '1', '1325061665837', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品描述', '关键字1', '关键字2', '关键字3', '关键字4', '关键字', '1', null, null, null, null, '', '', '', '1', '1325921623535', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198511', '93bced44-5bba-4081-9394-338fa7198511', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品4', '0004', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198512', '93bced44-5bba-4081-9394-338fa7198512', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品5', '0005', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198513', '93bced44-5bba-4081-9394-338fa7198513', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品6', '0006', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198514', '93bced44-5bba-4081-9394-338fa7198514', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品7', '0007', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198515', '93bced44-5bba-4081-9394-338fa7198515', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品8', '0008', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa7198516', '93bced44-5bba-4081-9394-338fa7198516', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品9', '0009', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品4', '测试商品41', '测试商品42', '测试商品43', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `item_main` VALUES ('93bced44-5bba-4081-9394-338fa719851c', '93bced44-5bba-4081-9394-338fa719851c', '1325916536535', 'SYS', '1325916536535', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '测试商品3', '0003', '1', '个', '9.9000', '5.00', '小', '好', 'e242c7ef-51bd-4612-b3d5-ac501c0cccc3', 'ok', '1', '1325916536535', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '测试商品3商品简介', '测试商品3关键字1', '测试商品3关键字2', '测试商品3关键字3', '测试商品3关键字4', '测试商品3关键字5', '1', null, null, null, null, '测试商品3商品介绍', '测试商品3包装清单', '测试商品3售后服务', '0', '1325921722683', 'http://localhost:8080/ebuy/UploadImg/20120115/t2.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t3.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t4.jpg', 'http://localhost:8080/ebuy/UploadImg/20120115/t5.jpg');
INSERT INTO `order_item` VALUES ('00e68f04-5fed-4924-92f7-c9cb51d39cd5', '00e68f04-5fed-4924-92f7-c9cb51d39cd5', '1326608375513', 'SYS', '1326608375513', 'SYS', 'SYS', '0', 'bd9b4466-8c54-4883-b67e-a5a69957a9bf', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '10.2200', '0.0000', '1', '商品1', '', '', null, null);
INSERT INTO `order_item` VALUES ('2a55385f-ba10-4ed4-ab83-5592a790e52c', '2a55385f-ba10-4ed4-ab83-5592a790e52c', '1325821800505', 'SYS', '1325821800505', 'SYS', 'SYS', '0', '44ecc7a4-6e76-4dcc-bde9-970bc72bd7ca', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '10.2200', '4.0000', '1', '商品1', '', '盒', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('2bebd275-5cf5-48bd-948a-39f33b279605', '2bebd275-5cf5-48bd-948a-39f33b279605', '1326608171859', 'SYS', '1326608172396', 'SYS', 'SYS', '0', 'ced19f05-ea02-43e3-a8d1-be11490cf2a3', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '10.2200', '0.0000', '1', '商品1', '', '', null, null);
INSERT INTO `order_item` VALUES ('2ed34598-d834-4496-9010-d1c7b7e439f2', '2ed34598-d834-4496-9010-d1c7b7e439f2', '1325914229483', 'SYS', '1325914229483', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '9845af85-7b77-4572-a71d-591c2926c17f', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('4bef7cbf-7e2a-4153-bb8f-948885b6b42f', '4bef7cbf-7e2a-4153-bb8f-948885b6b42f', '1325821800504', 'SYS', '1325821800504', 'SYS', 'SYS', '0', '44ecc7a4-6e76-4dcc-bde9-970bc72bd7ca', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('531b218d-21a4-408b-8cb0-cf4911214f04', '531b218d-21a4-408b-8cb0-cf4911214f04', '1326730513685', 'SYS', '1326730513685', 'SYS', 'SYS', '0', 'd6b776f5-c687-4ebc-bf79-8be802404f20', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '0.0000', '0', '内衣', '编号：', '数量单位', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品描述');
INSERT INTO `order_item` VALUES ('57045181-c35a-4454-bceb-9561f01a0fd2', '57045181-c35a-4454-bceb-9561f01a0fd2', '1326608167364', 'SYS', '1326608167712', 'SYS', 'SYS', '0', 'ced19f05-ea02-43e3-a8d1-be11490cf2a3', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '0.0000', '0', '内衣', '', '', null, null);
INSERT INTO `order_item` VALUES ('7f4c4ee2-6451-4727-9b2b-cf4b09b1f3d0', '7f4c4ee2-6451-4727-9b2b-cf4b09b1f3d0', '1326732618607', 'SYS', '1326732618607', 'SYS', 'SYS', '0', 'f121ae3d-480b-41ac-a1d2-38d3c6d5bd2a', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '3.0000', '10.0000', '0.0000', '0', 'duoduo', '编号：', '数量单位', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品描述');
INSERT INTO `order_item` VALUES ('82d640c9-6f13-46ba-8994-66539f8cf356', '82d640c9-6f13-46ba-8994-66539f8cf356', '1325840088781', 'SYS', '1325840088781', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '10.2200', '4.0000', '1', '商品1', '', '盒', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('8c086e2c-dd15-46f9-af16-b60ea654bcc4', '8c086e2c-dd15-46f9-af16-b60ea654bcc4', '1325914229484', 'SYS', '1325914229484', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '9845af85-7b77-4572-a71d-591c2926c17f', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '15.2200', '4.0000', '1', '商品1', '', '盒', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5c65108-bef8-4722-88ba-e0500fb0e075', 'c5c65108-bef8-4722-88ba-e0500fb0e075', '1326730337681', 'SYS', '1326730337681', 'SYS', 'SYS', '0', '23ecb2b8-dbb6-4d9a-bd9a-121c54e2d7d0', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '0.0000', '0', '内衣', '编号：', '数量单位', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品描述');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d41', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d41', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d42', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d42', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad2', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d43', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d43', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad3', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d44', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d44', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad4', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d45', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d45', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad5', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d46', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d46', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad6', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('c5e6255f-22f4-4f66-81e1-1b33c1b21d47', 'c5e6255f-22f4-4f66-81e1-1b33c1b21d47', '1325840088779', 'SYS', '1325840088780', 'SYS', 'SYS', '0', 'aad90dca-adef-4e7b-9334-e0132b2bcad1', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '5.0000', '0', '内衣', '', '个', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '商品简介');
INSERT INTO `order_item` VALUES ('ccbf67f2-7ac4-4b6d-b79a-a5f09253110c', 'ccbf67f2-7ac4-4b6d-b79a-a5f09253110c', '1326730337728', 'SYS', '1326730337728', 'SYS', 'SYS', '0', '23ecb2b8-dbb6-4d9a-bd9a-121c54e2d7d0', '3401c015-f3ef-4904-80d6-e79465a72151', '1.0000', '10.2200', '0.0000', '1', '商品1', '编号1', '盒', 'http://localhost:8080/ebuy/UploadImg/20120115/t1.jpg', '快抢，好的,hahaha');
INSERT INTO `order_item` VALUES ('f6004916-de59-4409-a6d4-38ce0df97dce', 'f6004916-de59-4409-a6d4-38ce0df97dce', '1326608375510', 'SYS', '1326608375510', 'SYS', 'SYS', '0', 'bd9b4466-8c54-4883-b67e-a5a69957a9bf', '8ae40e1a-73fb-469a-8123-dcd973bf6264', '1.0000', '10.0000', '0.0000', '0', '内衣', '', '', null, null);
INSERT INTO `order_main` VALUES ('44ecc7a4-6e76-4dcc-bde9-970bc72bd7ca', 'OD20120106000002', '1325821800503', 'SYS', '1325821800503', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325821800503', '1', '01', '10.2200', '北京朝阳区', '孙超', '联系电话', '100010', '10.2200', '0.0000', '1.0000');
INSERT INTO `order_main` VALUES ('aad90dca-adef-4e7b-9334-e0132b2bcad1', 'OD20120106000003', '1325840088779', 'SYS', '1325840088779', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325840088779', '1', '01', '10.2200', '北京朝阳区', '孙超', '12345678901', '100010', '10.2200', '0.0000', '2.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c17f', 'OD20120106000004', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '3.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c171', 'OD20120106000005', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '1.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c172', 'OD20120106000006', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '2.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c173', 'OD20120106000007', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '3.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c174', 'OD20120106000008', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '1.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c175', 'OD20120106000009', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '2.0000');
INSERT INTO `order_main` VALUES ('9845af85-7b77-4572-a71d-591c2926c176', 'OD20120106000010', '1325914229480', 'SYS', '1325914229480', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '', '1325914229480', '1', '01', '25.2200', '北京朝阳区', '孙超', '12345678901', '100010', '25.2200', '0.0000', '3.0000');
INSERT INTO `order_main` VALUES ('ced19f05-ea02-43e3-a8d1-be11490cf2a3', 'OD20120115000002', '1326608162240', '001', '1326608162620', '001', 'SYS', '0', '', '1326608163391', '0', '01', '20.2200', '北京朝阳区', '孙超', '12345678901', '100010', '20.2200', '0.0000', '10.0000');
INSERT INTO `order_main` VALUES ('bd9b4466-8c54-4883-b67e-a5a69957a9bf', 'OD20120115000003', '1326608375509', '001', '1326608375509', '001', 'SYS', '0', '', '1326608375509', '0', '01', '20.2200', '北京朝阳区', '孙超', '12345678901', '100010', '20.2200', '0.0000', '10.0000');
INSERT INTO `order_main` VALUES ('f121ae3d-480b-41ac-a1d2-38d3c6d5bd2a', 'OD20120115030003', '1326732618569', '001', '1326732618569', '001', 'SYS', '0', '', '1326732618569', '0', '01', '30.0000', 'beijing', 'lizhi', '13911786788', '100010', '30.0000', '0.0000', '10.0000');
INSERT INTO `order_main` VALUES ('23ecb2b8-dbb6-4d9a-bd9a-121c54e2d7d0', 'OD20120215000003', '1326730337565', '001', '1326730337565', '001', 'SYS', '0', '', '1326730337565', '0', '01', '20.2200', '北京朝阳区', '孙超', '12345678901', '100010', '20.2200', '0.0000', '10.0000');
INSERT INTO `order_main` VALUES ('d6b776f5-c687-4ebc-bf79-8be802404f20', 'OD203120215000003', '1326730513683', '001', '1326730513683', '001', 'SYS', '0', '', '1326730513683', '0', '01', '10.0000', '北京朝阳区', '孙超', '12345678901', '100010', '10.0000', '0.0000', '10.0000');
INSERT INTO `shop_main` VALUES ('a9eb22e4-513c-4c5b-bb25-75e5762442ef', '420111198010225510', '1325210957583', 'SYS', '1325210957583', 'SYS', 'a9eb22e4-513c-4c5b-bb25-75e5762442ef', '0', '汪凯', '420111198010225510', '昆山市', '110', '119', '中行', '1234567', '测试店铺', null, null, null, null, null, '0');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c31', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c31', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'robin', 'robin', 'test2', 'robin robin', '你说什么', '1326292695860', '1326697330096', '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c32', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c32', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test', 'testtesttest test', 'f', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c33', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c33', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test3', 'testtesttest test', 'sf', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c34', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c34', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test4', 'testtesttest test', 'af', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c35', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c35', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test5', 'testtesttest test', 'saf', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c36', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c36', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test6', 'testtesttest test', 'af', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c37', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c37', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test7', 'testtesttest test', 'af', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c38', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c38', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test8', 'testtesttest test', 'af', '1326292695860', null, '1');
INSERT INTO `sys_message` VALUES ('9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c39', '9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c39', '1326292695860', 'SYS', '1326292695860', 'SYS', 'SYS', '0', 'jimmy', 'jimmy', 'sunny', 'sunny', 'test9', 'testtesttest test', 'sf', '1326292695860', null, '1');
INSERT INTO `user_collection` VALUES ('02cc4e62-d269-437d-af89-8032c3b4d8a2', '02cc4e62-d269-437d-af89-8032c3b4d8a2', 'SYS', '1326244931298', 'SYS', '1326244931298', 'SYS', '0', '3401c015-f3ef-4904-80d6-e79465a72151', 'jimmy');
