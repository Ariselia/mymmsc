/**
 * 
 */
package com.fengxiafei.core.qrcode.bean;

import java.io.Serializable;

/**
 * 媒体页bean
 * 
 * @author wangfeng
 * 
 */
public class MediaPage implements Serializable {
	private static final long serialVersionUID = 1L;
	private String title; // 标题
	private String content; // 内容
	private String audio; // 背景音乐URL
	private String image; // 图片URL
	private String video; // 视频URL

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
	 * @return the image
	 */
	public String getImage() {
		return image;
	}

	/**
	 * @param image
	 *            the image to set
	 */
	public void setImage(String image) {
		this.image = image;
	}

	/**
	 * @return the video
	 */
	public String getVideo() {
		return video;
	}

	/**
	 * @param video
	 *            the video to set
	 */
	public void setVideo(String video) {
		this.video = video;
	}
}
