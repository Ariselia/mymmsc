/**
 * 
 */
package com.fengxiafei.apps.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 意见反馈
 * 
 * @author wangfeng
 * @version 3.0.2 2012/06/22
 */
public class FeedBackAction extends AppAction {
	private static final Log LOG = LogFactory.getLog("MyLog");
	private static final String appLog = "/apps/fb/fb";
	/** 类型 */
	private String type;
	/** 联系方式 */
	private String connection;
	/** 内容 */
	private String content;

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
			LOG.error("向服务器发送意见反馈异常", e);
			result.set(baseError + 1, "向服务器意见反馈异常");
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
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type
	 *            the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * @return the connection
	 */
	public String getConnection() {
		return connection;
	}

	/**
	 * @param connection
	 *            the connection to set
	 */
	public void setConnection(String connection) {
		this.connection = connection;
	}

	/**
	 * @return the content
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content
	 *            the content to set
	 */
	public void setContent(String content) {
		this.content = content;
	}

}
