package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

public class Url extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String content;

	public Url() {
		super();
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}
