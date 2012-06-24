package com.fengxiafei.core.qrcode.samples;

import com.fengxiafei.core.ActionStatus;

public class MakeCodeAllResponseBean extends ActionStatus{
	private MakeCodeResponseBean data = null;

	public void setData(MakeCodeResponseBean data) {
		this.data = data;
	}

	public MakeCodeResponseBean getData() {
		return data;
	}
	 
}