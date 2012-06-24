/**
 * 
 */
package com.fengxiafei.core.qrcode.bean;

import java.util.List;

import com.fengxiafei.core.qrcode.BaseBean;

/**
 * @author wangfeng
 * 
 */
public class RichMedia extends BaseBean {
	private static final long serialVersionUID = 1L;
	private String codeId; // 码ID
	//private byte type; // 类型
	private String title; // 标题
	private String content; // 内容
	private String audio; // 默认背景音乐
	private boolean isSend; // 是否跳转
	private int sendType;// 跳转类型
	private String sendContent;// 跳转位置
	private String mediaType;// 富媒体类型

	private List<MediaPage> pageList; // 富媒体页
	
	public RichMedia() {
		super();
	}
	
	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title
	 *            the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the content
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content
	 *            the content to set
	 */
	public void setContent(String content) {
		this.content = content;
	}

	/**
	 * @return the audio
	 */
	public String getAudio() {
		return audio;
	}

	/**
	 * @param audio
	 *            the audio to set
	 */
	public void setAudio(String audio) {
		this.audio = audio;
	}

	/**
	 * @return the pageList
	 */
	public List<MediaPage> getPageList() {
		return pageList;
	}

	/**
	 * @param pageList
	 *            the pageList to set
	 */
	public void setPageList(List<MediaPage> pageList) {
		this.pageList = pageList;
	}

	/**
	 * @return the codeId
	 */
	public String getCodeId() {
		return codeId;
	}

	/**
	 * @param codeId the codeId to set
	 */
	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}

	/**
	 * @return the isSend
	 */
	public boolean isSend() {
		return isSend;
	}

	/**
	 * @param isSend the isSend to set
	 */
	public void setSend(boolean isSend) {
		this.isSend = isSend;
	}

	/**
	 * @return the sendType
	 */
	public int getSendType() {
		return sendType;
	}

	/**
	 * @param sendType the sendType to set
	 */
	public void setSendType(int sendType) {
		this.sendType = sendType;
	}

	/**
	 * @return the sendContent
	 */
	public String getSendContent() {
		return sendContent;
	}

	/**
	 * @param sendContent the sendContent to set
	 */
	public void setSendContent(String sendContent) {
		this.sendContent = sendContent;
	}

	/**
	 * @return the mediaType
	 */
	public String getMediaType() {
		return mediaType;
	}

	/**
	 * @param mediaType the mediaType to set
	 */
	public void setMediaType(String mediaType) {
		this.mediaType = mediaType;
	}
}
