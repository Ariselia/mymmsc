/**
 * 
 */
package com.fengxiafei.core.qrcode.bean;

/**
 * 码 属性
 * 
 * @author wangfeng
 * 
 */
public class CodeAttribute {
	private long id; // uuid
	private String t; // type
	private int c; // color
	private int s; // size
	private int h; // height
	private int w; // width
	private int l; // hasLog
	private int bg; // hasBackGroud
	private String bgUrl; // backGroudUrl
	private int uid; // userid
	private int utype; // usertype
	private int ch; // channel
	private int mIn; // madeIn

	public long getId() {
		return id;
	}

	public String getT() {
		return t;
	}

	public int getC() {
		return c;
	}

	public int getS() {
		return s;
	}

	public int getH() {
		return h;
	}

	public int getW() {
		return w;
	}

	public int getL() {
		return l;
	}

	public int getBg() {
		return bg;
	}

	public String getBgUrl() {
		return bgUrl;
	}

	public int getUid() {
		return uid;
	}

	public int getUtype() {
		return utype;
	}

	public int getCh() {
		return ch;
	}

	public int getmIn() {
		return mIn;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setT(String t) {
		this.t = t;
	}

	public void setC(int c) {
		this.c = c;
	}

	public void setS(int s) {
		this.s = s;
	}

	public void setH(int h) {
		this.h = h;
	}

	public void setW(int w) {
		this.w = w;
	}

	public void setL(int l) {
		this.l = l;
	}

	public void setBg(int bg) {
		this.bg = bg;
	}

	public void setBgUrl(String bgUrl) {
		this.bgUrl = bgUrl;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public void setUtype(int utype) {
		this.utype = utype;
	}

	public void setCh(int ch) {
		this.ch = ch;
	}

	public void setmIn(int mIn) {
		this.mIn = mIn;
	}
}
