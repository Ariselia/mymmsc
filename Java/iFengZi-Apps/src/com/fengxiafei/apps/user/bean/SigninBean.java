/**
 * 
 */
package com.fengxiafei.apps.user.bean;

import com.fengxiafei.core.ActionStatus;

/**
 * @author wangfeng
 *
 */
public class SigninBean extends ActionStatus{
	private SigninResp data;

	/**
	 * @return the data
	 */
	public SigninResp getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(SigninResp data) {
		this.data = data;
	}
	
}
