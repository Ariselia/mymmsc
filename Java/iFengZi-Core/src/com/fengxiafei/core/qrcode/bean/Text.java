package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

/**
 * 编码 - 文本
 * @author wangfeng
 * @version 3.0.1 12/05/27
 */
public class Text extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String content;

	public Text() {
		super();
	}

	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
}
