package com.fengxiafei.apps.code.bean;

import java.util.Date;

/**
 * 码信息bean
 * @author wangfeng
 * @version 3.0.2 2012/06/22
 */
public class MediaInfo {
	private int id;
	private String flag;
	private int userId;
	private String traderId;
	private String uuid;
	private int type;
	private String codeAttribute;
	private String title;
	private Date addTime;
	private int modUser;
	private Date modTime;
	private String code_business;
	private String qserial_number;
	private String comment;

	public int getId() {
		return id;
	}

	public String getFlag() {
		return flag;
	}

	public int getUserId() {
		return userId;
	}

	public String getTraderId() {
		return traderId;
	}

	public String getUuid() {
		return uuid;
	}

	public int getType() {
		return type;
	}

	public String getCodeAttribute() {
		return codeAttribute;
	}

	public String getTitle() {
		return title;
	}

	public Date getAddTime() {
		return addTime;
	}

	public int getModUser() {
		return modUser;
	}

	public Date getModTime() {
		return modTime;
	}

	public String getCode_business() {
		return code_business;
	}

	public String getQserial_number() {
		return qserial_number;
	}

	public String getComment() {
		return comment;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public void setTraderId(String traderId) {
		this.traderId = traderId;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public void setType(int type) {
		this.type = type;
	}

	public void setCodeAttribute(String codeAttribute) {
		this.codeAttribute = codeAttribute;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setAddTime(Date addTime) {
		this.addTime = addTime;
	}

	public void setModUser(int modUser) {
		this.modUser = modUser;
	}

	public void setModTime(Date modTime) {
		this.modTime = modTime;
	}

	public void setCode_business(String code_business) {
		this.code_business = code_business;
	}

	public void setQserial_number(String qserial_number) {
		this.qserial_number = qserial_number;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

}
