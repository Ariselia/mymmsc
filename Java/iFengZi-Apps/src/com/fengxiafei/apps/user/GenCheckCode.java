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
import com.fengxiafei.apps.user.bean.UserInfo;
import com.fengxiafei.apps.user.util.SmsApi;
import com.fengxiafei.apps.user.util.UserApi;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 短信验证码
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码12X
 * 
 */
public class GenCheckCode extends AppAction {
	/** 用户名 */
	private String username = null;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 120;
		ActionStatus result = new ActionStatus();
		if (Api.isEmpty(username)) {
			result.setStatus(baseError + 1);
			result.setMessage("用户名不能为空");
		} else {
			int ret = -1;
			String cc = UserApi.genCheckCode(4);
			UserInfo user = SQLApi.getOneRow(Consts.DataSource, UserInfo.class, "SELECT * FROM `users` WHERE username=? LIMIT 0,1", username);
			if (user == null) {
				String sql = "INSERT INTO `users` (`flag`,`userid`,`username`,`key`,`checkcode`) VALUES('00',-1,?,'ifengzi',?)";
				ret = SQLApi.insert(Consts.DataSource, sql, username, cc);
				if (ret < 1) {
					result.setStatus(911);
					result.setMessage("数据库操作失败, 添加验证码失败");
				}
			} else {
				String sql = "UPDATE `users` set `checkcode`=? WHERE `username`=?";
				ret = SQLApi.execute(Consts.DataSource, sql, cc, username);
				if (ret < 1) {
					result.setStatus(912);
					result.setMessage("数据库操作失败, 修改验证码失败");
				}
			}
			if (ret > 0) {
				String smsDesc = "欢迎使用蜂子！您的验证码为：" + cc
						+ " 验证码有效时间为15分钟，请尽快注册。【蜂侠飞】";
				SmsApi api = SmsApi.getApi(adapter);
				if (!api.send(username, smsDesc)) {
					result.setStatus(baseError + 2);
					result.setMessage("短信发送失败, 请重试");
				} else {
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
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
	 * @return the username
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * @param username
	 *            the username to set
	 */
	public void setUsername(String username) {
		this.username = username;
	}

}
