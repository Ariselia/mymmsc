/**
 * 
 */
package com.fengxiafei.apps.user.bean;

import com.fengxiafei.core.ActionStatus;

/**
 * @author wangfeng
 * 
 */
public class UserInfoResp extends ActionStatus {
	private UserData data = null;

	/**
	 * @return the data
	 */
	public UserData getData() {
		return data;
	}

	/**
	 * @param data
	 *            the data to set
	 */
	public void setData(UserData data) {
		this.data = data;
	}
}
