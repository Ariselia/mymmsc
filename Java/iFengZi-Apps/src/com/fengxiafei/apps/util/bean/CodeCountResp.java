/**
 * 
 */
package com.fengxiafei.apps.util.bean;

import com.fengxiafei.core.ActionStatus;

/**
 * @author wangfeng
 *
 */
public class CodeCountResp extends ActionStatus {
	private CodeCount data = null;

	/**
	 * @return the data
	 */
	public CodeCount getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(CodeCount data) {
		this.data = data;
	}
}
