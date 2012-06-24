package com.fengxiafei.apps.log;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.util.Base64;

/**
 * z 向服务器发送扫描记录信息
 * 
 * @author bichao
 * 
 */
public class ScanLogAction extends AppAction {

	private static final Log LOG = LogFactory.getLog("MyLog");
	private static final String appLog = "/apps/log/scanLog";
	//private String c = "";
	@SuppressWarnings("unused")
	private String a = "";

	@Override
	public String doService() {
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		ActionStatus result = new ActionStatus();
		int baseError = 300;
		try {
			//String param = Base64.decode(a);
			LOG.info("MobileLog:" + appLog + "?" + request);
			result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
		} catch (Exception e) {
			LOG.error("向服务器发送扫描记录异常", e);
			result.set(baseError + 1, "向服务器发送扫描记录异常");
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	@Override
	public void close() {
		//
	}

	public static void main(String[] args) {
		System.out.println("+++++++++++++++++++++++++++++++++++");
		System.out
				.println(Base64
						.decode("pyd-pHY1PHmLnj9kPjNOn1TzrHchIZ-kuHdYug6YFMPYXgK-5HThUAqW5HDQra3QnWmLPikzPa3dPjEQPT"));
		System.out.println("+++++++++++++++++++++++++++++++++++");
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String scantime = format.format(new java.util.Date());
		System.out.println(scantime);
	}
}
