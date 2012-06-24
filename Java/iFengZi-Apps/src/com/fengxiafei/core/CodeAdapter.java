/**
 * 
 */
package com.fengxiafei.core;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.io.HttpClient;
import org.mymmsc.api.io.HttpResult;

import com.fengxiafei.core.qrcode.BaseBean;
import com.fengxiafei.core.qrcode.Business;
import com.fengxiafei.core.qrcode.CommonBean;
import com.fengxiafei.core.qrcode.KmaBean;
import com.fengxiafei.core.qrcode.bean.AppUrl;
import com.fengxiafei.core.qrcode.bean.BookMark;
import com.fengxiafei.core.qrcode.bean.Card;
import com.fengxiafei.core.qrcode.bean.Email;
import com.fengxiafei.core.qrcode.bean.EncText;
import com.fengxiafei.core.qrcode.bean.GMap;
import com.fengxiafei.core.qrcode.bean.KMA;
import com.fengxiafei.core.qrcode.bean.Phone;
import com.fengxiafei.core.qrcode.bean.RichMedia;
import com.fengxiafei.core.qrcode.bean.Schedule;
import com.fengxiafei.core.qrcode.bean.ShortMessage;
import com.fengxiafei.core.qrcode.bean.Text;
import com.fengxiafei.core.qrcode.bean.Url;
import com.fengxiafei.core.qrcode.bean.Weibo;
import com.fengxiafei.core.qrcode.bean.WiFiText;

/**
 * 码适配器
 * 
 * @author wangfeng
 * 
 */
public class CodeAdapter {
	private String orig = null;
	private byte codeType = Business.UNKNOWN_TEXT;
	// 兼容旧的方式
	// private BusCategory category = null;
	// 新的编码方式
	private List<String> list = null;
	private Map<String, String> codeMap = null;

	private CodeAdapter(String orig, byte type) {
		this.orig = orig;
		this.codeType = type;
	}
	
	/**
	 * 组织码的URL
	 * @param codeId
	 * @return
	 */
	public static String codeUrl(String codeId){
		return Category.CODE_PREFIX + "?id=" + codeId;
	}
	
