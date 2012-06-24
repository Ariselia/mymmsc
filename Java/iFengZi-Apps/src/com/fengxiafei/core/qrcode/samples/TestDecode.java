/**
 * 
 */
package com.fengxiafei.core.qrcode.samples;

import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.io.HttpClient;
import org.mymmsc.api.io.HttpResult;

import com.fengxiafei.core.Category;
import com.fengxiafei.core.CodeAdapter;
import com.fengxiafei.core.qrcode.BaseBean;
import com.fengxiafei.core.qrcode.bean.RichMedia;

/**
 * 二维码生码解码 测试程序
 * 
 * @author wangfeng
 *
 */
public class TestDecode {
	/**
	 *  主函数
	 * @param argv
	 */
	public static void main(String[] argv){
		String string = "05A:12\\;3;B:12\3;C:654;D:321;E:2;F:789;G:1;H:89009@qq.com;I:http\\://www.abc.com;J:3;K:100100;L:89009;M:wangfeng@yeah.net;N:weibo.com/iyuanfen;O:5;P:123;";
		System.out.println(string);
		string = "{\"content\":\"咯摸摸摸\",\"pageList\":[{\"audio\":\"http://f.ifengzi.cn/apps/show.cgi?id=557ad1a8-077b-3b75-b39e-7cfcc14de106&type=mp3\",\"content\":\"咯摸摸摸\",\"image\":\"http://f.ifengzi.cn/apps/show.cgi?id=4f6a89ba-2495-3cb5-9058-efccd97a7bc3&type=jpg\",\"title\":\"张达\"}],\"title\":\"张达\"}";
		HttpClient hc = new HttpClient("http://f.ifengzi.cn/apps/MakeCode.action", 20);
		hc.addField("type", "14");
		hc.addField("title", "123");
		hc.addField("content", string);
		HttpResult hRet = hc.post(null, null);
		System.out.println("http-status=[" + hRet.getStatus() + "], body=["
		+ hRet.getBody() + "], message=" + hRet.getError());

		String result=hRet.getBody();
	 	JsonAdapter parser = JsonAdapter.parse(result);
	 	if (parser != null) {
	 		MakeCodeAllResponseBean obj = parser.get(MakeCodeAllResponseBean.class);
	 		System.out.println(obj);
	 	}
		//Card card = (Card) CodeAdapter.parse(string);
		//String code = CodeAdapter.get(card, true);
		BaseBean bb = (BaseBean) CodeAdapter.parse(string);
		String code = CodeAdapter.get(bb, true);
		System.out.println(code);
		//http://ifengzi.cn/show.cgi?id=10200180
		string = Category.CODE_PREFIX + "?id=10200182";
		//string = "http://ifengzi.cn/show.cgi?08A:Fggh(\\;;B:pyEqFMEqIAR3IauW5HmdP1b1nau15HEhpjYQPHmhI1YQPHmhUjYkFhFM5HThIy-b5HThIgwO0ANqnauWpjYkFhdFUWYz;C:8;";
		BaseBean obj = (BaseBean)CodeAdapter.parse(string);
		System.out.println(obj.type());
		System.out.println(obj.typeName());
		//Text t = (Text)obj;
		RichMedia rb = (RichMedia)obj;
		
		System.out.println(rb.typeName());
		code = CodeAdapter.get(rb, true);
		System.out.println(code);
		
		bb = (RichMedia)CodeAdapter.parse(string);
		System.out.println(bb.typeName());
		code = CodeAdapter.get(bb, true);
		System.out.println(code);		
	}
}
