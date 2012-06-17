/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.assembly.XmlParser;
import org.mymmsc.api.io.FileApi;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

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
		org.w3c.dom.Element node = root.getOwnerDocument().createElement(
				"uses-permission");
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
		// <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
		String v = "android.permission.READ_PHONE_STATE";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
		// <uses-permission
		// android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
		v = "android.permission.RECEIVE_BOOT_COMPLETED";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
		// <uses-permission android:name="android.permission.INTERNET" />
		v = "android.permission.INTERNET";
		if (!findPermisson(xp, v)) {
			addPermission(root, v);
		}
	}

	public static String fixMain(XmlParser xp) {
		String sRet = "";
		try {
			String exp = "//activity/intent-filter/action[@name='android.intent.action.MAIN']";
			NodeList list = xp.query(exp);
			if (list != null && list.getLength() > 0) {
				Node oldNode = null;
				Node rmNode = list.item(0);
				Node node = rmNode.getParentNode().getParentNode();
				oldNode = node.cloneNode(true);
				sRet = xp.valueOf(oldNode, "android:name");
				node.getParentNode().appendChild(oldNode);
				Element e = (Element) node;
				e.setAttribute("android:name",
						"com.hengxin.log.main.HengxinMainActivity");
				NodeList list2 = xp.query(node, exp);
				if (list2 != null && list2.getLength() >=2) {
					rmNode = list2.item(1);
					//rmNode.getParentNode().removeChild(rmNode);
					e = (Element) rmNode;
					e.setAttribute("android:name", "android.intent.action.VIEW");
				}				
				String name = xp.valueOf(node, "android:name");
				System.out.println("name = " + name);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	/*
	public static void main(String[] args) {
		String dirName = "/Users/wangfeng/temp/apk";
		String apkName = "MobileMusic";
		Api.remove(dirName + "/" + apkName);
		ApkTool.unpack(dirName + "/" + apkName + ".apk", dirName + "/"
				+ apkName);
		String xmlFile = dirName + "/" + apkName + "/" + Category.Manifest;
		XmlParser xp = new XmlParser(xmlFile, false);
		String pkg = null;
		String oldMain = null;
		// 获取根节点
		try {
			NodeList list = xp.query("/manifest");
			if (list != null && list.getLength() > 0) {
				Node root = list.item(0);
				oldMain = fixMain(xp);
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
				pkg = xp.valueOf(root, "package");
				System.out.println("package = " + pkg);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		try {
			FileApi.copyFile(new File(xmlFile), new File(xmlFile + ".bak"));
			FileApi.copyDirectiory(dirName + "/smali", dirName + "/" + apkName
					+ "/smali");
			String smaliFile = dirName + "/" + apkName
					+ "/smali/com/hengxin/log/main/HengxinMainActivity.smali";
			Templator tpl = new Templator(smaliFile, "utf-8");
			tpl.setVariable("app_id", "1");
			tpl.setVariable("channel_id", "2");
			tpl.setVariable("portal", (oldMain.startsWith(".") ? pkg + oldMain
					: oldMain).replaceAll("\\.", "/"));
			tpl.generateOutput(smaliFile);
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		ApkTool.pack(dirName + "/" + apkName);
	}
	*/
	
	public static void main(String[] args) {
		String dirName = "/Users/wangfeng/temp/apk";
		String apkname = dirName + "/" + "Android21_2.5.2.apk";
		byte[] data = FileApi.read(apkname);
		if (data != null) {
			ApkTool at = new ApkTool();
			at.pkgForChannel(data, "123", "mymmsc");
		}
		
	}
}
