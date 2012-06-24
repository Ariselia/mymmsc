/**
 * 
 */
package com.fengxiafei.apps.user;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.UserData;
import com.fengxiafei.apps.user.bean.UserInfo;
import com.fengxiafei.apps.user.bean.UserInfoResp;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 查看个人信息
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码190~195
 * 
 */
public class ViewUserInfo extends AppAction {
	private int userId = -1;
	private String userName = null;

	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 190;
		UserInfoResp result = new UserInfoResp();
		if (userId < 0 && Api.isEmpty(userName)) {
			result.set(baseError + 1, "用户ID或用户名不能为空");
		} else {
			UserData ud = null;
			String sql = null;
			if (!Api.isEmpty(userName)) {
				sql = "SELECT * FROM `users` WHERE `username`=? LIMIT 0,1";
				UserInfo ui = SQLApi.getOneRow(Consts.DataSource,
						UserInfo.class, sql, userName);
				if (ui == null) {
					result.set(baseError + 2, "用户名不正确");
				} else {
					userId = ui.getUserid();
				}
			}
			if (userId > 0) {
				sql = "SELECT * FROM `users_info` WHERE `userid`=? LIMIT 0,1";
				ud = SQLApi.getOneRow(Consts.DataSource, UserData.class, sql,
						userId);
			}
			if (ud == null) {
				result.set(baseError + 1, "用户资料不存在");
			} else {
				result.setData(ud);
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

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName
	 *            the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

}
