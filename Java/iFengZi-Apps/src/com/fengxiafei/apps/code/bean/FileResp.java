/**
 * 
 */
package com.fengxiafei.apps.code.bean;

/**
 * @author wangfeng
 * 
 */
public class FileResp {
	private int type;
	private String fileType;
	private String fileUrl;

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
	public void setType(int type) {
		this.type = type;
	}

	/**
	 * @return the fileType
	 */
	public String getFileType() {
		return fileType;
	}

	/**
	 * @param fileType
	 *            the fileType to set
	 */
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	/**
	 * @return the fileUrl
	 */
	public String getFileUrl() {
		return fileUrl;
	}

	/**
	 * @param fileUrl
	 *            the fileUrl to set
	 */
	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
}
