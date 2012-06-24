/**
 * 
 */
package com.fengxiafei.core.qrcode;

/**
 * 业务类型
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 */
public final class Business {
	/** 基础类型 */
	public final static byte BASE = 0x00;
	/** URL */
	public final static byte Url = (byte) (BASE + 1);
	/** 书签 */
	public final static byte BookMark = (byte) (BASE + 2);
	/** 应用程序链接地址 */
	public final static byte AppUrl = (byte) (BASE + 3);
	/** 微博 */
	public final static byte Weibo = (byte) (BASE + 4);
	/** 名片 */
	public final static byte Card = (byte) (BASE + 5);
	/** 电话号码 */
	public final static byte Phone = (byte) (BASE + 6);
	/** 电子邮件 */
	public final static byte Email = (byte) (BASE + 7);
	/** 文本 */
	public final static byte Text = (byte) (BASE + 8);
	/** 加密文本 */
	public final static byte EncText = (byte) (BASE + 9);
	/** 短信 */
	public final static byte ShortMessage = (byte) (BASE + 10);
	/** WIFI */
	public final static byte WiFiText = (byte) (BASE + 11);
	/** 地图 */
	public final static byte GMap = (byte) (BASE + 12);
	/** 日程 */
	public final static byte Schedule = (byte) (BASE + 13);
	/** 富媒体 */
	public final static byte RichMedia = (byte) (BASE + 14);
	/** 空码 */
	public final static byte KMA = (byte) (BASE + 0);
	/** 未知类型文本 */
	public final static byte UNKNOWN_TEXT = Text;
	/** 未知类型连接地址 */
	public final static byte UNKNOWN_URL = Url;
	/** 错误基数 */
	public final static byte ERROR_BASE = (byte)(0X80);
	/** 空码请求异常时的码类型 */
	public final static byte ERROR_KMA = (byte)(ERROR_BASE | KMA);
	/** 富媒体请求异常时的码类型 */
	public final static byte ERROR_RICHMEDIA = (byte)(ERROR_BASE | RichMedia);
}
