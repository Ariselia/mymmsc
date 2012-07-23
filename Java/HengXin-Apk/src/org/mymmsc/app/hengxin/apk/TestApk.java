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
		String apkname = dirName + "/" + "fetion_android-3.1.4-GEN-GENERIC-1.6-release-1.apk";
		byte[] data = FileApi.read(apkname);
		if (data != null) {
			ApkTool at = new ApkTool();
			at.pkgForChannel(data, "123", "mymmsc");
		}
	}
}
