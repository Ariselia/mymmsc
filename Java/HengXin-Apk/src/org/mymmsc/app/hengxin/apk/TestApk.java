/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.assembly.XmlParser;
import org.mymmsc.api.context.Templator;
import org.mymmsc.api.io.FileApi;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.sun.org.apache.regexp.internal.recompile;

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
	
	public static void addPermission(Node root, String value) {
		org.w3c.dom.Element node = root.getOwnerDocument().createElement("uses-permission");
		node.setAttribute("android:name", value);
		root.appendChild(node);
	}
	
	public static boolean findPermisson(XmlParser xp, String value) {
		boolean bRet = false;
		NodeList list = null;
		try {
			String exp = String.format("//uses-permission[@name='%s']", value);
			list = xp.query(exp);
			if (list.getLength() > 0) {
				bRet = true;
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return bRet;
	}
	
	public static void fixPermisson(XmlParser xp, Node root) {
		//<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
		String v = "android.permission.READ_PHONE_STATE";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
		//<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
		v = "android.permission.RECEIVE_BOOT_COMPLETED";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
	    //<uses-permission android:name="android.permission.INTERNET" />
		v = "android.permission.INTERNET";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
	}
	
	public static void fixMain(XmlParser xp) {
		try {
			NodeList list = xp.query("//activity/intent-filter/action[@name='android.intent.action.MAIN']");
			if (list != null && list.getLength() > 0) {
				Node oldNode = null;
				Node node = list.item(0);
				node = node.getParentNode().getParentNode();
				oldNode = node.cloneNode(false);
				node.getParentNode().appendChild(oldNode);
				Element e = (Element)node;
				e.setAttribute("android:name", "com.hengxin.log.main.HengxinLogActivity");
				String name = xp.valueOf(node, "android:name");
				System.out.println("name = " + name);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String dirName = "/Users/wangfeng/temp/apk";
		String apkName = "feng";
		//ApkTool.unpack(dirName + "/feng.apk", dirName + "/" + apkName);
		String xmlFile = dirName + "/" + apkName + "/" + Category.Manifest;
		try {
			FileApi.copyFile(new File(xmlFile + ".bak"), new File(xmlFile));
			FileApi.copyFile(new File(xmlFile), new File(xmlFile + ".bak"));
			FileApi.copyDirectiory(dirName + "/smali", dirName + "/" + apkName + "/smali");
			String smaliFile = dirName + "/" + apkName + "/smali/com/hengxin/log/main/HengxinMainActivity.smali";
			Templator tpl = new Templator(smaliFile, "utf-8");
			tpl.setVariable("app_id", "1");
			tpl.setVariable("channel_id", "2");
			tpl.generateOutput(smaliFile);
			
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		XmlParser xp = new XmlParser(xmlFile, false);
		// 获取根节点
		try {
			NodeList list = xp.query("/manifest");
			if (list != null && list.getLength() >0) {
				Node root = list.item(0);
				fixMain(xp);
				fixPermisson(xp, root);
				try {
					xp.output(xmlFile, "utf-8");
				} catch (TransformerException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SAXException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String pkg = xp.valueOf(root, "package");
				System.out.println("package = " +pkg);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
	}

}
