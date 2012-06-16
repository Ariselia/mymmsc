/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import org.mymmsc.api.assembly.XmlParser;

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

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String dirName = "/Users/wangfeng/temp/apk";
		ApkTool.unpack(dirName + "/feng.apk", dirName + "/feng1");
		String xmlFile = "/Users/wangfeng/temp/" + Category.Manifest;
		XmlParser xp = new XmlParser(xmlFile, false);
		if(xp == null) {
			System.out.println("xml文件打开: 失败");
		} else {
			System.out.println("xml文件打开: 成功");
		}
	}

}
