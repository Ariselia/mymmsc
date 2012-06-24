/**
 * 
 */
package com.fengxiafei.apps.util.bean;

/**
 * 个人码统计数据
 * 
 * @author wangfeng
 * 
 */
public class CodeCount {
	/** 个人码数量 */
	private int numCode = 0;
	/** 个人码被扫描数 */
	private int numScan = 0;

	/**
	 * @return the numCode
	 */
	public int getNumCode() {
		return numCode;
	}

	/**
	 * @param numCode
	 *            the numCode to set
	 */
	public void setNumCode(int numCode) {
		this.numCode = numCode;
	}

	/**
	 * @return the numScan
	 */
	public int getNumScan() {
		return numScan;
	}

	/**
	 * @param numScan
	 *            the numScan to set
	 */
	public void setNumScan(int numScan) {
		this.numScan = numScan;
	}
}
