/**
 * 
 */
package com.fengxiafei.core.qrcode;

import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.qrcode.bean.RichMedia;

/**
 * @author wangfeng
 *
 */
public class KmaBean extends ActionStatus{
	private RichMedia data = null;

	/**
	 * @return the data
	 */
	public RichMedia getData() {
		return data;
	}

	/**
	 * @param data the data to set
	 */
	public void setData(RichMedia data) {
		this.data = data;
	}
}
