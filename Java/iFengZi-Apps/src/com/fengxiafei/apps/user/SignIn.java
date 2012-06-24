/**
 * 
 */
package com.fengxiafei.apps.user;

import java.sql.Connection;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.SigninBean;
import com.fengxiafei.apps.user.bean.SigninResp;
import com.fengxiafei.apps.user.bean.UserInfo;
import com.fengxiafei.apps.user.util.UserApi;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.util.Base64;

/**
 * 用户中心 - 登录
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码10X
 */
public class SignIn extends AppAction {
	private String username;
	private String password;
	private String checkcode;
	private Integer utype;
	
	/* (non-Javadoc)
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		addHeader("Content-Type", "application/json; charset=utf-8");
		int baseError = 100;
		SigninBean resp = new SigninBean();
		// 首先记录日志
		info("username=" + username + ",password=" + password
				+ ",checkcode=" + checkcode + ",username=" + username);
		if (Api.isEmpty(username)) {
			resp.setStatus(baseError + 1);
			resp.setMessage("用户名不能为空");
		} else if (Api.isEmpty(password)) {
			resp.setStatus(baseError + 2);
			resp.setMessage("密码不能为空");
		} else {
			Connection conn = SQLApi.getConnection(Consts.DataSource);
			if (conn == null) {
				resp.setStatus(901);
				resp.setMessage("数据库繁忙");
			} else {
				int userError = baseError + 10;
				
				try {
					// 读取ifengzi.users数据表
					UserInfo ub = SQLApi.getRow(conn, UserInfo.class, "SELECT * FROM `users` WHERE `username`=?", username);
					if (ub == null) {
						resp.setStatus(userError + 1);
						resp.setMessage("用户帐号不存在");
					} else {
						// 检查密码
						String pswd = Base64.decode(password);
						if (pswd == null) {
							resp.setStatus(userError + 2);
							resp.setMessage("密码加密算法不正确");
						} else {
							String md5pswd1 = UserApi.genPassword(password, ub.getUserid());
							String md5pswd2 = UserApi.genPassword(pswd, ub.getUserid());
							if (!md5pswd1.equalsIgnoreCase(ub.getPassword()) && !md5pswd2.equalsIgnoreCase(ub.getPassword())) {
								resp.setStatus(userError + 3);
								resp.setMessage("用户密码错误");
							} else {
								if (Api.isEmpty(ub.getNikename())) {
									ub.setNikename("匿名");
								}
								resp.setStatus(Category.API_iSUCCESS);
								resp.setMessage(Category.API_sSUCCESS);
								String time = UserApi.now();
								String token = UserApi.genToken(time, ub.getUserid(), ub.getKey());
								String sql = "UPDATE `users` SET `token`=?,`lastTime`=? WHERE `id`=?";
								SQLApi.execute(conn, sql, token, time, ub.getId());
								SigninResp sr = new SigninResp();
								sr.setUserId(ub.getUserid());
								sr.setNikename(ub.getNikename());
								sr.setToken(token);
								resp.setData(sr);
								httpSession.setAttribute("token", token);
								httpSession.setMaxInactiveInterval(30);
								System.out.println("token=" + token);
							}
						}
					}
				} finally {
					SQLApi.closeQuietly(conn);
				}
				
			}
		}
		String result = JsonAdapter.get(resp, true);
		info(resp);
		return result;
	}

	/* (non-Javadoc)
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		//
	}

	/**
	 * @return the username
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * @param username the username to set
	 */
	public void setUsername(String username) {
		this.username = username;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the checkcode
	 */
	public String getCheckcode() {
		return checkcode;
	}

	/**
	 * @param checkcode the checkcode to set
	 */
	public void setCheckcode(String checkcode) {
		this.checkcode = checkcode;
	}

	/**
	 * @return the utype
	 */
	public Integer getUtype() {
		return utype;
	}

	/**
	 * @param utype the utype to set
	 */
	public void setUtype(Integer utype) {
		this.utype = utype;
	}

}
