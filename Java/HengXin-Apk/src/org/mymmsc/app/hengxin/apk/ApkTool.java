/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.CRC32;
import java.util.zip.CheckedInputStream;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

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

	/** 压缩一个文件 */
	private void compressFile(File file, ZipOutputStream out, String basedir) {
		if (!file.exists()) {
			return;
		}
		try {
			BufferedInputStream bis = new BufferedInputStream(
					new FileInputStream(file));
			ZipEntry entry = new ZipEntry(basedir + file.getName());
			out.putNextEntry(entry);
			int count;
			byte data[] = new byte[1024 * 10];
			while ((count = bis.read(data, 0, 1024 * 10)) != -1) {
				out.write(data, 0, count);
			}
			bis.close();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 使用 java api 中的 ZipInputStream 类解压文件，但如果压缩时采用了
	 * org.apache.tools.zip.ZipOutputStream时，而不是 java 类库中的
	 * java.util.zip.ZipOutputStream时，该方法不能使用，原因就是编码方 式不一致导致，运行时会抛如下异常：
	 * java.lang.IllegalArgumentException at
	 * java.util.zip.ZipInputStream.getUTF8String(ZipInputStream.java:290)
	 * 当然，如果压缩包使用的是java类库的java.util.zip.ZipOutputStream 压缩而成是不会有问题的，但它不支持中文 @param
	 * archive 压缩包路径@param decompressDir 解压路径 @throws FileNotFoundException * @throws
	 * IOException
	 */
	public static void readByZipInputStream(String archive, ZipOutputStream out)
			throws FileNotFoundException, IOException {
		BufferedInputStream bi;
		// ----解压文件(ZIP文件的解压缩实质上就是从输入流中读取数据):
		System.out.println("开始读压缩文件,111");

		// 这是解压ZIP格式的操作

		FileInputStream fi = new FileInputStream(archive);
		CheckedInputStream csumi = new CheckedInputStream(fi, new CRC32());
		ZipInputStream in2 = new ZipInputStream(csumi);
		bi = new BufferedInputStream(in2);
		java.util.zip.ZipEntry ze;// 压缩文件条目

		// end

		// 遍历压缩包中的文件条目
		while ((ze = in2.getNextEntry()) != null) {
			String entryName = ze.getName();
			if (entryName.equalsIgnoreCase(Category.Manifest)) {
				continue;
			} else if (entryName.equalsIgnoreCase("classes.dex")) {
				continue;
			} else if (entryName.startsWith("META-INF/")) {
				continue;
			}
			ZipEntry entry = new ZipEntry(entryName);
			out.putNextEntry(entry);
			System.out.println("正在创建解压文件 - " + entryName);
			byte[] buffer = new byte[1024];
			int readCount = bi.read(buffer);

			while (readCount != -1) {
				out.write(buffer, 0, readCount);
				readCount = bi.read(buffer);
			}
		}
		bi.close();
		System.out.println("Checksum: " + csumi.getChecksum().getValue());
	}

	/**
	 * 使用 java api 中的 ZipInputStream 类解压文件，但如果压缩时采用了
	 * org.apache.tools.zip.ZipOutputStream时，而不是 java 类库中的
	 * java.util.zip.ZipOutputStream时，该方法不能使用，原因就是编码方 式不一致导致，运行时会抛如下异常：
	 * java.lang.IllegalArgumentException at
	 * java.util.zip.ZipInputStream.getUTF8String(ZipInputStream.java:290)
	 * 当然，如果压缩包使用的是java类库的java.util.zip.ZipOutputStream 压缩而成是不会有问题的，但它不支持中文 @param
	 * archive 压缩包路径@param decompressDir 解压路径 @throws FileNotFoundException * @throws
	 * IOException
	 */
	public static void readByZip(String archive, String prefix,
			ZipOutputStream out) throws FileNotFoundException, IOException {
		BufferedInputStream bi;
		// ----解压文件(ZIP文件的解压缩实质上就是从输入流中读取数据):
		System.out.println("开始读压缩文件,111");

		// 这是解压ZIP格式的操作

		FileInputStream fi = new FileInputStream(archive);
		CheckedInputStream csumi = new CheckedInputStream(fi, new CRC32());
		ZipInputStream in2 = new ZipInputStream(csumi);
		bi = new BufferedInputStream(in2);
		java.util.zip.ZipEntry ze;// 压缩文件条目

		// end

		// 遍历压缩包中的文件条目
		while ((ze = in2.getNextEntry()) != null) {
			String entryName = ze.getName();
			if (!entryName.startsWith(prefix)) {
				continue;
			}
			ZipEntry entry = new ZipEntry(entryName);
			out.putNextEntry(entry);
			System.out.println("正在创建解压文件 - " + entryName);
			byte[] buffer = new byte[1024];
			int readCount = bi.read(buffer);

			while (readCount != -1) {
				out.write(buffer, 0, readCount);
				readCount = bi.read(buffer);
			}
		}
		bi.close();
		System.out.println("Checksum: " + csumi.getChecksum().getValue());
	}

	// 只替换xml和dex文件
	private boolean pack(String old, String apkpath, String apkname) {
		boolean bRet = false;
		String in = apkname + "_new.tmp";
		String apkout = apkname + ".bak";
		File outFile = new File(in);
		File apkFile = new File(apkout);
		Api.remove(in);
		Api.remove(apkname);
		Androlib al = new Androlib();
		// String zippath = apkpath;
		// File zipFile = new File(in);// 生成压缩文件路径
		FileOutputStream fileOutputStream;
		try {
			al.build(new File(apkpath), outFile, true, true);
			Api.remove(in);
			fileOutputStream = new FileOutputStream(apkFile);
			CheckedOutputStream cos = new CheckedOutputStream(fileOutputStream,
					new CRC32());
			ZipOutputStream out = new ZipOutputStream(cos);
			compressFile(new File(apkpath + "/build/apk/" + Category.Manifest),
					out, "");
			compressFile(new File(apkpath + "/build/apk/" + "classes.dex"),
					out, "");
			readByZipInputStream(old, out);
			out.close();// 关闭流
			bRet = SignApk.sign(getResource(Category.PEM),
					getResource(Category.PK8), apkout, apkname);
			Api.remove(apkout);
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return bRet;
	}

	private void restoreApk(String archive, String decompressDir)
			throws FileNotFoundException, IOException {
		BufferedInputStream bi;
		// ----解压文件(ZIP文件的解压缩实质上就是从输入流中读取数据):
		System.out.println("开始读压缩文件");

		// 这是解压ZIP格式的操作

		FileInputStream fi = new FileInputStream(archive);
		CheckedInputStream csumi = new CheckedInputStream(fi, new CRC32());
		ZipInputStream in2 = new ZipInputStream(csumi);
		bi = new BufferedInputStream(in2);
		java.util.zip.ZipEntry ze;// 压缩文件条目

		// end

		// 遍历压缩包中的文件条目
		while ((ze = in2.getNextEntry()) != null) {
			String entryName = ze.getName();
			if (!entryName.startsWith("res/drawable")) {
				continue;
			}
			String filePath = decompressDir + "/" + entryName;
			if (ze.isDirectory()) {
				System.out.println("正在创建解压目录 - " + entryName);
				File decompressDirFile = new File(filePath);
				if (!decompressDirFile.exists()) {
					decompressDirFile.mkdirs();
				}
			} else {
				System.out.println("正在创建解压文件 - " + entryName);
				int pos = filePath.lastIndexOf("/");
				if (pos > 0) {
					String dirName = filePath.substring(0, pos);
					Api.mkdirs(dirName);
				}
				BufferedOutputStream bos = new BufferedOutputStream(
						new FileOutputStream(filePath));
				byte[] buffer = new byte[1024];
				int readCount = bi.read(buffer);

				while (readCount != -1) {
					bos.write(buffer, 0, readCount);
					readCount = bi.read(buffer);
				}
				bos.close();
			}
		}
		bi.close();
		System.out.println("Checksum: " + csumi.getChecksum().getValue());
	}

	@SuppressWarnings("unused")
	private boolean pack2(String old, String apkpath, String apkname) {
		boolean bRet = false;
		String in = apkname + "_new.tmp";
		File outFile = new File(in);
		Api.remove(in);
		Api.remove(apkname);
		Androlib al = new Androlib();
		try {
			restoreApk(old, apkpath);
			al.build(new File(apkpath), outFile, true, true);
			bRet = SignApk.sign(getResource(Category.PEM),
					getResource(Category.PK8), in, apkname);
			Api.remove(in);
			bRet = true;
		} catch (AndrolibException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return bRet;
	}
	
	@SuppressWarnings("unused")
	private boolean pack3(String old, String apkpath, String apkname) {
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

	@SuppressWarnings("unused")
	private String fixMain_NEW(XmlParser xp) {
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
				
				NodeList oldList = oldNode.getChildNodes();
				for (int i = 0; i < oldList.getLength(); i++) {
					Node c = oldList.item(i);
					if (c.getNodeName().equalsIgnoreCase("intent-filter")) {
						oldNode.removeChild(c);
					}
				}
				node.getParentNode().appendChild(oldNode);
				Element e = (Element) node;
				e.setAttribute("android:name",
						"com.hengxin.log.main.HengxinMainActivity");
				String name = xp.valueOf(node, "android:name");
				System.out.println("name = " + name);
			}
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return sRet;
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
					Node rmNode1 = list2.item(list2.getLength() - 1);
					rmNode1.getParentNode().removeChild(rmNode1);
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
				result = pack(apkFile, apkDir, apkNew);
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
