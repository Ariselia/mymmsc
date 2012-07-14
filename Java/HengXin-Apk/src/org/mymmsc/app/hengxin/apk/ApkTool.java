/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.Environment;
import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.assembly.XmlParser;
import org.mymmsc.api.context.Templator;
import org.mymmsc.api.io.FileApi;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import brut.androlib.Androlib;
import brut.androlib.AndrolibException;
import brut.androlib.ApkDecoder;
//import brut.androlib.ApkDecoder;
import brut.androlib.res.util.ExtFile;
import brut.androlib.src.SmaliBuilder;
import brut.util.BrutIO;

/**
 * APK 再封装
 * 
 * @author wangfeng
 * 
 */
public class ApkTool implements ApkRepackage {
	private String RootPath = null;

	public ApkTool() {
		RootPath = Environment.get("user.home");
		if (!RootPath.endsWith("/runtime")) {
			RootPath += "/runtime";
		}
		RootPath += "/apk";
		Api.mkdirs(RootPath);
	}

	public ApkTool(String apkpath) {
		RootPath = apkpath;
	}

	private InputStream getResource(String name) {
		return this.getClass().getResourceAsStream(name);
	}

	@SuppressWarnings("unused")
	private boolean unpack_NEW(String apk, String output) {
		boolean bRet = false;
		ApkDecoder2 decoder = new ApkDecoder2();
		File outDir = new File(output);
		try {
			decoder.setOutDir(outDir);
			decoder.setApkFile(new File(apk));
			decoder.decode();
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bRet;
	}

	private boolean isModified(File working, File stored) {
		if (!(stored.exists())) {
			return true;
		}
		return (BrutIO.recursiveModifiedTime(working) > BrutIO
				.recursiveModifiedTime(stored));
	}

	public boolean buildSourcesSmali(File appDir, boolean forceBuildAll,
			boolean debug) throws AndrolibException {
		ExtFile smaliDir = new ExtFile(appDir, "smali");
		if (!(smaliDir.exists())) {
			return false;
		}
		File dex = new File(appDir, "build/apk/classes.dex");
		if (!(forceBuildAll)) {
			System.out.println("Checking whether sources has changed...");
		}
		if ((forceBuildAll) || (isModified(smaliDir, dex))) {
			System.out.println("Smaling...");
			dex.delete();
			SmaliBuilder.build(smaliDir, dex, debug);
		}
		return true;
	}

	@SuppressWarnings("unused")
	private boolean pack_NEW(String apkpath, String apkname) {
		boolean bRet = false;
		String in = apkname + "_new.tmp";
		File outFile = new File(in);
		Api.remove(in);
		Api.remove(apkname);
		File appDir = new File(apkpath);
		try {
			buildSourcesSmali(appDir, true, true);
		} catch (AndrolibException e1) {
			e1.printStackTrace();
		}
		Androlib al = new Androlib();
		try {
			al.build(new File(apkpath), outFile, true, true);
			bRet = SignApk.sign(getResource(Category.PEM),
					getResource(Category.PK8), in, apkname);
			Api.remove(in);
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		}
		return bRet;
	}

	private boolean unpack(String apk, String output) {
		boolean bRet = false;
		ApkDecoder decoder = new ApkDecoder();
		File outDir = new File(output);
		try {
			decoder.setOutDir(outDir);
			decoder.setApkFile(new File(apk));
			decoder.decode();
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bRet;
	}

	private boolean pack(String apkpath, String apkname) {
		boolean bRet = false;
		String in = apkname + "_new.tmp";
		File outFile = new File(in);
		Api.remove(in);
		Api.remove(apkname);
		Androlib al = new Androlib();
		try {
			al.build(new File(apkpath), outFile, true, true);
			bRet = SignApk.sign(getResource(Category.PEM),
					getResource(Category.PK8), in, apkname);
			Api.remove(in);
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		}
		return bRet;
	}

	private void addPermission(Node root, String value) {
		org.w3c.dom.Element node = root.getOwnerDocument().createElement(
				"uses-permission");
		node.setAttribute("android:name", value);
		root.appendChild(node);
	}

	private boolean findPermisson(XmlParser xp, String value) {
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

	private void fixPermisson(XmlParser xp, Node root) {
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

	private String fixMain(XmlParser xp) {
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
				if (list2 != null && list2.getLength() >= 2) {
					rmNode = list2.item(list2.getLength() - 1);
					rmNode.getParentNode().removeChild(rmNode);
					// e = (Element) rmNode;
					// e.setAttribute("android:name",
					// "android.intent.action.VIEW");
				}
				String name = xp.valueOf(node, "android:name");
				System.out.println("name = " + name);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	@Override
	public byte[] pkgForChannel(byte[] input, String appId, String channelId) {
		byte[] oRet = input;
		// 随机一个文件名
		String name = Api.o3String(10);
		String apkName = name + ".apk";
		String apkDir = RootPath + "/" + name;
		String apkFile = RootPath + "/old/" + apkName;
		String apkNew = RootPath + "/" + apkName;
		boolean result = false;
		try {
			FileApi.write(apkFile, input);
			result = unpack(apkFile, apkDir);
			if (result) {
				String xmlFile = apkDir + "/" + Category.Manifest;
				InputStream is = new FileInputStream(xmlFile);
				XmlParser xp = new XmlParser(is);
				String pkg = null;
				String portal = null;
				// 获取根节点
				NodeList list = xp.query("/manifest");
				// 一般都会有, 要是没有, 也没法
				if (list != null && list.getLength() > 0) {
					Node root = list.item(0);
					portal = fixMain(xp);
					fixPermisson(xp, root);
					xp.output(xmlFile, "utf-8");
					pkg = xp.valueOf(root, "package");
					System.out.println("package = " + pkg);
					// FileApi.copyFile(new File(xmlFile), new File(xmlFile +
					// ".bak"));
					FileApi.copyDirectiory(RootPath + "/smali", apkDir
							+ "/smali");
					String smaliFile = apkDir
							+ "/smali/com/hengxin/log/main/HengxinMainActivity.smali";
					Templator tpl = new Templator(smaliFile, "utf-8");
					tpl.setVariable("app_id", appId);
					tpl.setVariable("channel_id", channelId);
					tpl.setVariable("portal", (portal.startsWith(".") ? pkg
							+ portal : portal).replaceAll("\\.", "/"));
					tpl.generateOutput(smaliFile);
				}
				result = pack(apkDir, apkNew);
				if (result) {
					oRet = FileApi.read(apkNew);
				}
			} else {
				System.out.println("failed!");
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		return oRet;
	}
}
