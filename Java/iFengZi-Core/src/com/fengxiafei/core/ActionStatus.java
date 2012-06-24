/**
 * 
 */
package com.fengxiafei.core;

import org.mymmsc.api.assembly.Api;

/**
 * Action响应状态bean
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 所有接口的响应都会继承这个类
 */
public class ActionStatus {
	/** 状态码 */
	private int status;
	/** 状态描述 */
	private String message;
	
	public ActionStatus() {
		status = 900;
		message = "Unknown error.";
	}

	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}

	/**
	 * @param status
	 *            the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}

	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * @param message
	 *            the message to set
	 */
	public void setMessage(String message) {
		this.message = Api.getLocalIp() + ": " + message;
	}
	
	/**
	 * 设定操作状态信息
	 * @param status 状态码
	 * @param message 状态描述
	 */
	public void set(int status, String message) {
		setStatus(status);
		setMessage(message);
	}
}
