/**
 * @(#)JsonAdapter.java	6.3.12 2012/05/11
 *
 * Copyright 2000-2010 MyMMSC Software Foundation (MSF), Inc. All rights reserved.
 * MyMMSC PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package org.mymmsc.api.context;

import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.json.JacksonParser;
import org.mymmsc.api.context.json.JsonFactory;
import org.mymmsc.api.context.json.JsonParseException;
import org.mymmsc.api.context.json.JsonToken;


/**
 * JsonAdapter
 * 
 * @author WangFeng(wangfeng@yeah.net)
 * @since mymmsc-api 6.3.12
 * @since mymmsc-api 6.3.9
 * @remark 支持较为复杂的嵌套bean的json解析和输出json串
 */
public class JsonAdapter {
	private JacksonParser parser = null;

	private JsonAdapter(JacksonParser parser, boolean verbose) {
		this.parser = parser;
	}
	
	public static JsonAdapter parse(String string) {
		return parse(string, false);
	}
	
	public static JsonAdapter parse(String string, boolean verbose) {
		JsonAdapter ret = null;
		JsonFactory factory = new JsonFactory();
		JacksonParser jp = null;
		try {
			jp = factory.createJsonParser(string);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (jp != null) {
			ret = new JsonAdapter(jp, verbose);
		}
		return ret;
	}

	/**
	 * 解析数组
	 * 
	 * @param <T> 数组的元素类
	 * @param list 数组
	 */
	private <T> List<T> parseList(Class<T> clazz) {
		List<T> list = null;
		try {
			JsonToken token = null;
			String fieldName = parser.getCurrentName();
			if (fieldName == null) {
				parser.nextToken();
			}
			while ((token = parser.nextToken()) != JsonToken.END_ARRAY) {
				fieldName = parser.getCurrentName();
				if (token == JsonToken.START_ARRAY) {
					// 数组开始
					// list = new ArrayList<T>();
				} else if (token == JsonToken.END_ARRAY) {
					// 数组结束
				} else if (token == JsonToken.START_OBJECT) {
					// 新对象开始, 类的子类
					T obj = get(clazz);
					if (obj != null) {
						if (list == null) {
							list = new ArrayList<T>();
						}
						list.add(obj);
					}
				} else if (token == JsonToken.END_OBJECT) {
					// 对象结束
				} else if (token == JsonToken.END_ARRAY) {
					// 数组结束
				} else if (token == JsonToken.FIELD_NAME) {
					// 字段名
				} else if (fieldName != null) {
					// Api.setValue(obj, fieldName, fieldValue);
				}
			}
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 在当前JSON块解析一个对象
	 * 
	 * @param clazz 对象类
	 * @return clazz 对象
	 */
	public <T> T get(Class<T> clazz) {
		T tRet = null;
		try {
			JsonToken token = null;
			String fieldName = parser.getCurrentName();
			String fieldValue = null;
			Package clsPackage = null;
			String clsPrefix = null;
			if (fieldName == null) {
				parser.nextToken();
			}
			while ((token = parser.nextToken()) != JsonToken.END_OBJECT) {
				if (tRet == null) {
					try {
						tRet = clazz.newInstance();
					} catch (InstantiationException e) {
						//error("", e);
					} catch (IllegalAccessException e) {
						//error("", e);
					}
				}
				fieldName = parser.getCurrentName();
				fieldValue = parser.getText();
				Class<?> cls = Api.getClass(clazz, fieldName);
				if (cls == null) {
					continue;
				}
				clsPackage = cls.getPackage();
				if (clsPackage == null) {
					clsPrefix = null;
				} else {
					clsPrefix = clsPackage.getName();
				}
				if (token == JsonToken.START_ARRAY) {
					if (cls != null) {
						List<?> list = parseList(cls);
						if (list != null) {
							Api.setValue(tRet, fieldName, list);
						}
					}					
				} else if (token == JsonToken.END_ARRAY) {
					// 数组结束
				} else if (token == JsonToken.START_OBJECT) {
					if (cls != null) {
						Object obj = get(cls);
						if (obj != null) {
							Api.setValue(tRet, fieldName, obj);
						}						
					}
				} else if (token == JsonToken.END_OBJECT) {
					// 对象结束
				} else if (token == JsonToken.END_ARRAY) {
					// 数组结束
				} else if (token == JsonToken.FIELD_NAME) {
					// 字段名结束
				} else if (token == null) {
					// 令牌为空
					// 令牌为空时,可以继续解析, 如果终止解析,就会忽略之后的对象 [wangfeng@2012-6-8 下午11:04:17]
					//break;
				} else if (fieldName != null && (clsPrefix == null || clsPrefix.startsWith("java"))) {
					Api.setValue(tRet, fieldName, fieldValue);
				}
			}
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return tRet;
	}

	/**
	 * 获得List的JSON传
	 * 
	 * @param list java.util.List类对象
	 * @param toLower 字段名是否转为小写
	 * @return String JSON串
	 */
	private static <T> String getList(List<T> list, boolean toLower) {
		String sRet = null;
		if (list != null) {
			StringBuffer buffer = new StringBuffer();
			int count = list.size();
			for (int i = 0; i < count; i++) {
				Object obj = list.get(i);
				String s = get(obj, toLower);
				buffer.append(s);
				if (i + 1 < count) {
					buffer.append(",");
				}
			}
			sRet = buffer.toString();
		}
		return sRet;
	}
	
	/**
	 * 获得bean的JSON串
	 * @param obj 对象
	 * @param toLower 是否转换字段名为小写
	 * @return String JSON串, 以父类为先, 子类与父类在同一级数
	 */
	public static String get(Object obj, boolean toLower) {
		StringBuffer buffer = new StringBuffer();
		buffer.append("{");
		// 取得clazz类的成员变量列表
		Class<?> clazz = null;
		Field[] fields = null;
		Field field = null;
		String name = null;
		Object value = null;
		Class<?> cls = null;
		Package clsPackage = null;
		String clsPrefix = null;
		boolean isAccessible = false;
		while(obj != null) {
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
			// 遍历所有类成员变量, 为赋值作准备
			String sub = null;
			for (int j = 0; j < fields.length; j++) {
				field = fields[j];
				cls = field.getType();
				name = field.getName().trim();
				if (name.equalsIgnoreCase("serialVersionUID")) {
					continue;
				}
				buffer.append("\"");
				buffer.append(toLower ? name.toLowerCase():name);
				buffer.append("\":");
				isAccessible = field.isAccessible();
				//print(cls.getName());
				clsPackage = cls.getPackage();
				if (clsPackage == null) {
					clsPrefix = null;
				} else {
					clsPrefix = clsPackage.getName();
				}
				//print("clsPrefix = " + clsPrefix);
				try {
					field.setAccessible(true);
					value = field.get(obj);
					if (value == null && (clsPrefix == null || clsPrefix.startsWith("java"))) {
						value = Api.valueOf(cls, "");
					} else if (cls == java.sql.Date.class || cls == java.util.Date.class) {
						value = Api.toString(value);
					}
					
					if (cls == List.class) {
						buffer.append("[");
						sub = getList((List<?>) value, toLower);
						if (sub != null) {
							buffer.append(sub);
						}						
						buffer.append("]");
					} else if (value instanceof String) {
						buffer.append("\"");
						buffer.append(((String) value).replaceAll("\"", "\\\\\""));
						buffer.append("\"");
					} else if (clsPrefix != null && !clsPrefix.startsWith("java")) {
						if (value != null) {
							sub = get(value, toLower);
							buffer.append(sub);
						} else {
							buffer.append("{}");
						}
					} else {
						buffer.append(value);
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} finally {
					field.setAccessible(isAccessible);
				}
				if (j + 1 < fields.length || !clazz.getSuperclass().getName().startsWith("java")) {
					buffer.append(",");
				}
			}
		}
		buffer.append("}");
		return buffer.toString();
	}

	public void close() {
		try {
			parser.close();
		} catch (IOException e) {
			//
		}
	}
}
