/**
 * 
 */
package com.fengxiafei.apps;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;
import java.util.UUID;

import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.adapter.AutoObject;
import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.assembly.XmlParser;
import org.w3c.dom.NodeList;

import com.fengxiafei.apps.code.bean.FileType;
import com.fengxiafei.core.Category;

/**
 * 业务处理适配器
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 */
public class Adapter extends AutoObject {
	private static Adapter instance = null;
	private XmlParser xp = null;
	/** 文件上传路径 */
	private String uploadPath = null;
	/** 文件下载地址 */
	private String downloadUrl = null;

	/**
	 * 私有构造函数
	 */
	private Adapter() {
		super();
	}

	public synchronized static Adapter newInstance() {
		if (instance == null) {
			instance = new Adapter();
		}
		return instance;
	}

	public synchronized boolean loadConfig(String filename) {
		boolean bRet = false;
		if (xp == null) {
			xp = new XmlParser(filename, true);
		}
		if (xp != null) {
			bRet = true;
		}
		return bRet;
	}

	public boolean checkResouce(String s) {
		boolean bRet = false;
		// String exp =
		// "^(http|www|ftp|)?(://)?(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*((:\\d+)?)(/(\\w+(-\\w+)*))*(\\.?(\\w)*)(\\?)?(((\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*(\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*)*(\\w*)*)$";
		// bRet = RegExp.valid(s, exp);
		String url = getDownloadUrl();
		String path = getUploadPath();
		if (!Api.isNull(s) && !Api.isNull(url) && !Api.isNull(path)) {
			int pos = s.indexOf(url);
			if (pos == 0 && s.length() > url.length()) {
				String request = s.substring(url.length());
				String filename = null;
				if (request.startsWith("/file")) {
					filename = path + request;
				} else {
					pos = request.indexOf('?');
					request = request.substring(pos + 1);
					Map<String, String> params = Api.getParams(request);
					if (params != null && params.size() >= 2) {
						String id = params.get("id");
						String type = params.get("type");
						filename = path + "/file/" + genPath(id) + id + '.'
								+ type;

					}
				}
				info("resource = [" + filename + "]");
				if (Api.isFile(filename)) {
					bRet = true;
				}
			}
		} else if (Api.isNull(s)) {
			bRet = true;
		}

		return bRet;
	}

	public FileType getFileType(String type) {
		FileType ret = null;
		String exp = String.format("//type[@key='%s']", type);
		try {
			NodeList list = xp.query(exp);
			if (list.getLength() > 0) {
				ret = new FileType();
				org.w3c.dom.Node node = list.item(0);
				Api.setValue(ret, "type", xp.valueOf(node, "class"));
				Api.setValue(ret, "ext", xp.valueOf(node, "ext"));
			}
		} catch (XPathExpressionException e) {
			//
		}

		return ret;
	}

	/**
	 * 生成随机uuid
	 * 
	 * @return
	 */
	public String genKey(byte[] data) {
		return UUID.nameUUIDFromBytes(data).toString();
	}

	public String genKey(String str) {
		return genKey(str.trim().getBytes());
	}

	/**
	 * 格式化媒体文件/jSON模板文件存储路径
	 * 
	 * @param filename
	 * @return
	 */
	public static String genPath(String filename) {
		String sRet = filename;
		if (filename != null) {
			String tmpFile = filename.trim();
			if (tmpFile.length() >= 6) {
				sRet = tmpFile.substring(0, 2);
				sRet = sRet + "/";
				sRet = sRet + tmpFile.substring(2, 4);
				sRet = sRet + "/";
				sRet = sRet + tmpFile.substring(4, 6);
				sRet = sRet + "/";
			}
		}
		return sRet;
	}

	public static void closeQuietly(OutputStream output) {
		try {
			if (output != null)
				output.close();
		} catch (IOException ioe) {
		}
	}

	public static void toFile(File file, byte[] data) throws IOException {
		OutputStream out = new FileOutputStream(file);
		try {
			out.write(data);
		} finally {
			closeQuietly(out);
		}
	}

	public static void toFile(String filename, byte[] data) throws IOException {
		String path = Api.dirName(filename);
		Api.mkdirs(path);
		toFile(new File(filename), data);
	}

	public String jsonPath() {
		return getUploadPath() + '/' + Category.JsonPath + '/';
	}

	public String filePath() {
		return getUploadPath() + '/' + Category.ResourcePath + '/';
	}

	public String codePath() {
		return getUploadPath() + '/' + Category.QRCodePath + '/';
	}
	
	public String usersPath() {
		return getUploadPath() + '/' + Category.UsersPath + '/';
	}

	/**
	 * @return the uploadPath
	 */
	public String getUploadPath() {
		String exp = String.format("//file/upload");
		try {
			NodeList list = xp.query(exp);
			if (list.getLength() > 0) {
				org.w3c.dom.Node node = list.item(0);
				uploadPath = xp.valueOf(node, "path");
				if (!Api.isNull(uploadPath)) {
					uploadPath = uploadPath.trim();
				}
			}
		} catch (XPathExpressionException e) {
			//
		}
		return uploadPath;
	}

	/**
	 * @param uploadPath
	 *            the uploadPath to set
	 */
	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	/**
	 * @return the downloadUrl
	 */
	public String getDownloadUrl() {
		String exp = String.format("//file/download");
		try {
			NodeList list = xp.query(exp);
			if (list.getLength() > 0) {
				org.w3c.dom.Node node = list.item(0);
				downloadUrl = xp.valueOf(node, "host");
				if (!Api.isNull(downloadUrl)) {
					downloadUrl = downloadUrl.trim();
				}
			}
		} catch (XPathExpressionException e) {
			//
		}
		return downloadUrl;
	}

	/**
	 * @param downloadUrl
	 *            the downloadUrl to set
	 */
	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

	public XmlParser getXmlParser() {
		return xp;
	}

	@Override
	public void close() {
		//
	}
}
