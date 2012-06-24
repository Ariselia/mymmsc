package com.fengxiafei.apps.log;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.log.bean.DeviceInfo;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.util.Base64;

/**
 * 向服务器发送手机硬件信息
 * 
 * @author bichao
 * 
 */
public class MobInfoAction extends AppAction {
	private static final Log LOG = LogFactory.getLog("MyLog");
	private static final String appLog = "/apps/log/mobInfo";
	private String t;

	@Override
	public String doService() {
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		ActionStatus result = new ActionStatus();
		int baseError = 300;
		try {
			LOG.info("MobileLog:" + appLog + "?" + request);
			//System.out.println("t=" + t);
			String info = Base64.decode(t);
			System.out.println("info = " + info);
			if (info == null) {
				result.set(Category.API_iEncoding, Category.API_sEncoding);
			} else {
				Map<String, String> map = Api.getParams(info);
				if (map == null || map.size() == 0) {
					result.set(Category.API_iEncoding, Category.API_sEncoding);
				} else {
					DeviceInfo di = Api.valueOf(map, DeviceInfo.class);
					System.out.println(JsonAdapter.get(di, true));
					String sql = "INSERT INTO `log_active` (`active_time`,`s`,`r`,`o`,`v`,`av`,`iv`,`mo`,`simop`,`simnty`,`simng`,`imei`,`version`,`ch`,`mobilenumber`) ";
					sql += "VALUES(current_date(),?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
					SQLApi.insert(Consts.DataSource, sql, 
							di.getS(),di.getR(),di.getO(),di.getV(),di.getAv(),di.getIv(),
							di.getMo(),di.getSimop(),di.getSimnty(),di.getSimng(),di.getImei(),
							di.getVersion(),di.getCh(),di.getMobilenumber());
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
				}				
			}			
		} catch (Exception e) {
			LOG.error("向服务器发送手机硬件信息报错", e);
			result.set(baseError + 1, "向服务器发送手机硬件信息报错");
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	@Override
	public void close() {
		//
	}

	/**
	 * @return the t
	 */
	public String getT() {
		return t;
	}

	/**
	 * @param t
	 *            the t to set
	 */
	public void setT(String t) {
		this.t = t;
	}

}
