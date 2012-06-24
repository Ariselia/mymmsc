/**
 * @(#)TestJsonAdapter.java	6.3.12 2012/05/11
 *
 * Copyright 2000-2010 MyMMSC Software Foundation (MSF), Inc. All rights reserved.
 * MyMMSC PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package org.mymmsc.api.context.samples;

import org.mymmsc.api.context.JsonAdapter;

/**
 * 测试JSON解析器
 * 
 * @author WangFeng(wangfeng@yeah.net)
 * @version 6.3.12 2012/05/11
 * @since mymmsc-api 6.3.12
 * @since mymmsc-api 6.3.9
 */
public class TestJsonAdapter {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String string = "{\"order\":{\"id\":123,\"name\":\"bichao\"},\"status\":0,\"message\":\"success\",\"bills\":[{\"amount\":\"11\",\"test\":{\"amount\":\"12\",\"billId\":\"billid2\"},\"billId\":\"billid1\"},{\"amount\":\"13\",\"billId\":\"billid3\"}]}";
		//String string = "{\"bills\":[{\"amount\":\"11\",\"test\":{\"amount\":\"12\",\"billId\":\"billid2\"},\"billId\":\"billid1\"},{\"amount\":\"13\",\"billId\":\"billid3\"}]}";
		System.out.println("第1次 ===>");
		System.out.println("       原json串: " + string);
		// 解析JSON串, 有可能因解析失败返回null
		JsonAdapter parser = JsonAdapter.parse(string);
		if (parser != null) {
			TObject obj = parser.get(TObject.class);
			//System.out.println(Api.getClass(obj, "bills"));
			System.out.println("       输出bean: "  + obj);
			string = JsonAdapter.get(obj, true);
			System.out.println("输出bean的JSON串: "  + string);
			// 最后释放资源
			parser.close();
			System.out.println("第2次 ===>");
			parser = JsonAdapter.parse(string);
			obj = parser.get(TObject.class);
			//System.out.println(Api.getClass(obj, "bills"));
			System.out.println("       输出bean: "  + obj);
			string = JsonAdapter.get(obj, true);
			System.out.println("输出bean的JSON串: "  + string);
			
			Test test = new Test();
			test.setAmount("1");
			test.setBillId("2");
			System.out.println("输出bean的JSON串: "  + JsonAdapter.get(test, false));
			
			string = "{\"data\":{\"type\":2,\"filetype\":\"jpg\",\"fileurl\":\"http://f.ifengzi.cn/apps/show.cgi?id=cc0c0c15-cb0b-4e1c-bdf5-9efadef4e075&type=jpg\"},\"status\":0,\"message\":\"success\"}";
			parser = JsonAdapter.parse(string);
			FileUploadALlResponse far = parser.get(FileUploadALlResponse.class);
			System.out.println(far);
			
			
		}
	}

}
