package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

public class ShortMessage extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String phone;
	private String content;

	public ShortMessage() {
		super();
	}

	/**
	 * @return the phone
	 */
	public String getPhone() {
		return phone;
	}

	/**
	 * @param phone
	 *            the phone to set
	 */
	public void setPhone(String phone) {
		this.phone = phone;
	}

	/**
	 * @return the content
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content
	 *            the content to set
	 */
	public void setContent(String content) {
		this.content = content;
	}
}
