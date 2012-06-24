/**
 * 
 */
package com.fengxiafei.apps.code.bean;

import com.fengxiafei.core.ActionStatus;

/**
 * 生码响应bean
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 */
public class CodeBean extends ActionStatus{
	private CodeResp data;

	/**
	 * @return the data
	 */
	public CodeResp getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(CodeResp data) {
		this.data = data;
	}
}
