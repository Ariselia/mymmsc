/**
 * 
 */
package com.fengxiafei.core.qrcode.bean;

import com.fengxiafei.core.qrcode.BaseBean;

/**
 * @author wangfeng
 * 
 */
public class KMA extends BaseBean {
	private static final long serialVersionUID = 1L;
	private String codeId;
	
	public KMA() {
		super();
	}

	/**
	 * @return the codeId
	 */
	public String getCodeId() {
		return codeId;
	}

	/**
	 * @param codeId the codeId to set
	 */
	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}
}
