package com.fengxiafei.apps.user.bean;

import java.util.Date;

public class UserInfo {
	private int id; // 记录id
	private String flag;
	private int userid = 0;
	private String username = "";
	private String password = "";
	private String nikename = "";
	private String key = "";
	private String checkcode = "";
	private Date regTime;
	private Date modTime;
	private Date lastTime;
	private Date activeTime;

	public Date getRegTime() {
		return regTime;
	}

	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}

	public Date getModTime() {
		return modTime;
	}

	public void setModTime(Date modTime) {
		this.modTime = modTime;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the nikename
	 */
	public String getNikename() {
		return nikename;
	}

	/**
	 * @param nikename the nikename to set
	 */
	public void setNikename(String nikename) {
		this.nikename = nikename;
	}

	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return the activeTime
	 */
	public Date getActiveTime() {
		return activeTime;
	}

	/**
	 * @param activeTime the activeTime to set
	 */
	public void setActiveTime(Date activeTime) {
		this.activeTime = activeTime;
	}

	/**
	 * @return the key
	 */
	public String getKey() {
		return key;
	}

	/**
	 * @param key the key to set
	 */
	public void setKey(String key) {
		this.key = key;
	}

	/**
	 * @return the flag
	 */
	public String getFlag() {
		return flag;
	}

	/**
	 * @param flag the flag to set
	 */
	public void setFlag(String flag) {
		this.flag = flag;
	}

	/**
	 * @return the lastTime
	 */
	public Date getLastTime() {
		return lastTime;
	}

	/**
	 * @param lastTime the lastTime to set
	 */
	public void setLastTime(Date lastTime) {
		this.lastTime = lastTime;
	}

	/**
	 * @return the checkcode
	 */
	public String getCheckcode() {
		return checkcode;
	}

	/**
	 * @param checkcode the checkcode to set
	 */
	public void setCheckcode(String checkcode) {
		this.checkcode = checkcode;
	}

}
