package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

/**
 * 名片业务
 * 
 * @author wuhao
 * @since 20111111
 */
public class Card extends BaseBean {
	private static final long serialVersionUID = 1L;

	private String name;
	private String title;
	private String department;
	private String corporation;
	private String cellpone;
	private String telephone;
	private String fax;
	private String email;
	private String url;
	private String address;
	private String zipCode;
	private String qq;
	private String msn;
	private String weibo;
	
	public Card() {
		super();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getCorporation() {
		return corporation;
	}

	public void setCorporation(String corporation) {
		this.corporation = corporation;
	}

	public String getCellpone() {
		return cellpone;
	}

	public void setCellpone(String cellpone) {
		this.cellpone = cellpone;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getMsn() {
		return msn;
	}

	public void setMsn(String msn) {
		this.msn = msn;
	}

	public String getWeibo() {
		return weibo;
	}

	public void setWeibo(String weibo) {
		this.weibo = weibo;
	}
}
