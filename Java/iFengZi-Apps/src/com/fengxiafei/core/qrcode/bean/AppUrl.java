package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

/**
 * 业务类型bean
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 */
public class AppUrl extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String url;
	private String title;

	public AppUrl() {
		super();
	}
	
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title
	 *            the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}
}
