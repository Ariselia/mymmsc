/**
 * 
 */
package com.fengxiafei.apps.code.bean;

/**
 * 商户码信息(kma_core)
 * 
 * @author wangfeng
 * 
 */
public class TraderInfo {
	private int id;
	private int flag;
	private int userId;
	private int prefix;
	private int lastId;

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

	public int getFlag() {
		return flag;
	}

	public int getUserId() {
		return userId;
	}

	public int getPrefix() {
		return prefix;
	}

	public int getLastId() {
		return lastId;
	}

	public void setFlag(int flag) {
		this.flag = flag;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public void setPrefix(int prefix) {
		this.prefix = prefix;
	}

	public void setLastId(int lastId) {
		this.lastId = lastId;
	}

}
