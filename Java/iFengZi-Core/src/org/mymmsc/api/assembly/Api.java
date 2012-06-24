/**
 * @(#)Api.java	6.3.12 12/05/12
 *
 * Copyright 2000-2010 MyMMSC Software Foundation (MSF), Inc. All rights reserved.
 * MyMMSC PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package org.mymmsc.api.assembly;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.InetAddress;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Random;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.mymmsc.api.category.Encoding;

/**
 * JAVA API杂类封装
 * 
 * @author WangFeng(wangfeng@yeah.net)
 * @version 6.3.9 09/10/02
 * @since mymmsc-api 6.3.9
 */
public final class Api {

	/******************** < 字符串基础APIs > ********************/

	/**
	 * 判断字符串是否为空
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isNull(String s) {
		boolean bRet = false;
		if (s == null || s.trim().length() < 1) {
			bRet = true;
		}
		return bRet;
	}

	/**
	 * 判断字符串是否为空
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isEmpty(String s) {
		return isNull(s);
	}

	/**
	 * URI参数解析
	 * 
	 * @param uri
	 * @return
	 */
	public static Map<String, String> getParams(String uri) {
		Map<String, String> oRet = null;
		String exp = "(([^=&]+)=([^&]*))";
		Pattern p = Pattern.compile(exp, Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(uri);
		int offset = 2;
		String key = null;
		String value = null;
		while (m.find()) {
			if (oRet == null) {
				oRet = new HashMap<String, String>();
			}
			key = m.group(offset);
			value = m.group(offset + 1);
			if (value != null) {
				value = urlDecode(value);
			} else {
				value = "";
			}
			// System.out.println("  key = [" + key + "]");
			// System.out.println("value = [" + value + "]");
			value = value.replaceAll("\\\\;", ";");
			value = value.replaceAll("\\\\:", ":");
			oRet.put(key, value);
		}
		return oRet;
	}

	public static <T> T valueOf(Map<String, String> map, Class<T> clazz) {
		T tRet = null;
		Iterator<Entry<String, String>> iter = map.entrySet().iterator();
		while (iter.hasNext()) {
			if (tRet == null) {
				try {
					tRet = clazz.newInstance();
				} catch (InstantiationException e) {
					e.printStackTrace();
					break;
				} catch (IllegalAccessException e) {
					e.printStackTrace();
					break;
				}
			}
			Entry<String, String> entry = iter.next();
			String key = entry.getKey();
			String value = entry.getValue();
			setValue(tRet, key, value);
		}
		return tRet;
	}

	/**
	 * 解析URL请求参数, 封装bean
	 * 
	 * @param string
	 * @param clazz
	 * @return
	 */
	public static <T> T parseParams(String string, Class<T> clazz) {
		T tRet = null;
		Map<String, String> map = getParams(string);
		if (map != null && map.size() > 0) {
			tRet = valueOf(map, clazz);
		}
		return tRet;
	}

	/******************** < 字符集APIs > ********************/

	/**
	 * 判断是否utf-8编码
	 * 
	 * @param b
	 * @param aMaxCount
	 * @return 如果是utf-8, 则返回true, 否则返回false
	 */
	public static boolean isUtf8(String s) {
		byte[] b = s.getBytes();
		int aMaxCount = s.length();
		int lLen = b.length, lCharCount = 0;
		for (int i = 0; i < lLen && lCharCount < aMaxCount; ++lCharCount) {
			byte lByte = b[i++];// to fast operation, ++ now, ready for the
			// following for(;;)
			if (lByte >= 0) {
				continue;// >=0 is normal ascii
			}
			if (lByte < (byte) 0xc0 || lByte > (byte) 0xfd) {
				return false;
			}
			int lCount = lByte > (byte) 0xfc ? 5 : lByte > (byte) 0xf8 ? 4
					: lByte > (byte) 0xf0 ? 3 : lByte > (byte) 0xe0 ? 2 : 1;
			if (i + lCount > lLen) {
				return false;
			}
			for (int j = 0; j < lCount; ++j, ++i) {
				if (b[i] >= (byte) 0xc0) {
					return false;
				}
			}
		}

		return true;
	}

	public static boolean isGBK(String str) {
		char[] chars = str.toCharArray();
		boolean isGB2312 = false;
		for (int i = 0; i < chars.length; i++) {
			byte[] bytes = ("" + chars[i]).getBytes();
			if (bytes.length == 2) {
				int[] ints = new int[2];
				ints[0] = bytes[0] & 0xff;
				ints[1] = bytes[1] & 0xff;
				if (ints[0] >= 0x81 && ints[0] <= 0xFE && ints[1] >= 0x40
						&& ints[1] <= 0xFE) {
					isGB2312 = true;
					break;
				}
			}
		}
		return isGB2312;
	}

	/******************** < 文件系统APIs > ********************/

	/**
	 * 获得资源路径
	 * 
	 * @param cls
	 * @return the special resource path
	 * @see Class#getResource(String)
	 */
	public static String getResourcePath(Class<?> cls) {
		String path = cls.getResource("./").toString();
		path = path.substring(6, path.length() - 1);
		return path;
	}

	/**
	 * 获得jar包本地的路径
	 * 
	 * @param jar中已经存在的一个class
	 * @return
	 */
	public static String getLibPath(Class<?> cls) {
		String path = cls.getProtectionDomain().getCodeSource().getLocation()
				.getFile();
		// System.out.println("path =" + path);
		int iPos = path.lastIndexOf('!');
		if (iPos > 0) {
			path = path.substring(0, iPos);
		}
		int iBegin = path.indexOf('/');
		if (System.getProperties().getProperty("os.name").indexOf("Windows") >= 0) {
			iBegin += 1;
		}
		int iEnd = path.lastIndexOf('/');
		path = path.substring(iBegin, iEnd);
		return path;
	}

	/**
	 * 得到目录名
	 * 
	 * @param path
	 * @return 父目录
	 */
	public static String dirName(String path) {
		path = path.replaceAll("\\\\", "/");
		int iEnd = path.lastIndexOf('/');
		return path.substring(0, iEnd);
	}

	/**
	 * 检查路径是否为目录
	 * 
	 * @param pathname
	 *            有效路径
	 * @return 如果pathname为null或者非目录, 则返回false
	 */
	public static boolean isDirectory(String pathname) {
		boolean bRet = false;
		if (pathname != null) {
			File file = new File(pathname);
			if (file != null) {
				bRet = file.isDirectory();
			}
		}

		return bRet;
	}

	/**
	 * 检查路径是否为文件
	 * 
	 * @param filename
	 *            String
	 * @return 如果filename为null或者非目录, 则返回false
	 */
	public static boolean isFile(String filename) {
		boolean bRet = false;
		if (filename != null) {
			File file = new File(filename);
			if (file != null) {
				bRet = file.isFile();
			}
		}
		return bRet;
	}

	/**
	 * 创建目录
	 * 
	 * @param path
	 *            String
	 * @return 如果path为null或者非目录, 则返回false
	 */
	public static boolean mkdirs(String path) {
		boolean bRet = false;
		if (path != null) {
			File file = new File(path);
			if (file != null) {
				if (!file.isFile() && !file.exists()) {
					if (file.mkdirs()) {
						bRet = true;
					}
				}
			}
		}
		return bRet;
	}

	/**
	 * 删除目录或者文件
	 * 
	 * @param path
	 *            String
	 * @return boolean
	 */
	public static boolean remove(String path) {
		boolean bRet = false;
		if (path != null) {
			File file = new File(path);
			if (file != null) {
				if (file.exists()) {
					bRet = file.delete();
				}
			}
		}
		return bRet;
	}

	/**
	 * 取得文件最后修改时间的秒数
	 * 
	 * @param filename
	 *            String
	 * @return long 如果文件读取失败, 返回-1, 否则将返回实际的修改时间
	 */
	public static long getLastModified(String filename) {
		long timestamp = 0;
		File file = null;
		try {
			file = new File(filename);
			if (file != null && file.isFile()) {
				timestamp = file.lastModified();
			}
		} catch (Exception e) {
			// 异常情况返回-1
			timestamp = -1;
		} finally {
			// File 没有关闭方法
		}

		return timestamp;
	}

	/******************** < 网络系统APIs > ********************/

	/**
	 * 获得本地IP
	 * 
	 * @return
	 */
	public static String getLocalIp() {
		String ip = "";
		try {
			InetAddress addr = InetAddress.getLocalHost();
			ip = addr.getHostAddress();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		return ip;
	}

	/******************** < 基本数据类型APIs > ********************/

	/**
	 * 字节对齐
	 * 
	 * @param size
	 *            源尺寸
	 * @param boundary
	 *            对齐边界
	 * @return 对齐后的尺寸
	 */
	public static int align(int size, int boundary) {
		return (((size) + ((boundary) - 1)) & ~((boundary) - 1));
	}

	/**
	 * 替换字符串
	 * 
	 * @param s
	 * @param regex
	 * @param replacement
	 * @return
	 */
	public static String replaceFirst(String s, String regex, String replacement) {
		String sRet = s;
		try {
			sRet = s.replaceFirst(regex, replacement);
		} catch (PatternSyntaxException e) {
			//
		}
		return sRet;
	}

	/**
	 * 全部替换字符串
	 * 
	 * @param s
	 * @param regex
	 * @param replacement
	 * @return
	 */
	public static String replaceAll(String s, String regex, String replacement) {
		String sRet = s;
		try {
			sRet = s.replaceAll(regex, replacement);
		} catch (PatternSyntaxException e) {
			//
		}
		return sRet;
	}

	/**
	 * 字符串转整型
	 * 
	 * @param str
	 * @return
	 */
	public static int String2Int(String str) {
		return (int) String2Long(str);
	}

	public static long String2Long(String str) {
		if (str == null) {
			return 0;
		}
		str = str.trim();
		if (str.length() == 0) {
			return 0;
		}
		long lng = 0;
		try {
			lng = new Long(str).longValue();
		} catch (Exception ex) {
			lng = 0;
		}
		return lng;
	}

	/**
	 * 字符串是否包含
	 * 
	 * @param str
	 *            源字符串
	 * @param substring
	 *            子串
	 * @return boolean
	 */
	public static boolean stristr(String str, String substring) {
		if (str == null || substring == null) {
			return false;
		}
		return str.toLowerCase().indexOf(substring.toLowerCase()) >= 0;
	}

	/**
	 * contains
	 * 
	 * @param s
	 *            String
	 * @param sKey
	 *            String
	 * @param sDest
	 *            String
	 * @return String
	 * @remark 替换${Keywords}格式的字符串
	 */
	public static String contains(String s, String sKey, String sDest) {
		if (s == null || (s.trim()).length() == 0) {
			return "";
		}
		return (s.replaceAll("\\$\\{" + sKey + "\\}", sDest));
	}

	/**
	 * Sprintf
	 * 
	 * @param strFormat
	 *            String
	 * @param args
	 *            Object[]
	 * @return String
	 */
	public static String Sprintf(String strFormat, Object... args) {
		return String.format(strFormat, args);
	}

	/**
	 * URL编码
	 * 
	 * @param str
	 * @return
	 */
	public static String urlEncode(String str) {
		String sRet = str;
		try {
			sRet = URLEncoder.encode(str, Encoding.Default);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	/**
	 * URL解码
	 * 
	 * @param str
	 * @return
	 */
	public static String urlDecode(String str) {
		String sRet = str;
		try {
			sRet = URLDecoder.decode(str, Encoding.Default);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	/**
	 * DoubleToString
	 * 
	 * @todo 输出格式化的Double字符串
	 * @param tempDouble
	 *            double
	 * @param tempFormat
	 *            String
	 * @return String
	 */
	public static String DoubleToString(double tempDouble, String tempFormat) {
		String tempString = null;
		java.text.DecimalFormat tempDecimalFormat = new java.text.DecimalFormat(
				tempFormat);
		tempString = tempDecimalFormat.format(tempDouble).toString();
		return tempString;
	}

	/**
	 * binaryStringTohexString
	 * 
	 * @todo 二进制字符串到十六进制字符串的转换
	 * @author WangFeng
	 * @param bString
	 *            String
	 * @return String
	 */
	public static String binaryStringTohexString(String bString) {
		if (bString == null || bString.equals("") || bString.length() % 8 != 0) {
			return null;
		}
		StringBuffer tmp = new StringBuffer();
		int iTmp = 0;
		for (int i = 0; i < bString.length(); i += 4) {
			iTmp = 0;
			for (int j = 0; j < 4; j++) {
				iTmp += Integer.parseInt(bString.substring(i + j, i + j + 1)) << (4 - j - 1);
			}
			tmp.append(Integer.toHexString(iTmp));
		}
		return tmp.toString();
	}

	/**
	 * hexString2binaryString
	 * 
	 * @todo 十六进制字符串到二进制字符串的转换
	 * @author WangFeng
	 * @param hexString
	 *            String
	 * @return String
	 */
	public static String hexStringTobinaryString(String hexString) {
		if (hexString == null || hexString.length() % 2 != 0) {
			return null;
		}
		String bString = "", tmp;
		for (int i = 0; i < hexString.length(); i++) {
			tmp = "0000"
					+ Integer.toBinaryString(Integer.parseInt(
							hexString.substring(i, i + 1), 16));
			bString += tmp.substring(tmp.length() - 4);
		}
		return bString;
	}

	/**
	 * IntToByteArray
	 * 
	 * @todo int转换成字节数组
	 * @param n
	 *            int
	 * @return byte[]
	 */
	public byte[] IntToByteArray(int n) {
		byte data[] = new byte[4];
		data[3] = (byte) n;
		n >>>= 8;
		data[2] = (byte) n;
		n >>>= 8;
		data[1] = (byte) n;
		n >>>= 8;
		data[0] = (byte) n;
		return data;
	}

	/**
	 * StringSplit
	 * 
	 * @param s
	 *            String
	 * @param regex
	 *            String
	 * @return String[]
	 */
	public static String[] StringSplit(String s, String regex) {
		String[] array = s.split(regex);
		return array;
	}

	/**
	 * StringCat
	 * 
	 * @todo 连接字符串
	 * @param args
	 *            String[]
	 * @return String
	 */
	public static String StringCat(String... args) {
		StringBuffer sbuff = new StringBuffer();
		for (String s : args) {
			sbuff.append(s);
		}

		return sbuff.toString();
	}

	/**
	 * iconv
	 * 
	 * @todo 字符串编码转换
	 * @param s
	 *            String 源字符串
	 * @param fmtSrc
	 *            String 源字符串编码方式
	 * @param fmtDest
	 *            String 目标编码方式
	 * @return String
	 */
	public static String iconv(String s, String fmtSrc, String fmtDest) {
		try {
			return (new String((s).getBytes(fmtSrc), fmtDest));
		} catch (UnsupportedEncodingException ex) {
			return null;
		}
	}

	/**
	 * getPatternString
	 * 
	 * @param s
	 *            String
	 * @param regex
	 *            String
	 * @return String
	 */
	public static synchronized String getPatternString(String s, String regex) {
		if (s == null || regex == null) {
			return "";
		}
		String _str = "";
		Pattern p = null; // 正则表达式
		Matcher m = null; // 操作的字符串
		// 字符串匹配,这是不符合的
		p = Pattern.compile(regex);
		m = p.matcher(s);
		if (m.find()) {
			// int i = m.groupCount(); // 匹配到个数
			_str = m.group(0);
		}
		return _str;
	}

	/**
	 * byte2int
	 * 
	 * @param b
	 *            byte[]
	 * @param offset
	 *            int
	 * @return int
	 */
	public static int byte2int(byte b[], int offset) {
		return b[offset + 3] & 0xff | (b[offset + 2] & 0xff) << 8
				| (b[offset + 1] & 0xff) << 16 | (b[offset] & 0xff) << 24;
	}

	/**
	 * byte2int
	 * 
	 * @param b
	 *            byte[]
	 * @return int
	 */
	public static int byte2int(byte b[]) {
		return b[3] & 0xff | (b[2] & 0xff) << 8 | (b[1] & 0xff) << 16
				| (b[0] & 0xff) << 24;
	}

	/**
	 * byte2long
	 * 
	 * @param b
	 *            byte[]
	 * @return long
	 */
	public static long byte2long(byte b[]) {
		return (long) b[7] & (long) 255 | ((long) b[6] & (long) 255) << 8
				| ((long) b[5] & (long) 255) << 16
				| ((long) b[4] & (long) 255) << 24
				| ((long) b[3] & (long) 255) << 32
				| ((long) b[2] & (long) 255) << 40
				| ((long) b[1] & (long) 255) << 48 | (long) b[0] << 56;
	}

	/**
	 * byte2long
	 * 
	 * @param b
	 *            byte[]
	 * @param offset
	 *            int
	 * @return long
	 */
	public static long byte2long(byte b[], int offset) {
		return (long) b[offset + 7] & (long) 255
				| ((long) b[offset + 6] & (long) 255) << 8
				| ((long) b[offset + 5] & (long) 255) << 16
				| ((long) b[offset + 4] & (long) 255) << 24
				| ((long) b[offset + 3] & (long) 255) << 32
				| ((long) b[offset + 2] & (long) 255) << 40
				| ((long) b[offset + 1] & (long) 255) << 48
				| (long) b[offset] << 56;
	}

	/**
	 * int2byte
	 * 
	 * @param n
	 *            int
	 * @return byte[]
	 */
	public static byte[] int2byte(int n) {
		byte b[] = new byte[4];
		b[0] = (byte) (n >> 24);
		b[1] = (byte) (n >> 16);
		b[2] = (byte) (n >> 8);
		b[3] = (byte) n;
		return b;
	}

	/**
	 * int2byte
	 * 
	 * @param n
	 *            int
	 * @param buf
	 *            byte[]
	 * @param offset
	 *            int
	 */
	public static void int2byte(int n, byte buf[], int offset) {
		buf[offset] = (byte) (n >> 24);
		buf[offset + 1] = (byte) (n >> 16);
		buf[offset + 2] = (byte) (n >> 8);
		buf[offset + 3] = (byte) n;
	}

	/**
	 * short2byte
	 * 
	 * @param n
	 *            int
	 * @return byte[]
	 */
	public static byte[] short2byte(int n) {
		byte b[] = new byte[2];
		b[0] = (byte) (n >> 8);
		b[1] = (byte) n;
		return b;
	}

	/**
	 * short2byte
	 * 
	 * @param n
	 *            int
	 * @param buf
	 *            byte[]
	 * @param offset
	 *            int
	 */
	public static void short2byte(int n, byte buf[], int offset) {
		buf[offset] = (byte) (n >> 8);
		buf[offset + 1] = (byte) n;
	}

	/**
	 * long2byte
	 * 
	 * @param n
	 *            long
	 * @return byte[]
	 */
	public static byte[] long2byte(long n) {
		byte b[] = new byte[8];
		b[0] = (byte) (int) (n >> 56);
		b[1] = (byte) (int) (n >> 48);
		b[2] = (byte) (int) (n >> 40);
		b[3] = (byte) (int) (n >> 32);
		b[4] = (byte) (int) (n >> 24);
		b[5] = (byte) (int) (n >> 16);
		b[6] = (byte) (int) (n >> 8);
		b[7] = (byte) (int) n;
		return b;
	}

	/**
	 * long2byte
	 * 
	 * @param n
	 *            long
	 * @param buf
	 *            byte[]
	 * @param offset
	 *            int
	 */
	public static void long2byte(long n, byte buf[], int offset) {
		buf[offset] = (byte) (int) (n >> 56);
		buf[offset + 1] = (byte) (int) (n >> 48);
		buf[offset + 2] = (byte) (int) (n >> 40);
		buf[offset + 3] = (byte) (int) (n >> 32);
		buf[offset + 4] = (byte) (int) (n >> 24);
		buf[offset + 5] = (byte) (int) (n >> 16);
		buf[offset + 6] = (byte) (int) (n >> 8);
		buf[offset + 7] = (byte) (int) n;
	}

	/**
	 * Byte2Byte
	 * 
	 * @param ba
	 *            byte[]
	 * @param offset
	 *            int
	 * @param b
	 *            byte
	 * @return int
	 */
	public static int Byte2Byte(byte[] ba, int offset, byte b) {
		ba[offset] = b;
		// System.arraycopy(b, 0, ba, offset, 1);
		return (1);
	}

	/**
	 * String2Byte
	 * 
	 * @param ba
	 *            byte[]
	 * @param offset
	 *            int
	 * @param s
	 *            String
	 * @param len
	 *            int
	 * @return int
	 */
	public static int String2Byte(byte[] ba, int offset, String s, int len) {
		if (s == null || s.trim().length() == 0) {
			return len;
		}
		byte[] __ba = s.getBytes();
		System.arraycopy(__ba, 0, ba, offset, __ba.length > len ? len
				: __ba.length);
		return (len);
	}

	public static String ISO88592GBK(String s) {
		try {
			if (s == null) {
				return null;
			} else {
				s = new String(s.getBytes("ISO8859_1"), "GBK");
				return s;
			}
		} catch (Exception e) {
			return null;
		}
	}

	public static byte String2Byte(String str) {
		return Byte.parseByte(str);
	}

	public static String MemToHex(byte[] buff) {
		StringBuffer stringbuffer = new StringBuffer();
		for (int i = 0; i < buff.length; i++) {
			String s = Integer.toHexString(buff[i]);
			if (s.length() < 2) {
				s = "0" + s;
			}
			if (s.length() > 2) {
				s = s.substring(s.length() - 2);
			}
			stringbuffer.append(s);
		}
		return stringbuffer.toString();
	}

	public static byte[] HexToMem(String str) {
		String hexString = "0123456789ABCDEF";
		str = str.toUpperCase();
		ByteArrayOutputStream baos = new ByteArrayOutputStream(str.length() / 2);
		// 将每2位16进制整数组装成一个字节
		for (int i = 0; i < str.length(); i += 2)
			baos.write((hexString.indexOf(str.charAt(i)) << 4 | hexString
					.indexOf(str.charAt(i + 1))));
		// return new String(baos.toByteArray());
		return baos.toByteArray();
	}

	/******************** < 类反射APIs > ********************/

	/**
	 * 判断类型是否基本数据类型, int, Integer, String等
	 * 
	 * @param clazz
	 * @return
	 */
	public static boolean isBaseType(Class<?> clazz) {
		boolean bRet = false;
		Package pkg = clazz.getPackage();
		String prefix = null;
		if (pkg != null) {
			prefix = pkg.getName();
		}
		bRet = (prefix == null || prefix.startsWith("java"));
		return bRet;
	}

	/**
	 * 判断Object类型是否基本数据类型, int, Integer, String等
	 * 
	 * @param clazz
	 * @return
	 * @remark obj为null, 返回false
	 */
	public static boolean isBaseType(Object obj) {
		boolean bRet = false;
		if (obj != null) {
			bRet = isBaseType(obj.getClass());
		}
		return bRet;
	}

	/**
	 * 对象到字符串转换
	 * 
	 * @param obj
	 * @return String
	 */
	public static String toString(Object obj) {
		String sRet = "";
		Class<?> clazz = null;
		if (obj != null) {
			clazz = obj.getClass();
		}
		try {
			// 如遇基本数据类型, 会抛异常, 比如Integer可以实例化, 而int和long都不能
			if (clazz == boolean.class || clazz == Boolean.class) {
				sRet = ((Boolean) obj).toString();
			} else if (clazz == byte.class || clazz == Byte.class) {
				sRet = ((Byte) obj).toString();
			} else if (clazz == short.class || clazz == Short.class) {
				sRet = ((Short) obj).toString();
			} else if (clazz == int.class || clazz == Integer.class) {
				sRet = ((Integer) obj).toString();
			} else if (clazz == long.class || clazz == Long.class) {
				sRet = ((Long) obj).toString();
			} else if (clazz == float.class || clazz == Float.class) {
				sRet = ((Float) obj).toString();
			} else if (clazz == double.class || clazz == Double.class) {
				sRet = ((Double) obj).toString();
			} else if (clazz == String.class) {
				sRet = (String) obj;
			} else if (clazz == java.sql.Date.class) {
				sRet = ((java.sql.Date) obj).toString();
			} else if (clazz == java.util.Date.class) {
				sRet = toString((java.util.Date) obj, "yyyy-MM-dd HH:mm:ss");
			} else if (clazz == Time.class) {
				sRet = ((Time) obj).toString();
			} else if (clazz == Timestamp.class) {
				sRet = ((Timestamp) obj).toString();
			} else if (clazz == null) {
				sRet = "";
			} else {
				// 实在不知道是哪种类型了
				sRet = obj.toString();
			}
		} catch (Exception e) {
			//
		}

		return sRet;
	}

	public static boolean isDate(String strDate, String sign) {
		boolean bRet = true;
		SimpleDateFormat sdf = new SimpleDateFormat(sign);
		try {
			sdf.parse(strDate);
		} catch (ParseException e) {
			bRet = false;
		}

		return bRet;
	}

	private static Long parseLong(String value) {
		Long lRet = null;
		try {
			lRet = Long.valueOf(value);
		} catch (NumberFormatException e) {
			String s = RegExp.get(value, "^[0-9]+", "0");
			BigInteger bigInteger = new BigInteger(s, 10);
			lRet = Long.valueOf(bigInteger.longValue());
		}

		return lRet;
	}

	private static Double parseDouble(String value) {
		Double dRet = null;
		try {
			dRet = Double.valueOf(value);
		} catch (NumberFormatException e) {
			String s = RegExp.get(value, "^[0-9.]+", "0.00");
			BigDecimal bigDecimal = new BigDecimal(s);
			dRet = Double.valueOf(bigDecimal.doubleValue());
		}

		return dRet;
	}

	/**
	 * 把字符串赋值给执行类
	 * 
	 * @param cls
	 * @param value
	 * @return object
	 */
	@SuppressWarnings("unchecked")
	public static <T> T valueOf(Class<T> cls, String value) {
		Object obj = null;
		if (value == null) {
			value = "";
		} else {
			value = value.trim();
		}
		if (cls == boolean.class || cls == Boolean.class) {
			obj = Boolean.valueOf(value);
		} else if (cls == byte.class || cls == java.lang.Byte.class) {
			obj = parseLong(value).byteValue();
		} else if (cls == short.class || cls == java.lang.Short.class) {
			obj = parseLong(value).shortValue();
		} else if (cls == int.class || cls == java.lang.Integer.class) {
			obj = parseLong(value).intValue();
		} else if (cls == long.class || cls == java.lang.Long.class) {
			obj = parseLong(value).longValue();
		} else if (cls == float.class || cls == java.lang.Float.class) {
			obj = parseDouble(value).floatValue();
		} else if (cls == double.class || cls == java.lang.Double.class) {
			obj = parseDouble(value).doubleValue();
		} else if (cls == java.sql.Date.class) {
			String s = RegExp.get(value, "^[0-9]{4}-[0-9]{2}-[0-9]{2}",
					"1970-01-01");
			obj = java.sql.Date.valueOf(s);
		} else if (cls == java.util.Date.class) {
			if (isDate(value, "yyyy-MM-dd HH:mm:ss")) {
				obj = Api.toDate(value, "yyyy-MM-dd HH:mm:ss");
			} else {
				obj = new java.util.Date(0);
			}
		} else if (cls == String.class) {
			obj = String.valueOf(value);
		} else if (cls == Time.class) {
			obj = Time.valueOf(value);
		} else if (cls == Timestamp.class) {
			obj = Timestamp.valueOf(value);
		} else if (cls != null) {
			try {
				obj = cls.newInstance();
			} catch (Exception e) {
				String ex = String.format("我擦, 实在不能匹配[%s]给类[%s], 爱咋咋地, 抛异常吧.",
						value, cls.toString());
				try {
					throw new Exception(ex);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		} else {
			// class 为空, 不知道你想干啥?
		}
		return (T) obj;
	}

	/**
	 * 获得一个对象的成员变量的值
	 * 
	 * @param obj
	 * @param fieldName
	 * @param value
	 * @return
	 */
	public static Object getValue(Object obj, String fieldName) {
		boolean bRet = false;
		Object objValue = null;
		// 取得clazz类的成员变量列表
		Class<?> clazz = null;
		Field[] fields = null;
		Field field = null;
		boolean isAccessible = false;
		while (!bRet) {
			if (clazz == null) {
				clazz = obj.getClass();
			} else {
				clazz = clazz.getSuperclass();
			}
			if (clazz.getName().startsWith("java")) {
				break;
			}
			fields = clazz.getDeclaredFields();
			field = null;
			isAccessible = false;
			// 遍历所有类成员变量, 为赋值作准备
			for (int j = 0; j < fields.length; j++) {
				field = fields[j];
				// 忽略字段名大小写
				if (field.getName().equalsIgnoreCase(fieldName)) {
					// 保存现在的字段存储"权限"(对于不同属性的类成员变量)状态
					isAccessible = field.isAccessible();
					// 设定为可存取
					field.setAccessible(true);
					try {
						// 对象字段赋值
						objValue = field.get(obj);
						bRet = true;
					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} finally {
						// 恢复之前的存储权限状态
						field.setAccessible(isAccessible);
					}
					break;
				}
			}
		}
		return objValue;
	}

	/**
	 * 获得类成员变量的类
	 * 
	 * @param clazz
	 * @param fieldName
	 * @return Class
	 */
	public static Class<?> getClass(Class<?> clazz, String fieldName) {
		Class<?> cRet = null;
		// 取得clazz类的成员变量列表
		Field[] fields = clazz.getDeclaredFields();
		Field field = null;
		// 遍历所有类成员变量, 为赋值作准备
		for (int j = 0; j < fields.length; j++) {
			field = fields[j];
			// 忽略字段名大小写
			if (field.getName().equalsIgnoreCase(fieldName)) {
				// 得到类成员变量数据类型
				cRet = field.getType();
				if (cRet == java.util.List.class) {
					ParameterizedType pType = (ParameterizedType) field
							.getGenericType();
					cRet = (Class<?>) pType.getActualTypeArguments()[0];
				}
				break;
			}
		}
		if (cRet == null) {
			clazz = clazz.getSuperclass();
			if (!clazz.getName().startsWith("java")) {
				cRet = getClass(clazz, fieldName);
			}
		}
		return cRet;
	}

	/**
	 * 获得一个对象成员变量的类
	 * 
	 * @param obj
	 * @param fieldName
	 * @return Class
	 */
	public static Class<?> getClass(Object obj, String fieldName) {
		return getClass(obj.getClass(), fieldName);
	}

	/**
	 * 给一个对象的成员变量赋值
	 * 
	 * @param obj
	 * @param fieldName
	 * @param value
	 * @return
	 */
	public static boolean setValue(Object obj, String fieldName, Object value) {
		boolean bRet = false;
		// 取得clazz类的成员变量列表
		Class<?> clazz = null;
		Field[] fields = null;
		Field field = null;
		boolean isAccessible = false;
		while (!bRet) {
			if (clazz == null) {
				clazz = obj.getClass();
			} else {
				clazz = clazz.getSuperclass();
			}
			if (clazz.getName().startsWith("java")) {
				break;
			}
			fields = clazz.getDeclaredFields();
			field = null;
			isAccessible = false;
			// 遍历所有类成员变量, 为赋值作准备
			for (int j = 0; j < fields.length; j++) {
				field = fields[j];
				// 忽略字段名大小写
				if (field.getName().equalsIgnoreCase(fieldName)) {
					// 得到类成员变量数据类型
					Class<?> cClass = field.getType();
					Object objValue = null;
					if (value == null) {
						objValue = Api.valueOf(cClass, "");
					} else if (value instanceof String) {
						objValue = Api.valueOf(cClass, (String) value);
					} else {
						objValue = value;
					}

					if (obj != null) {
						// 保存现在的字段存储"权限"(对于不同属性的类成员变量)状态
						isAccessible = field.isAccessible();
						// 设定为可存取
						field.setAccessible(true);
						try {
							// 对象字段赋值
							field.set(obj, objValue);
							bRet = true;
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} finally {
							// 恢复之前的存储权限状态
							field.setAccessible(isAccessible);
						}
					}
					break;
				}
			}
		}
		return bRet;
	}

	/******************** < 线程APIs > ********************/

	/**
	 * 线程休眠
	 * 
	 * @param millis
	 * @return boolean
	 */
	public static boolean sleep(long millis) {
		boolean bRet = true;
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			bRet = false;
		}
		return bRet;
	}

	/******************** < 日期时间APIs > ********************/
	/**
	 * 得到现在的时间
	 * 
	 * @return 毫秒数
	 */
	public static Timestamp getNow() {
		java.util.Date now = new java.util.Date();
		String szNow = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS")
				.format(now);
		return Timestamp.valueOf(szNow);
	}

	/**
	 * getTimeInMillis
	 * 
	 * @todo 得到unix纪元到日期的毫秒数
	 * @param tempDate
	 *            Date
	 * @return long
	 */
	public static long getTimeInMillis(java.util.Date tempDate) {
		java.util.Calendar tempCalendar = java.util.Calendar.getInstance();
		tempCalendar.setTime(tempDate);
		return tempCalendar.getTimeInMillis();
	}

	/**
	 * getField
	 * 
	 * @todo 得到Date的各域的值
	 * @param tempDate
	 *            Date
	 * @param tempFieldConstant
	 *            int
	 * @return int
	 */
	public static int getField(java.util.Date tempDate, int tempFieldConstant) {
		java.util.Calendar tempCalendar = java.util.Calendar.getInstance();
		tempCalendar.setTime(tempDate);
		return tempCalendar.get(tempFieldConstant);
	}

	/**
	 * 时间增减
	 * 
	 * @param date
	 *            Date
	 * @param field
	 *            int
	 * @param interval
	 *            int
	 * @return Date
	 */
	public static java.util.Date addDate(java.util.Date date, int field,
			int interval) {
		java.util.Calendar cal = java.util.Calendar.getInstance();
		cal.setTime(date);
		cal.add(field, interval);
		return cal.getTime();
	}

	/**
	 * 将一个日期对象转换成为指定日期,时间格式的字符串,如果日期对象为空,返回一个空字符串,而不是一个空对象
	 * 
	 * @param date
	 *            要转换的日期对象
	 * @param format
	 *            返回的日期字符串的格式
	 * @return 转换结果
	 */
	public static String toString(java.util.Date date, String format) {
		/**
		 * 详细设计: 1.theDate为空,则返回"" 2.否则使用theDateFormat格式化
		 */
		if (date == null) {
			return "";
		}
		java.text.SimpleDateFormat tempFormatter = new java.text.SimpleDateFormat(
				format);
		return tempFormatter.format(date);
	}

	/**
	 * toDate
	 * 
	 * @todo 字符串到DateTime的转换
	 * @param text
	 *            String 时间字符串
	 * @param fotmat
	 *            String 时间字符串格式("yyyy-MM-dd HH:mm:ss")
	 * @return Date
	 */
	public static java.util.Date toDate(String text, String fotmat) {
		java.util.Date dRet = new Date(0);
		java.text.SimpleDateFormat sft = new java.text.SimpleDateFormat(fotmat);
		try {
			dRet = sft.parse(text);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return dRet;
	}

	/**
	 * DiffSeconds
	 * 
	 * @todo 得到两个日期相隔的秒数
	 * @param prefixDate
	 *            Date
	 * @param suffixDate
	 *            Date
	 * @return long
	 */
	public static long diffSeconds(java.util.Date prefixDate,
			java.util.Date suffixDate) {
		long iDiff = 0;
		java.util.Calendar tempCalendarStart = java.util.Calendar.getInstance();
		tempCalendarStart.setTime(prefixDate);
		java.util.Calendar tempCalendarEnd = java.util.Calendar.getInstance();
		tempCalendarEnd.setTime(suffixDate);
		iDiff = tempCalendarStart.getTimeInMillis()
				- tempCalendarEnd.getTimeInMillis();
		if (iDiff < 0) {
			iDiff *= -1;
		}
		return (long) (iDiff / 1000);
	}

	/**
	 * 得到两个日期相隔的分钟数
	 * 
	 * @param prefixDate
	 *            Date
	 * @param suffixDate
	 *            Date
	 * @return long
	 */
	public static long diffMinutes(java.util.Date prefixDate,
			java.util.Date suffixDate) {
		long iDiff = 0;
		iDiff = diffSeconds(prefixDate, suffixDate);
		return (long) (iDiff / 60);
	}

	/**
	 * 得到两个日期相隔的小时数
	 * 
	 * @param prefixDate
	 *            Date
	 * @param suffixDate
	 *            Date
	 * @return long
	 */
	public static long diffHours(java.util.Date prefixDate,
			java.util.Date suffixDate) {
		long iDiff = 0;
		iDiff = diffSeconds(prefixDate, suffixDate);
		return (long) (iDiff / (60 * 60));
	}

	/**
	 * DiffDays
	 * 
	 * @todo 得到两个日期相隔的天数
	 * @param prefixDate
	 *            Date
	 * @param suffixDate
	 *            Date
	 * @return long
	 */
	public static long diffDays(java.util.Date prefixDate,
			java.util.Date suffixDate) {
		long iDiff = 0;
		iDiff = diffSeconds(prefixDate, suffixDate);
		return (long) (iDiff / (24 * 60 * 60));
	}

	/**
	 * 取得指定日期的所处星期的第一天
	 * 
	 * @param date
	 *            Date 指定日期
	 * @return Date
	 */
	public static java.util.Date getFirstDayOfWeek(java.util.Date date) {
		/**
		 * 详细设计： 1.如果date是星期日,则减6天 2.如果date是星期一,则减0天 3.如果date是星期二,则减1天
		 * 4.如果date是星期三,则减2天 5.如果date是星期四,则减3天 6.如果date是星期五,则减4天
		 * 7.如果date是星期六,则减5天
		 */
		java.util.GregorianCalendar gc = (java.util.GregorianCalendar) java.util.Calendar
				.getInstance();
		gc.setTime(date);
		switch (gc.get(java.util.Calendar.DAY_OF_WEEK)) {
		case (java.util.Calendar.SUNDAY):
			gc.add(java.util.Calendar.DATE, 6);
			break;
		case (java.util.Calendar.MONDAY):
			gc.add(java.util.Calendar.DATE, 0);
			break;
		case (java.util.Calendar.TUESDAY):
			gc.add(java.util.Calendar.DATE, -1);
			break;
		case (java.util.Calendar.WEDNESDAY):
			gc.add(java.util.Calendar.DATE, -2);
			break;
		case (java.util.Calendar.THURSDAY):
			gc.add(java.util.Calendar.DATE, -3);
			break;
		case (java.util.Calendar.FRIDAY):
			gc.add(java.util.Calendar.DATE, -4);
			break;
		case (java.util.Calendar.SATURDAY):
			gc.add(java.util.Calendar.DATE, -5);
			break;
		}
		return gc.getTime();
	}

	/**
	 * gerLastDayOfWeek
	 * 
	 * @todo 指定日期的所处星期的最后一天
	 * @param date
	 *            指定日期
	 * @return java.util.Date
	 */
	public static java.util.Date getLastDayOfWeek(java.util.Date date) {
		/**
		 * 详细设计: 1.如果date是星期日,则加0天 2.如果date是星期一,则加6天 3.如果date是星期二,则加5天
		 * 4.如果date是星期三,则加4天 5.如果date是星期四,则加3天 6.如果date是星期五,则加2天
		 * 7.如果date是星期六,则加1天
		 */
		java.util.GregorianCalendar gc = (java.util.GregorianCalendar) java.util.Calendar
				.getInstance();
		gc.setTime(date);
		switch (gc.get(java.util.Calendar.DAY_OF_WEEK)) {
		case (java.util.Calendar.SUNDAY):
			gc.add(java.util.Calendar.DATE, 0);
			break;
		case (java.util.Calendar.MONDAY):
			gc.add(java.util.Calendar.DATE, 6);
			break;
		case (java.util.Calendar.TUESDAY):
			gc.add(java.util.Calendar.DATE, 5);
			break;
		case (java.util.Calendar.WEDNESDAY):
			gc.add(java.util.Calendar.DATE, 4);
			break;
		case (java.util.Calendar.THURSDAY):
			gc.add(java.util.Calendar.DATE, 3);
			break;
		case (java.util.Calendar.FRIDAY):
			gc.add(java.util.Calendar.DATE, 2);
			break;
		case (java.util.Calendar.SATURDAY):
			gc.add(java.util.Calendar.DATE, 1);
			break;
		}
		return gc.getTime();
	}

	/**
	 * getFirstdayOfMonth
	 * 
	 * @todo 得到一个月的第一天
	 * @param tempDate
	 *            Date
	 * @return int
	 */
	public static java.util.Date getFirstDayOfMonth(java.util.Date tempDate) {
		int iFirstdayOfMonth = 1;
		if (tempDate == null) {
			return null;
		}
		java.util.Calendar tempCalendar = java.util.Calendar.getInstance();
		tempCalendar.setTime(tempDate);
		tempCalendar.set(java.util.Calendar.DAY_OF_MONTH, iFirstdayOfMonth);
		return tempCalendar.getTime();
	}

	/**
	 * getLastdayOfMonth
	 * 
	 * @todo 得到一个月的最后一天
	 * @param tempDate
	 *            Date
	 * @return int
	 */
	public static java.util.Date getLastDayOfMonth(java.util.Date tempDate) {
		int iLastdayOfMonth = 0;
		if (tempDate == null) {
			return null;
		}
		java.util.Calendar tempCalendar = java.util.Calendar.getInstance();
		tempCalendar.setTime(tempDate);
		iLastdayOfMonth = tempCalendar
				.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
		tempCalendar.set(java.util.Calendar.DAY_OF_MONTH, iLastdayOfMonth);
		return tempCalendar.getTime();
	}

	/**
	 * 取得星期几
	 * 
	 * @param date
	 * @return 整型
	 */
	public static int getWeekDay(java.util.Date date) {
		/**
		 * 详细设计: 1.如果date是星期日,则加0天 2.如果date是星期一,则加6天 3.如果date是星期二,则加5天
		 * 4.如果date是星期三,则加4天 5.如果date是星期四,则加3天 6.如果date是星期五,则加2天
		 * 7.如果date是星期六,则加1天
		 */
		java.util.GregorianCalendar gc = (java.util.GregorianCalendar) java.util.Calendar
				.getInstance();
		gc.setTime(date);
		int nWeekDay = 0;
		switch (gc.get(java.util.Calendar.DAY_OF_WEEK)) {
		case (java.util.Calendar.SUNDAY):
			nWeekDay = 7;
			break;
		case (java.util.Calendar.MONDAY):
			nWeekDay = 1;
			break;
		case (java.util.Calendar.TUESDAY):
			nWeekDay = 2;
			break;
		case (java.util.Calendar.WEDNESDAY):
			nWeekDay = 3;
			break;
		case (java.util.Calendar.THURSDAY):
			nWeekDay = 4;
			break;
		case (java.util.Calendar.FRIDAY):
			nWeekDay = 5;
			break;
		case (java.util.Calendar.SATURDAY):
			nWeekDay = 6;
			break;
		}
		return nWeekDay;
	}

	/******************** < 对象序列化 APIs > ********************/

	/**
	 * 得到对象序列化字节流
	 * 
	 * @param obj
	 * @return the specail byte array
	 * @throws IOException
	 */
	public static byte[] getBytes(Object obj) throws IOException {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ObjectOutputStream oos = new ObjectOutputStream(baos);
		oos.writeObject(obj);
		byte[] data = baos.toByteArray();
		baos.close();
		oos.close();
		return data;
	}

	/**
	 * 从序列化字节流构造一个对象
	 * 
	 * @param data
	 *            the specail byte array
	 * @return a specail Object
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	public static Object getObject(byte[] data) throws IOException,
			ClassNotFoundException {
		Object obj = null;
		if (data != null) {
			ByteArrayInputStream bais = null;
			ObjectInputStream ois = null;
			bais = new ByteArrayInputStream(data);
			if (bais != null) {
				ois = new ObjectInputStream(bais);
				if (ois != null) {
					obj = ois.readObject();
					ois.close();
				}
				bais.close();
			}
		}
		return obj;
	}

	/******************** < 加解密算法 APIs > ********************/

	/**
	 * MD5单向散列加密算法
	 * 
	 * @param bytes
	 * @return 返回字节数组
	 */
	public static byte[] md5(byte[] bytes) {
		byte[] outBytes = new byte[] {};
		try {
			outBytes = MessageDigest.getInstance("MD5").digest(bytes);
		} catch (NoSuchAlgorithmException e) {
			//
		}
		return outBytes;
	}

	/**
	 * MD5单向散列加密算法
	 * 
	 * @param s
	 * @return 十六进制MD5加密算法字符串
	 */
	public static String md5(String s) {
		byte[] digest = md5(s.getBytes());
		StringBuffer sb = new StringBuffer();
		for (byte aDigest : digest) {
			String tmp = Integer.toHexString(0xFF & aDigest);
			if (tmp.length() == 1) {
				sb.append("0");
			}
			sb.append(tmp);
		}
		return sb.toString().toUpperCase();
	}

	/**
	 * 判断类是否存在
	 * 
	 * @param clazz
	 * @return true or false
	 */
	public static boolean isExists(String clazz) {
		boolean bRet = false;
		try {
			Class.forName(clazz);
			bRet = true;
		} catch (ClassNotFoundException e) {
			// e.printStackTrace();
		}
		return bRet;
	}

	/******************** < 随机 APIs > ********************/
	private static final String O3CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

	public static Random randomize() {
		long seed = System.currentTimeMillis();
		return new Random(seed);
	}

	public static int rand(Random random, int max) {
		return random.nextInt(max);
	}

	/**
	 * 取得一个O3字符
	 * 
	 * @param index
	 * @return
	 */
	public static String o3String(byte[] data) {
		String sRet = null;
		if (data == null) {
			data = Api.md5("0".getBytes());
		}
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] bytes = O3CHARS.getBytes();
		int max = O3CHARS.length();
		for (int i = 0; i < data.length; i++) {
			int n = data[i];
			if (n < 0) {
				n += 256;
			}
			n = n % max;
			baos.write(bytes[n]);
		}
		sRet = baos.toString();
		try {
			baos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	/**
	 * 获得一个最大length长度的随机字符串
	 * 
	 * @param length
	 * @return
	 */
	public static String o3String(int length) {
		StringBuffer sRet = new StringBuffer();
		Random random = randomize();
		int max = O3CHARS.length();
		if (length > 1024) {
			length = 1024;
		}
		for (int i = 0; i < length; i++) {
			int n = rand(random, max);
			String c = O3CHARS.substring(n, n + 1);
			sRet.append(c);
		}

		return sRet.toString();
	}
}
