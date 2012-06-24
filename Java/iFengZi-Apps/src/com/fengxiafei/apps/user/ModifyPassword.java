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
import com.fengxiafei.apps.user.bean.PasswordBean;
import com.fengxiafei.apps.user.bean.PasswordResp;
import com.fengxiafei.apps.user.bean.UserInfo;
import com.fengxiafei.apps.user.util.UserApi;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.util.Base64;

/**
 * 用户中心 - 修改密码
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码16X
 */
public class ModifyPassword extends AppAction {
	private int userId = -1;
	private String userName = null;
	private String oldPswd = null;
	private String newPswd = null;
	private String checkcode = null;

	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 160;
		PasswordResp result = new PasswordResp();
		String n = Base64.decode(newPswd);
		if (userId < 1 && Api.isEmpty(userName)) {
			result.set(baseError + 1, "用户ID或用户名不能为空");
		} else if (Api.isEmpty(newPswd)) {
			result.set(baseError + 2, "新密码不能为空");
		} else if (n == null) {
			result.set(baseError + 3, "新密码加密算法不正确");
		} else {
			UserInfo ui = null;
			if (userId > 0) {
				ui = UserApi.fromUserId(userId);
			} else {
				ui = UserApi.fromUserName(userName);
			}
			
			String o = Base64.decode(oldPswd);
			if (ui == null) {
				result.set(baseError + 4, "没有这个用户");
			} else if (!Api.isEmpty(checkcode)
					&& !checkcode.equalsIgnoreCase(ui.getCheckcode())) {
				// 忘记密码, 但验证码错误
				result.set(baseError + 5, "验证码错误");
			} else if (Api.isEmpty(checkcode)
					&& Api.isEmpty(oldPswd)) {
				result.set(baseError + 6, "旧密码不能为空");
			} else if (Api.isEmpty(checkcode)
					&& o == null) {
				result.set(baseError + 7, "旧密码加密算法不正确");
			} else if (Api.isEmpty(checkcode)
					&& o == n) {
				// 忘记密码, 但验证码错误
				result.set(baseError + 7, "新旧密码相同, 不能修改");
			} else {
				// 修改密码
				String time = UserApi.now();
				String token = UserApi.genToken(time, ui.getUserid(),
						ui.getKey());
				String sql = "UPDATE `users` SET `password`=?,`token`=?,`modTime`=now(),`lastTime`=? WHERE `id`=?";
				String pswd = UserApi.genPassword(n, ui.getUserid());
				int num = SQLApi.execute(Consts.DataSource, sql, pswd, token,
						time, ui.getId());
				if (num > 0) {
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
					PasswordBean pb = new PasswordBean();
					pb.setUserId(userId);
					pb.setToken(token);
				} else {
					result.set(961, "修改用户密码失败");
				}
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
	 * @return the oldPswd
	 */
	public String getOldPswd() {
		return oldPswd;
	}

	/**
	 * @param oldPswd
	 *            the oldPswd to set
	 */
	public void setOldPswd(String oldPswd) {
		this.oldPswd = oldPswd;
	}

	/**
	 * @return the newPswd
	 */
	public String getNewPswd() {
		return newPswd;
	}

	/**
	 * @param newPswd
	 *            the newPswd to set
	 */
	public void setNewPswd(String newPswd) {
		this.newPswd = newPswd;
	}

	/**
	 * @return the checkcode
	 */
	public String getCheckcode() {
		return checkcode;
	}

	/**
	 * @param checkcode
	 *            the checkcode to set
	 */
	public void setCheckcode(String checkcode) {
		this.checkcode = checkcode;
	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

}