	/**
	 * 编码基本拆解, 码格式"key:value;"
	 * 
	 * @param str
	 * @return
	 */
	private boolean parse() {
		boolean bRet = false;
		String exp = "(([^:;]+):(([^\\\\;])*(\\\\;)*[^;]*);)";
		Pattern p = Pattern.compile(exp, Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(orig);
		int offset = 2;
		String key = null;
		String value = null;
		while (m.find()) {
			if (codeMap == null) {
				codeMap = new HashMap<String, String>();
				list = new ArrayList<String>();
				bRet = true;
			}
			key = m.group(offset);
			value = m.group(offset + 1);
			if (value != null) {
				value = Api.urlDecode(value);
			} else {
				value = "";
			}
			// System.out.println("  key = [" + key + "]");
			// System.out.println("value = [" + value + "]");
			value = value.replaceAll("\\\\;", ";");
			value = value.replaceAll("\\\\:", ":");
			codeMap.put(key, value);
			list.add(value);
		}
		return bRet;
	}

	/**
	 * 获得1-13种业务bean
	 * 
	 * @return
	 */
	private Class<?> getType() {
		Class<?> clazz = null;
		switch (codeType) {
		case Business.Url:
			// 01-URL
			clazz = Url.class;
			break;
		case Business.BookMark:
			// 02-书签
			clazz = BookMark.class;
			break;
		case Business.AppUrl:
			// 03-应用程序链接地址
			clazz = AppUrl.class;
			break;
		case Business.Weibo:
			// 04-微博
			clazz = Weibo.class;
			break;
		case Business.Card:
			// 05-名片
			clazz = Card.class;
			break;
		case Business.Phone:
			// 06-电话号码
			clazz = Phone.class;
			break;
		case Business.Email:
			// 07-电子邮件
			clazz = Email.class;
			break;
		case Business.Text:
			// 08-文本
			clazz = Text.class;
			break;
		case Business.EncText:
			// 09-名片
			clazz = EncText.class;
			break;
		case Business.ShortMessage:
			// 0A-短信
			clazz = ShortMessage.class;
			break;
		case Business.WiFiText:
			// 0B-WIFI
			clazz = WiFiText.class;
			break;
		case Business.GMap:
			// 0C-地图
			clazz = GMap.class;
			break;
		case Business.Schedule:
			// 0D-日程
			clazz = Schedule.class;
			break;
		case Business.RichMedia:
			// 0E-富媒体
			clazz = RichMedia.class;
			break;
		case Business.KMA:
			// 0F-空码
			clazz = KMA.class;
			break;
		default:
			// 默认
			break;
		}
		return clazz;
	}

	private Object get(Class<?> clazz) {
		Object obj = null;
		if (clazz != null) {
			Field[] fields = null;
			int j = 0; // 编码字段序号
			do {
				int count = list.size();
				fields = clazz.getDeclaredFields();
				count = fields.length;
				int i = 0; // 类成员变量序号
				for (i = 0; i < count; i++) {
					if (obj == null) {
						try {
							obj = clazz.newInstance();
						} catch (InstantiationException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
					}
					Field field = fields[i];
					if (field.getName().equalsIgnoreCase("serialVersionUID")) {
						continue;
					}
					// System.out.println("i=" + i + ",j=" + j);
					String value = list.get(j++);
					// 保存现在的字段存储"权限"(对于不同属性的类成员变量)状态
					boolean isAccessible = field.isAccessible();
					// 设定为可存取
					field.setAccessible(true);
					try {
						// 对象字段赋值
						field.set(obj, Api.valueOf(field.getType(), value));
					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} finally {
						// 恢复之前的存储权限状态
						field.setAccessible(isAccessible);
					}
				}
				clazz = clazz.getSuperclass();
				fields = clazz.getDeclaredFields();
				if (clazz.getName().startsWith("java")) {
					break;
				}
			} while (true);
		}

		return obj;
	}

	/**
	 * 解码, 码格式"key:value;"
	 * 
	 * @param string
	 * @return CodeAdapter
	 */
	public static Object parse(String string) {
		Object obj = null;
		CodeAdapter adapter = null;
		String orig = null;
		byte type = Business.UNKNOWN_TEXT;
		String str = string;
		// 判断码的前缀URL
		if (string.startsWith(Category.CODE_PREFIX + '?')) {
			str = string.substring(Category.CODE_PREFIX.length() + 1);
		}
		if (str.startsWith("id=")) {
			String codeId = str.substring(3);
			String url = Category.MEDIA_PREFIX + '?' + str;
			HttpClient hc = new HttpClient(url, 30);
			HttpResult hRet = hc.post(null, null);
			System.out.println("http-status=[" + hRet.getStatus() + "], body=["
					+ hRet.getBody() + "], message=" + hRet.getError());
			if (hRet.getStatus() == 200 && hRet.getBody().length() > 0) {
				String body = hRet.getBody();
				RichMedia rm = null;
				int status = 0;
				JsonAdapter json = JsonAdapter.parse(body);
				if (json != null) {
					KmaBean kb = json.get(KmaBean.class);
					status = kb.getStatus();
					rm = kb.getData();
					if (rm != null) {
						if (rm.getCodeId() == null) {
							rm.setCodeId(codeId);
						}
						obj = rm;
					} else {
						json = JsonAdapter.parse(body);
						CommonBean cb = json.get(CommonBean.class);
						if (cb.getData() != null) {
							str = cb.getData();
							if (str != null) {
								str = Api.urlDecode(str);
							}
						}
					}
					json.close();
				}
				
				if (obj == null && status == Category.API_iKma) {
					if (codeId.indexOf('-') < 0) {
						// 空码, 空码是连续的数字
						KMA kma = new KMA();
						kma.setCodeId(codeId);
						obj = kma;
					} else {
						// 富媒体, 富媒体码格式是guid
						rm = new RichMedia();
						rm.setCodeId(codeId);
						obj = rm;
					}
				}
			} else {
				// 网络异常
				if (codeId.indexOf('-') < 0) {
					// 空码, 空码是连续的数字
					KMA kma = new KMA();
					kma.setTypeId(Business.ERROR_KMA);
					kma.setCodeId(codeId);
					obj = kma;
				} else {
					// 富媒体, 富媒体码格式是guid
					RichMedia rm = new RichMedia();
					rm.setTypeId(Business.ERROR_RICHMEDIA);
					rm.setCodeId(codeId);
					obj = rm;
				}
			}
		}
		if (obj == null && str != null) {
			str = str.trim();
			String exp = "^([0-9A-F][1-9A-F])";
			Pattern p = Pattern.compile(exp, Pattern.CASE_INSENSITIVE);
			Matcher m = p.matcher(str);
			if (m.find()) {
				String sType = m.group();
				if (sType.trim().length() == 0) {
					sType = "00";
				}
				type = Byte.valueOf(sType, 16);
				str = str.substring(m.group().length());
				orig = str;
				adapter = new CodeAdapter(orig, type);
				if (adapter != null) {
					boolean ret = adapter.parse();
					if (ret) {
						Class<?> clazz = adapter.getType();
						obj = adapter.get(clazz);
						// 修订编码字段超过, typeId被覆盖的bug [wangfeng@2012-6-15 上午10:12:10]
						if (obj != null) {
							BaseBean bb = (BaseBean)obj;
							bb.setTypeId(type);
						}
					}
				}
			} else {
				// 不是我们的业务
				if (str.startsWith("http")) {
					Url url = new Url();
					url.setContent(str);
					obj = url;
				} else {
					Text text = new Text();
					text.setContent(str);
					obj = text;
				}
			}
		}
		return obj;
	}

	/**
	 * 获得bean的码串
	 * 
	 * @param obj
	 *            对象
	 * @return String 码
	 * @remark 默认码标识使用大写A开始标记
	 */
	public static String get(Object obj) {
		return get(obj, false);
	}

	/**
	 * 获得bean的码串
	 * 
	 * @param obj
	 *            对象
	 * @param toLower
	 *            是否转换字段名为小写
	 * @return String 码
	 */
	public static String get(Object obj, boolean toLower) {
		if (obj != null && obj instanceof RichMedia) {
			return Category.CODE_PREFIX + "?id="
					+ ((RichMedia) obj).getCodeId();
		}
		return Category.CODE_PREFIX + "?" + getContent(obj, toLower);
	}
	
	/**
	 * 获得bean的码串
	 * 
	 * @param obj
	 *            对象
	 * @param toLower
	 *            是否转换字段名为小写
	 * @return String 码
	 */
	public static String getContent(Object obj, boolean toLower) {
		StringBuffer buffer = new StringBuffer();
		Class<?> clazz = obj.getClass();
		// 取得clazz类的成员变量列表
		Field[] fields = clazz.getDeclaredFields();
		Field field = null;
		String name = null;
		String value = null;
		Class<?> cls = null;
		Package clsPackage = null;
		String clsPrefix = null;
		BaseBean bb = (BaseBean) obj;
		buffer.append(String.format("%02X", bb.getTypeId()));
		boolean isAccessible = false;
		char fname = 'A';
		do {
			for (int j = 0; j < fields.length; j++) {
				field = fields[j];
				cls = field.getType();
				name = field.getName().trim();
				if (name.equalsIgnoreCase("serialVersionUID")) {
					continue;
				}
				// System.out.println("field = " + name);
				// System.out.println(" name = " + fname);
				buffer.append(fname);
				buffer.append(":");
				isAccessible = field.isAccessible();
				// print(cls.getName());
				clsPackage = cls.getPackage();
				if (clsPackage == null) {
					clsPrefix = null;
				} else {
					clsPrefix = clsPackage.getName();
				}
				// print("clsPrefix = " + clsPrefix);
				try {
					field.setAccessible(true);
					value = Api.toString(field.get(obj));
					if (value == null) {
						value = "";
					} else {
						value = value.replaceAll(";", "\\\\;");
						value = value.replaceAll(":", "\\\\:");
					}

					if (clsPrefix == null
							|| (clsPrefix != null && clsPrefix
									.startsWith("java"))) {
						buffer.append(value);
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} finally {
					field.setAccessible(isAccessible);
				}
				buffer.append(";");
				fname += 1;
			}
			clazz = clazz.getSuperclass();
			fields = clazz.getDeclaredFields();
			if (clazz.getName().startsWith("java")) {
				break;
			}
		} while (true);
		return buffer.toString();
	}
}
