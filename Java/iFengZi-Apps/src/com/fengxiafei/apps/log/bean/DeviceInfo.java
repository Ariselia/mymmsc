/**
 * 
 */
package com.fengxiafei.apps.log.bean;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.core.util.Base64;

/**
 * 客户端激活信息
 * 
 * @author wangfeng
 * @version 3.0.2 2012/06/20
 */
public class DeviceInfo {
	private String r; // 分辨率
	private String s; // 屏幕大小
	private String av;
	private String iv; // 设备版本
	private String o; // 系统
	private String v; // 系统版本号
	private String eqn; // 型号
	private String mo; // 型号
	private String simop; // 运营商
	private String simnty; // sim卡网络类型
	private String simng; // 手机当前网络

	private String imei;

	private String version; // app版本号
	private String ch; // 渠道
	private String mobilenumber; // 手机号码

	public String getR() {
		return r;
	}

	public String getS() {
		return s;
	}

	public String getIv() {
		return iv;
	}

	public String getO() {
		return o;
	}

	public String getEqn() {
		return eqn;
	}

	public String getVersion() {
		return version;
	}

	public String getCh() {
		return ch;
	}

	public String getSimng() {
		return simng;
	}

	public void setR(String r) {
		this.r = r;
	}

	public void setS(String s) {
		this.s = s;
	}

	public void setIv(String iv) {
		this.iv = iv;
	}

	public void setO(String o) {
		this.o = o;
	}

	public void setEqn(String egn) {
		this.eqn = egn;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public void setCh(String ch) {
		this.ch = ch;
	}

	public void setSimng(String simng) {
		this.simng = simng;
	}

	/**
	 * @return the mobilenumber
	 */
	public String getMobilenumber() {
		return mobilenumber;
	}

	/**
	 * @param mobilenumber
	 *            the mobilenumber to set
	 */
	public void setMobilenumber(String mobilenumber) {
		this.mobilenumber = mobilenumber;
	}

	/**
	 * @return the imei
	 */
	public String getImei() {
		return imei;
	}

	/**
	 * @param imei
	 *            the imei to set
	 */
	public void setImei(String imei) {
		this.imei = imei;
	}

	/**
	 * @return the mo
	 */
	public String getMo() {
		return mo;
	}

	/**
	 * @param mo
	 *            the mo to set
	 */
	public void setMo(String mo) {
		this.mo = mo;
	}

	/**
	 * @return the v
	 */
	public String getV() {
		return v;
	}

	/**
	 * @param v
	 *            the v to set
	 */
	public void setV(String v) {
		this.v = v;
	}

	/**
	 * @return the simnty
	 */
	public String getSimnty() {
		return simnty;
	}

	/**
	 * @param simnty
	 *            the simnty to set
	 */
	public void setSimnty(String simnty) {
		this.simnty = simnty;
	}

	/**
	 * @return the simop
	 */
	public String getSimop() {
		return simop;
	}

	/**
	 * @param simop
	 *            the simop to set
	 */
	public void setSimop(String simop) {
		this.simop = simop;
	}

	/**
	 * @return the av
	 */
	public String getAv() {
		return av;
	}

	/**
	 * @param av
	 *            the av to set
	 */
	public void setAv(String av) {
		this.av = av;
	}

	public static void main(String[] argv) {
		String s = "01YzPjTJn1ckFMcqnWEk2Wnznauf5N78uZFfpyEhIWYzsWc8nBuVU1dcRN7gwNb9Rj9QnjTh0v-VULTqmv6GUh7VUvFGUANhHyqBpyQ-HMRVmhRz5iu1pyd8IZbqwdPPFMPGUyOM5RIjwDdKg1PZFh-Vuybqrjmkn1b3njTzPj01rHmzFMu-0MPGUv3qPauWpjY1PE";
		s = Base64.decode(s);
		System.out.println(s);
		DeviceInfo di = Api.parseParams(s, DeviceInfo.class);
		System.out.println(JsonAdapter.get(di, true));
	}
}
