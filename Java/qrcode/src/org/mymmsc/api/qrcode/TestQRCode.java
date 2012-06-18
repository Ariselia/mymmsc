/**
 * 
 */
package org.mymmsc.api.qrcode;


/**
 * @author wangfeng
 *
 */
public class TestQRCode {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String filename = "/Users/wangfeng/temp/test.jpg";
		CodeApi.createQRCode(filename, "helloword!");
	}

}
