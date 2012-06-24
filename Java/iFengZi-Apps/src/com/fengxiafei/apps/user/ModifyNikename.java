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
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 修改昵称
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码17X
 * 
 */
public class ModifyNikename extends AppAction {
	private int userId = -1;
	private String nikeName = null;

	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 170;
		ActionStatus result = new ActionStatus();
		if (userId < 1) {
			result.set(baseError + 1, "用户ID不能为空");
		} else if (Api.isEmpty(nikeName)) {
			result.set(baseError + 2, "昵称不能为空");
		} else {
			String sql = "UPDATE `users` SET `nikename`=? WHERE `userid`=?";
			int num = SQLApi.execute(Consts.DataSource, sql, nikeName, userId);
			if (num > 0) {
				result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
			} else {
				result.set(baseError + 3, "修改昵称失败");
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
	 * @return the nikeName
	 */
	public String getNikeName() {
		return nikeName;
	}

	/**
	 * @param nikeName
	 *            the nikeName to set
	 */
	public void setNikeName(String nikeName) {
		this.nikeName = nikeName;
	}

}
