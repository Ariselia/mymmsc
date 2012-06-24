/**
 * 
 */
package com.fengxiafei.apps.user.bean;

import com.fengxiafei.core.ActionStatus;

/**
 * @author wangfeng
 * 
 */
public class PasswordResp extends ActionStatus {
	private PasswordBean data = null;

	/**
	 * @return the data
	 */
	public PasswordBean getData() {
		return data;
	}

	/**
	 * @param data
	 *            the data to set
	 */
	public void setData(PasswordBean data) {
		this.data = data;
	}
}
