package org.mymmsc.api.context.samples;

import com.fengxiafei.core.ActionStatus;

public class FileUploadALlResponse extends ActionStatus{
	private FileUploadResponseBean data = null;

	public void setData(FileUploadResponseBean data) {
		this.data = data;
	}

	public FileUploadResponseBean getData() {
		return data;
	} 
	 
}