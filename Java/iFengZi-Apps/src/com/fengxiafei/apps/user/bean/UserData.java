package com.fengxiafei.apps.user.bean;

import java.util.Date;


/**
 * 用户信息bean
 * @author wangfeng
 *
 */
public class UserData implements java.io.Serializable {
	// Fields
	private static final long serialVersionUID = 8078792184938340939L;
	private Long userid;
	private String realname;
	private Integer sex;
	private String email;
	private String birthday;
	private String idNumber;
	private String address;
	private String postCode;
	private String likes;
	private Date regTime;
	//private Date modTime;
	private Integer isopen;
	private String weibo;
	private Long QQ;
	private String contact;

	public Long getUserid() {
		return userid;
	}

	public void setUserid(Long userid) {
		this.userid = userid;
	}

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public Integer getSex() {
		return sex;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getIdNumber() {
		return idNumber;
	}

	public void setIdNumber(String idNumber) {
		this.idNumber = idNumber;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getLikes() {
		return likes;
	}

	public void setLikes(String likes) {
		this.likes = likes;
	}

	public Integer getIsopen() {
		return isopen;
	}

	public void setIsopen(Integer isopen) {
		this.isopen = isopen;
	}

	public String getWeibo() {
		return weibo;
	}

	public void setWeibo(String weibo) {
		this.weibo = weibo;
	}

	public Long getQQ() {
		return QQ;
	}

	public void setQQ(Long qQ) {
		QQ = qQ;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	/**
	 * @return the regTime
	 */
	public Date getRegTime() {
		return regTime;
	}

	/**
	 * @param regTime the regTime to set
	 */
	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}
}