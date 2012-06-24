/**
 * 
 */
package com.fengxiafei.apps.code.bean;

import com.fengxiafei.core.ActionStatus;


/**
 * 
 * @author wangfeng
 * 
 */
public class FileBean extends ActionStatus {
	private FileResp data;

	/**
	 * @return the data
	 */
	public FileResp getData() {
		return data;
	}

	/**
	 * @param data
	 *            the data to set
	 */
	public void setData(FileResp data) {
		this.data = data;
	}
}
