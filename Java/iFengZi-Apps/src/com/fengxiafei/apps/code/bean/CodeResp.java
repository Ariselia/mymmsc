/**
 * 
 */
package com.fengxiafei.apps.code.bean;

/**
 * 生码响应bean 数据实体
 * 
 * @author wangfeng
 * 
 */
public class CodeResp {
	private byte type; // 码类型
	private String codeId; // 码ID
	private String url; // 码URL
	private int number; // 码数量
	private String zipUrl; // zipURL路径

	/**
	 * @return the type
	 */
	public int getType() {
		return type;
	}

	/**
	 * @param type
	 *            the type to set
	 */
	public void setType(byte type) {
		this.type = type;
	}

	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @param url
	 *            the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the codeId
	 */
	public String getCodeId() {
		return codeId;
	}

	/**
	 * @param codeId the codeId to set
	 */
	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}

	/**
	 * @return the number
	 */
	public int getNumber() {
		return number;
	}

	/**
	 * @param number the number to set
	 */
	public void setNumber(int number) {
		this.number = number;
	}

	/**
	 * @return the zipUrl
	 */
	public String getZipUrl() {
		return zipUrl;
	}

	/**
	 * @param zipUrl the zipUrl to set
	 */
	public void setZipUrl(String zipUrl) {
		this.zipUrl = zipUrl;
	}
}
