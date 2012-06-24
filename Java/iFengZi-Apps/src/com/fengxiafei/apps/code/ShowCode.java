/**
 * 
 */
package com.fengxiafei.apps.code;

import java.io.IOException;

import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.assembly.XmlParser;
import org.mymmsc.api.context.TemplateSyntaxException;
import org.mymmsc.api.context.Templator;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.CodeAdapter;
import com.fengxiafei.core.qrcode.BaseBean;

/**
 * 二维码展示
 * 
 * @author wangfeng
 * @version 3.0.1 2012/06/05
 * @remark 主要作用是为了非蜂子客户端显示码内容
 */
public class ShowCode extends AppAction {
	
	@Override
	public String doService() {
		String sRet = null;
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		Object obj =  CodeAdapter.parse(request);
		if (obj != null) {
			BaseBean code = (BaseBean)obj;
			if (code.type() > 13) {
				return "富媒体二维码，请前往www.ifengzi.cn下载蜂子客户端体验精彩内容";
			}
			// 初始化模板
			try {
				Templator tpl = getTemplate("show.html");
				htmlSetVariable(tpl, "title", code.typeName());
				htmlSetVariable(tpl, "CONTENT", code.typeName());
				XmlParser xp = adapter.getXmlParser();
				String exp = String.format("//show/code[@type='%d']/*", code.getTypeId());
				NodeList list = xp.query(exp);
				if (list != null && list.getLength() > 0) {
					int count = list.getLength();
					String blkField = "list";
					String blkObject = "input";
					for (int i = 0; i < count; i++) {
						Node node = list.item(i);
						String fieldId = xp.valueOf(node, "name");
						String fieldName = xp.valueOf(node, "text");
						String fieldValue = Api.toString(Api.getValue(obj, fieldId));
						htmlSetVariable(tpl, blkField + ".field", fieldId);
						htmlSetVariable(tpl, blkField + ".name", fieldName);
						htmlSetVariable(tpl, blkField + "." + blkObject
								+ ".field", fieldId);
						htmlSetVariable(tpl, blkField + "." + blkObject
								+ ".value", fieldValue);
						htmlAddBlock(tpl, blkObject);
						htmlAddBlock(tpl, blkField);
					}
					sRet = tpl.generateOutput();
				}
			} catch (TemplateSyntaxException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (XPathExpressionException e) {
				e.printStackTrace();
			}
		}
		return sRet;
	}

	/* (non-Javadoc)
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		//
	}

}
