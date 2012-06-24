/**
 * 
 */
package com.fengxiafei.core.qrcode;

import java.io.Serializable;

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
 * 二维码业务类型基类
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 */
public abstract class BaseBean implements Serializable {
	private static final long serialVersionUID = 1L;
	/** 业务类型 */
	private byte typeId = -1;

	/** 标示身份的id, 用作记录传递 */
	private String logId;

	public BaseBean() {
		if (typeId == -1) {
			Class<?> clazz = this.getClass();
			if (clazz == Url.class) {
				typeId = Business.Url;
			} else if (clazz == BookMark.class) {
				typeId = Business.BookMark;
			} else if (clazz == AppUrl.class) {
				typeId = Business.AppUrl;
			} else if (clazz == Weibo.class) {
				typeId = Business.Weibo;
			} else if (clazz == Card.class) {
				typeId = Business.Card;
			} else if (clazz == Email.class) {
				typeId = Business.Email;
			} else if (clazz == Phone.class) {
				typeId = Business.Phone;
			} else if (clazz == Text.class) {
				typeId = Business.Text;
			} else if (clazz == EncText.class) {
				typeId = Business.EncText;
			} else if (clazz == ShortMessage.class) {
				typeId = Business.ShortMessage;
			} else if (clazz == WiFiText.class) {
				typeId = Business.WiFiText;
			} else if (clazz == GMap.class) {
				typeId = Business.GMap;
			} else if (clazz == Schedule.class) {
				typeId = Business.Schedule;
			} else if (clazz == RichMedia.class) {
				typeId = Business.RichMedia;
			} else if (clazz == KMA.class) {
				typeId = Business.KMA;
			} else {
				typeId = Business.Text;
			}
		}
	}
	
	public byte type() {
		return typeId;
	}
	
	public String typeName() {
		String sRet = "未知码类型";
		if (typeId >= 0) {
			Class<?> clazz = this.getClass();
			if (clazz == Url.class) {
				sRet = "网站链接";
			} else if (clazz == BookMark.class) {
				sRet = "书签";
			} else if (clazz == AppUrl.class) {
				sRet = "应用程序下载地址";
			} else if (clazz == Weibo.class) {
				sRet = "微博";
			} else if (clazz == Card.class) {
				sRet = "名片";
			} else if (clazz == Email.class) {
				sRet = "电子邮件";
			} else if (clazz == Phone.class) {
				sRet = "电话号码";
			} else if (clazz == Text.class) {
				sRet = "文本";
			} else if (clazz == EncText.class) {
				sRet = "加密文本";
			} else if (clazz == ShortMessage.class) {
				sRet = "短信";
			} else if (clazz == WiFiText.class) {
				sRet = "WiFi";
			} else if (clazz == GMap.class) {
				sRet = "地图信息";;
			} else if (clazz == Schedule.class) {
				sRet = "日程";
			} else if (clazz == RichMedia.class) {
				sRet = "富媒体";
			} else if (clazz == KMA.class) {
				sRet = "空码";;
			} else {
				sRet = "文本";
			}
		}
		return sRet;
	}
	
	public String getLogId() {
		return logId;
	}

	public void setLogId(String logId) {
		this.logId = logId;
	}

	public byte getTypeId() {
		return typeId;
	}

	public void setTypeId(byte typeId) {
		this.typeId = typeId;
	}
}
