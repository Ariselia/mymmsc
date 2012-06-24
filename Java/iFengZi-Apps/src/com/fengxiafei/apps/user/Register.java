/**
 * 
 */
package com.fengxiafei.apps.user;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.UserInfo;
import com.fengxiafei.apps.user.util.UserApi;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.util.Base64;

/**
 * 用户中心 - 注册
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码13X
 */
public class Register extends AppAction {
	private String username = null;
	private String password = null;
	private String nikename = null;
	private String checkcode = null;
	
	/* (non-Javadoc)
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		int baseError = 130;
		ActionStatus result = new ActionStatus();
		if (Api.isEmpty(username)) {
			result.set(baseError + 1, "用户不能为空");
		} else if (Api.isEmpty(password)) {
			result.set(baseError + 2, "密码不能为空");
		} else if (Api.isEmpty(checkcode)) {
			result.set(baseError + 3, "验证码不能为空");
		} else {
			// 开始处理流程
			UserInfo ub = UserApi.fromUserName(username);
			if (ub == null) {
				result.set(baseError + 4, "验证码无效");
			} else if (!ub.getCheckcode().equalsIgnoreCase(checkcode)) {
				result.set(baseError + 4, "验证码错误");
			} else if (ub.getUserid() > 0) {
				result.set(baseError + 5, "用户已经存在");
			} else {
				// 检查正确了
				String pswd = Base64.decode(password);
				if (pswd == null) {
					result.set(baseError + 6, "密码加密算法不正确");
				} else {
					ub.setPassword(pswd);
					ub.setNikename(nikename);
					boolean ret = UserApi.addUser(ub);
					if (ret) {
						result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
					} else {
						result.set(baseError + 7, "注册失败");
					}
				}
				
			}
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	/* (non-Javadoc)
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		// 此处释放资源
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
	 * @return the nikename
	 */
	public String getNikename() {
		return nikename;
	}

	/**
	 * @param nikename the nikename to set
	 */
	public void setNikename(String nikename) {
		this.nikename = nikename;
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

}
