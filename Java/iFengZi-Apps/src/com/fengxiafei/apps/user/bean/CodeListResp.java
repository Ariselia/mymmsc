/**
 * 
 */
package com.fengxiafei.apps.user.bean;

import java.util.List;

import com.fengxiafei.core.ActionStatus;

/**
 * 我的码
 * @author wangfeng
 *
 */
public class CodeListResp extends ActionStatus {
	private List<CodeInfo> data = null;
	/** 最新的记录ID, 仅对返回List数组有效 */
	private int firstId = -1;
	
	/**
	 * @return the data
	 */
	public List<CodeInfo> getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(List<CodeInfo> data) {
		this.data = data;
	}

	/**
	 * @return the firstId
	 */
	public int getFirstId() {
		return firstId;
	}

	/**
	 * @param firstId the firstId to set
	 */
	public void setFirstId(int firstId) {
		this.firstId = firstId;
	}
}
