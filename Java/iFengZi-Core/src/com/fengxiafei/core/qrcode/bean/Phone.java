package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

public class Phone extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String telephone;

	public Phone() {
		super();
	}

	
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
}
