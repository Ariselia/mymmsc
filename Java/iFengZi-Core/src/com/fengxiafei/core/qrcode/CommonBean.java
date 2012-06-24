/**
 * 
 */
package com.fengxiafei.core.qrcode;

import com.fengxiafei.core.ActionStatus;

/**
 * 普通业务空码
 * 
 * @author wangfeng
 * 
 */
public class CommonBean extends ActionStatus {
	private String data;

	/**
	 * @return the data
	 */
	public String getData() {
		return data;
	}

	/**
	 * @param data
	 *            the data to set
	 */
	public void setData(String data) {
		this.data = data;
	}
}
