/**
 * 
 */
package com.fengxiafei.apps.user.util;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Random;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.UserInfo;

/**
 * 用户中心, 杂项函数
 * 
 * @author wangfeng
 * @version 3.0.1
 */
public class UserApi {
	/** 密码密钥 */
	private static final String PASSWORD_TOKEN = "fengxingtianxia";
	
	/**
	 * 得到当前时间戳
	 * @return
	 */
	public static String now(){
		java.util.Date now = new java.util.Date();
		String szNow = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
				.format(now);
		return Timestamp.valueOf(szNow).toString();
	}
	
	private static String getMd5(String s) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			char str[];
			byte strTemp[] = s.getBytes();
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");
			mdTemp.update(strTemp);
			byte md[] = mdTemp.digest();
			int j = md.length;
			str = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}

			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 获取字符串的MD5值，分成两个64位的数表示，第一个数为前64位，第二个数为后64位。采用LITTLE_ENDIAN
	 * 
	 * @since 1.3.0 zengyunfeng
	 * @param s
	 * @return
	 */
	public static BigInteger[] getMd5Decimal(String s) {
		String md5 = getMd5(s);
		if (md5 == null) {
			return null;
		}
		if (md5.length() < 16) {
			return null;
		}
		BigInteger[] result = new BigInteger[2];
		result[0] = new BigInteger(md5.substring(0, 16), 16);
		result[1] = new BigInteger(md5.substring(16), 16);
		return result;
	}

	/**
	 * 进行二次密码加密
	 * 
	 * @param mingwenPass
	 * @param userid
	 * @return
	 */
	private static String md5Password(String mingwenPass, Long userid) {
		String md5First = getMd5(mingwenPass);
		String tmp = userid + md5First + PASSWORD_TOKEN;
		return getMd5(tmp);
	}
	
	/**
	 * 进行二次密码加密
	 * 
	 * @param passwd 密码明文
	 * @param userId 用户ID
	 * @return
	 */
	public static String genPassword(String passwd, int userId) {
		return md5Password(passwd, (long) userId);
	}

	/**
	 * 生成token
	 * 
	 * @param ub
	 * @return
	 */
	public static String genToken0(UserInfo ub) {
		String time = Api.toString(ub.getLastTime());
		String orig = String.format("%s%s%s", ub.getUserid(), time, ub.getKey());
		byte[] pswd = Api.md5(orig.getBytes());
		String ret = Api.o3String(pswd);
		return ret;
	}
	
	public static String genToken(String time, int userId, String key) {
		String sRet = null;
		if (Api.isEmpty(time)) {
			time = "0";
		}
		if (Api.isEmpty(key)) {
			key = "ifengzi";
		}
		String orig = String.format("%010d|%s|%s", userId, time, key);
		byte[] pswd = Api.md5(orig.getBytes());
		sRet = Api.o3String(pswd);
		return sRet;
	}
	
	/**
	 * 生成四位数字的验证码
	 */
	public static String genCheckCode(int pwd_len) {
		// 10是因为数组是从0开始的，10个数字
		final int maxNum = 10;
		int i; // 生成的随机数
		int count = 0; // 生成的密码的长度
		char[] str = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
		StringBuffer pwd = new StringBuffer("");
		Random r = new Random();
		while (count < pwd_len) {
			// 生成随机数，取绝对值，防止生成负数，
			i = Math.abs(r.nextInt(maxNum)); // 生成的数最大为36-1

			if (i >= 0 && i < str.length) {
				pwd.append(str[i]);
				count++;
			}
		}
		return pwd.toString();
	}
	
	/**
	 * 根据用户名获得用户记录
	 * @param username
	 * @return
	 */
	public static UserInfo fromUserName(String username){
		String sql = "SELECT * FROM `users` WHERE `username`=? LIMIT 0,1";
		UserInfo result = SQLApi.getOneRow(Consts.DataSource, UserInfo.class, sql, username);
		return result;
	}
	
	/**
	 * 根据用户ID获得用户记录
	 * @param username
	 * @return
	 */
	public static UserInfo fromUserId(int userId){
		String sql = "SELECT * FROM `users` WHERE `userid`=? LIMIT 0,1";
		UserInfo result = SQLApi.getOneRow(Consts.DataSource, UserInfo.class, sql, userId);
		return result;
	}
	
	/**
	 * 添加用户信息
	 * @param ui
	 * @return
	 */
	public static boolean addUser(UserInfo ui) {
		boolean bRet = false;
		String sql = "UPDATE `users` SET `flag`='01',`userid`=?,`password`=?,`key`='ifengzi',`nikename`=?,`checkcode`='',`regtime`=now() WHERE `id`=?";
		int uid = ui.getId();
		if (uid < 999999) {
			uid += 100000;
		}
		// ui.getPassword()保证是密码明文
		String pswd = genPassword(ui.getPassword(), uid);
		String nn = ui.getNikename();
		if (Api.isEmpty(nn)) {
			nn = "匿名";
		}
		int num  = SQLApi.execute(Consts.DataSource, sql, uid, pswd, nn, ui.getId());
		if (num > 0) {
			bRet = true;
		}
		return bRet;
	}
	
	public static void main(String[] argv) {
		System.out.println(Api.getNow().toString());
		System.out.println(genToken(null, 100975, null));
	}
	
}
