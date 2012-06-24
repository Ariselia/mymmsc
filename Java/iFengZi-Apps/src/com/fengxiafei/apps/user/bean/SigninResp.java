/**
 * 
 */
package com.fengxiafei.apps.user.bean;

/**
 * @author wangfeng
 * 
 */
public class SigninResp {
	private long userId;
	private String nikename;
	private String token;
	private String lastdate;
	private String lastip;

	public long getUserId() {
		return userId;
	}

	public String getNikename() {
		return nikename;
	}

	public String getToken() {
		return token;
	}

	public String getLastdate() {
		return lastdate;
	}

	public String getLastip() {
		return lastip;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public void setNikename(String nikename) {
		this.nikename = nikename;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public void setLastdate(String lastdate) {
		this.lastdate = lastdate;
	}

	public void setLastip(String lastip) {
		this.lastip = lastip;
	}

}
