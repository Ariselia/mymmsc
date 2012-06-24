package com.fengxiafei.apps.user.bean;

import java.io.Serializable;

/**
 * 码评论记录
 * @author wangfeng
 *
 */
public class CodeComment implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String codeId;
	private int commentUserId;
	private String commentName;
	private String commentContent;
	private String commentDate;
	private int delFlag;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCommentUserId() {
		return commentUserId;
	}

	public void setCommentUserId(int commentUserId) {
		this.commentUserId = commentUserId;
	}

	public String getCommentName() {
		return commentName;
	}

	public void setCommentName(String commentName) {
		this.commentName = commentName;
	}

	public String getCommentContent() {
		return commentContent;
	}

	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}

	public String getCommentDate() {
		return commentDate;
	}

	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}

	public int getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(int delFlag) {
		this.delFlag = delFlag;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		StringBuffer sb = new StringBuffer();
		sb.append("{\"id\":" + id + ",");
		sb.append("{\"maId\":" + codeId + ",");
		sb.append("{\"commentUserId\":" + commentUserId + ",");
		sb.append("{\"commentName\":" + commentName + ",");
		sb.append("{\"commentContent\":" + commentContent + ",");
		sb.append("{\"commentDate\":" + commentDate + ",");
		sb.append("{\"delFlag\":" + delFlag + "}");
		return sb.toString();
	}

	/**
	 * @return the codeId
	 */
	public String getCodeId() {
		return codeId;
	}

	/**
	 * @param codeId the codeId to set
	 */
	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}
}
