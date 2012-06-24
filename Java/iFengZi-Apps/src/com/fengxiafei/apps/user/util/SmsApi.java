/**
 * 
 */
package com.fengxiafei.apps.user.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.xpath.XPathExpressionException;

import org.mymmsc.api.adapter.AutoObject;
import org.mymmsc.api.assembly.XmlParser;

import com.fengxiafei.apps.Adapter;

/**
 * @author wangfeng
 * 
 */
public class SmsApi extends AutoObject {
	private String sname = null;
	private String spwd = null;
	private String sprdid = null;
	private String smsurl = null;

	public SmsApi() {
		super();
	}
	
	public static SmsApi getApi(Adapter adapter) {
		XmlParser xp = adapter.getXmlParser();
		SmsApi helpers = null;
		try {
			helpers = xp.valueOf("//sms/*", SmsApi.class);
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		return helpers;
	}
	
	
	private String sendSms(String postData, String postUrl) {
		try {
			info("postData=" + postData);
			info("postUrl=" + postUrl);
			URL url = new URL(postUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setUseCaches(false);
			conn.setDoOutput(true);

			conn.setRequestProperty("Content-Length", "" + postData.length());
			OutputStreamWriter out = new OutputStreamWriter(
					conn.getOutputStream(), "UTF-8");
			out.write(postData);
			out.flush();
			out.close();

			// 获取响应状态?
			if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
				error("connect failed!");
				return "";
			}
			// 获取响应内容?
			String line, result = "";
			BufferedReader in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "utf-8"));

			while ((line = in.readLine()) != null) {
				result += line + "\n";
			}

			in.close();
			return result;
		} catch (IOException e) {
			error(e.getMessage(), e);
		}
		return "";
	}

	public boolean send(String username, String description) {
		String scorpid = "";
		String sdst = username;
		// 短信内容
		String PostData;

		try {
			PostData = "sname=" + sname + "&spwd=" + spwd + "&scorpid="
					+ scorpid + "&sprdid=" + sprdid + "&sdst=" + sdst
					+ "&smsg="
					+ java.net.URLEncoder.encode(description, "utf-8");

			String req = sendSms(PostData, smsurl);
			info("sms postData=" + PostData);
			info("sms return=" + req);
		} catch (UnsupportedEncodingException e1) {
			error(e1.getMessage(), e1);
			return false;
		}

		return true;
	}

	/**
	 * @return the sname
	 */
	public String getSname() {
		return sname;
	}

	/**
	 * @param sname
	 *            the sname to set
	 */
	public void setSname(String sname) {
		this.sname = sname;
	}

	/**
	 * @return the spwd
	 */
	public String getSpwd() {
		return spwd;
	}

	/**
	 * @param spwd
	 *            the spwd to set
	 */
	public void setSpwd(String spwd) {
		this.spwd = spwd;
	}

	/**
	 * @return the sprdid
	 */
	public String getSprdid() {
		return sprdid;
	}

	/**
	 * @param sprdid
	 *            the sprdid to set
	 */
	public void setSprdid(String sprdid) {
		this.sprdid = sprdid;
	}

	/**
	 * @return the smsurl
	 */
	public String getSmsurl() {
		return smsurl;
	}

	/**
	 * @param smsurl
	 *            the smsurl to set
	 */
	public void setSmsurl(String smsurl) {
		this.smsurl = smsurl;
	}

	@Override
	public void close() {
		// TODO Auto-generated method stub
	}
}
