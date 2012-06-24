/**
 * 
 */
package com.fengxiafei.apps.util;

import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;

/**
 * 版本信息
 * 
 * @author wangfeng
 * @version 3.0.2 2012/06/22
 */
public class VersionAction extends AppAction {
	/** 终端类型 */
	private int type = -1;
	
	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		String sRet = "{\"status\":0,\"message\":\"success\",\"data\":{\"version\":\"2.3.2\"}}";
		return sRet;
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
	public int getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(int type) {
		this.type = type;
	}

}
