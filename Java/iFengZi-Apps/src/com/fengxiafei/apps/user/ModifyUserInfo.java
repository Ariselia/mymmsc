/**
 * 
 */
package com.fengxiafei.apps.user;

import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 查看个人信息
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码196~199
 * 
 */
public class ModifyUserInfo extends AppAction {
	private int userId;
	private String realname;
	private Integer sex;
	private String email;
	private String birthday;
	private String idNumber;
	private String address;
	private String postCode;
	private String likes;
	// private Date regTime;
	// private Date modTime;
	private Integer isopen;
	private String weibo;
	private Long QQ;
	private String contact;

	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 195;
		ActionStatus result = new ActionStatus();
		if (userId < 0) {
			result.set(baseError + 1, "用户ID不能为空");
		} else {
			String sql = "UPDATE `users_info` SET `realname`=?,`sex`=?,`email`=?,`birthday`=?,`idNumber`=?,`address`=?,`postCode`=?,`likes`=?,`isopen`=?,`weibo`=?,`QQ`=?,`contact`=? WHERE `userid`=?";
			int num = SQLApi.execute(Consts.DataSource, sql, realname, sex,
					email, birthday, idNumber, address, postCode, likes,
					isopen, weibo, QQ, contact, userId);
			if (num < 1) {
				sql = "INSERT INTO `users_info` (`realname`,`sex`,`email`,`birthday`,`idNumber`,`address`,`postCode`,`likes`,`isopen`,`weibo`,`QQ`,`contact`,`userId`) VALUES(?, ?, ?, ?, ?, ?,	?, ?, ?, ?, ?, ?, ?)";
				num = SQLApi.execute(Consts.DataSource, sql, realname, sex,
						email, birthday, idNumber, address, postCode, likes,
						isopen, weibo, QQ, contact, userId);
				if (num <= 1) {
					result.set(baseError + 2, "添加用户信息操作失败");
				} else {
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
				}
			} else {
				result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
			}
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		//
	}

	/**
	 * @return the userId
	 */
	public int getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getRealname() {
		return realname;
	}

	public Integer getSex() {
		return sex;
	}

	public String getEmail() {
		return email;
	}

	public String getBirthday() {
		return birthday;
	}

	public String getIdNumber() {
		return idNumber;
	}

	public String getAddress() {
		return address;
	}

	public String getPostCode() {
		return postCode;
	}

	public String getLikes() {
		return likes;
	}

	public Integer getIsopen() {
		return isopen;
	}

	public String getWeibo() {
		return weibo;
	}

	public Long getQQ() {
		return QQ;
	}

	public String getContact() {
		return contact;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public void setIdNumber(String idNumber) {
		this.idNumber = idNumber;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public void setLikes(String likes) {
		this.likes = likes;
	}

	public void setIsopen(Integer isopen) {
		this.isopen = isopen;
	}

	public void setWeibo(String weibo) {
		this.weibo = weibo;
	}

	public void setQQ(Long qQ) {
		QQ = qQ;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}
}
