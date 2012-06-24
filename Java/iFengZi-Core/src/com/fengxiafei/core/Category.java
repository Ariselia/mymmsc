/**
 * 
 */
package com.fengxiafei.core;

/**
 * iFengZi 字典
 * 
 * @author wangfeng
 * @version 3.0.1
 */
public final class Category {
	/** 版本号 */
	public final static String VERSION = "3.0.1";
	/** 码前缀 */
	public final static String CODE_PREFIX = "http://ifengzi.cn/show.cgi";
	/** 富媒体, 空码前缀 */
	public final static String MEDIA_PREFIX = "http://ifengzi.cn/apps/getCode.action";
	//public final static String MEDIA_PREFIX = "http://localhost:8080/apps/getCode.action";
	/** 编码 */
	public final static String ENCODING = "UTF-8";
	
	/** 媒体文件 - 类型: 1-音频,2-图片;3-flash;4-视频 */
	public final static int MEDIA_FILE_UNKNOWN = 0;

	/** 媒体文件 - 音频 */
	public final static int MEDIA_FILE_SOUND = MEDIA_FILE_UNKNOWN + 1;
	/** 媒体文件 - 图片 */
	public final static int MEDIA_FILE_IMAGE = MEDIA_FILE_UNKNOWN + 2;
	/** 媒体文件 - FLASH */
	public final static int MEDIA_FILE_FLASH = MEDIA_FILE_UNKNOWN + 3;
	/** 媒体文件 - 视频 */
	public final static int MEDIA_FILE_VIDEO = MEDIA_FILE_UNKNOWN + 4;
	
	/** 资源文件路径 */
	public final static String ResourcePath = "file";
	/** JSON文件路径 */
	public final static String JsonPath = "json";
	/** 批量生码路径 */
	public final static String QRCodePath = "qrcode";
	/** 用户头像位置 */
	public final static String UsersPath = "users";
	
	/** 正确码 */
	public final static int API_iSUCCESS = 0;
	/** 正确码描述 */
	public final static String API_sSUCCESS = "success";
	/** 编码错误 */
	public final static int API_iEncoding = 199;
	/** 编码错误描述 */
	public final static String API_sEncoding = "编码错误";
	/** 会话过期 */
	public final static int API_iExpired = 403;
	/** 会话过期描述 */
	public final static String API_sExpired = "会话过期, 请重新登录";
	/** 空码未赋值返回 */
	public final static int API_iKma = 404;
	/** 空码标识描述 */
	public final static String API_sKma = "码, 未赋值";
	/** 码不存在 */
	public final static int API_iBADKMA = 904;
	/** 码不存在描述 */
	public final static String API_sBADKMA = "Not Found";
	
	/** 数据操作失败 */
	public final static int API_iSQL_BAD_CONNECTION = 911;
	/** 数据操作失败 */
	public final static String API_sSQL_BAD_CONNECTION = "没有获取到java.sql.Connection";
	/** 数据操作失败 */
	public final static int API_iSQL_FAILED = 912;
	/** 数据操作失败 */
	public final static String API_sSQL_FAILED = "SQL语句执行失败";
}
