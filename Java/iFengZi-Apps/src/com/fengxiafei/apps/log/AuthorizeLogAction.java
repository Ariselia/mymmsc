package com.fengxiafei.apps.log;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 微薄授权
 * 
 * @author bichao
 * 
 */
public class AuthorizeLogAction extends AppAction {
	private static final Log LOG = LogFactory.getLog("MyLog");
	private static final String appLog = "/apps/log/authorizeLog";

	@Override
	public String doService() {
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		ActionStatus result = new ActionStatus();
		int baseError = 300;
		try {
			LOG.info("MobileLog:" + appLog + "?" + request);
			result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
		} catch (Exception e) {
			LOG.error("微薄授权异常", e);
			result.set(baseError + 1, "微薄授权异常");
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	@Override
	public void close() {
		//
	}

}
