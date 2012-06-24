/**
 * 
 */
package com.fengxiafei.apps;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.j2ee.struts.HttpAction;

/**
 * 应用适配器
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 */
public abstract class AppAction extends HttpAction {
	private String fengziToken = null;
	private String fengziIMEI = null;
	private String fengziControl = null;
	
	protected String uri() {
		return "/apps/" + this.getClass().getSimpleName();
	}
	
	/**
	 * 业务实现接口
	 * @return
	 */
	protected abstract String doService();
	
	@Override
	public byte[] execute(){
		info("uri=" + uri() + ", token=" + httpSession.getAttribute("token"));
		byte[] aRet = null;
		try {
			String result = doService();
			if (!Api.isEmpty(result)) {
				aRet = result.getBytes(getCharset());
			}
		} catch (Exception e) {
			error(e);
		}
		return aRet;
	}
	
	protected boolean checkToken(int userId) {
		boolean bRet = false;
		bRet = true;
		return bRet;
	}

	/**
	 * @return the fengziToken
	 */
	public String getFengziToken() {
		return fengziToken;
	}

	/**
	 * @param fengziToken
	 *            the fengziToken to set
	 */
	public void setFengziToken(String fengziToken) {
		this.fengziToken = fengziToken;
	}

	/**
	 * @return the fengziIMEI
	 */
	public String getFengziIMEI() {
		return fengziIMEI;
	}

	/**
	 * @param fengziIMEI the fengziIMEI to set
	 */
	public void setFengziIMEI(String fengziIMEI) {
		this.fengziIMEI = fengziIMEI;
	}

	/**
	 * @return the fengziControl
	 */
	public String getFengziControl() {
		return fengziControl;
	}

	/**
	 * @param fengziControl the fengziControl to set
	 */
	public void setFengziControl(String fengziControl) {
		this.fengziControl = fengziControl;
	}
}
