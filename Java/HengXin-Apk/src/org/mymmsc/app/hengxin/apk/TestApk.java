/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import org.mymmsc.api.io.FileApi;

/**
 * @author wangfeng
 * 
 */
public class TestApk {

	/**
	 * 
	 */
	public TestApk() {
		// TODO Auto-generated constructor stub
	}

	public static void main(String[] args) {
		String dirName = "/Users/wangfeng/Downloads";
		String apkname = dirName + "/" + "CMREAD_Android_WH_V1.71_120620_M2340001.apk";
		byte[] data = FileApi.read(apkname);
		if (data != null) {
			ApkTool at = new ApkTool();
			at.pkgForChannel(data, "123", "mymmsc");
		}
	}
}
