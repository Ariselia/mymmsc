/**
 * 
 */
package com.fengxiafei.apps.util.bean;

/**
 * 扫码记录bean(media_statis)
 * 
 * @author wangfeng
 * 
 */
public class ScanCode {
	private String codeId = null;
	private int userId = -1;
	private String scanTime = null;
	private int scanCount = 0;

	public String getCodeId() {
		return codeId;
	}

	public int getUserId() {
		return userId;
	}

	public String getScanTime() {
		return scanTime;
	}

	public int getScanCount() {
		return scanCount;
	}

	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public void setScanTime(String scanTime) {
		this.scanTime = scanTime;
	}

	public void setScanCount(int scanCount) {
		this.scanCount = scanCount;
	}
}
