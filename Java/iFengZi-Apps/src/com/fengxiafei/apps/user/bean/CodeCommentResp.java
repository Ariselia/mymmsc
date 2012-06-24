/**
 * 
 */
package com.fengxiafei.apps.user.bean;

import java.util.List;

import com.fengxiafei.core.ActionStatus;

/**
 * 码评论
 * 
 * @author wangfeng
 *
 */
public class CodeCommentResp extends ActionStatus {
	private List<CodeComment> data = null;
	/** 最新的记录ID, 仅对返回List数组有效 */
	private int firstId = -1;
	
	/**
	 * @return the data
	 */
	public List<CodeComment> getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(List<CodeComment> data) {
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
