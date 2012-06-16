/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;

import brut.androlib.Androlib;
import brut.androlib.AndrolibException;
import brut.androlib.ApkDecoder;

/**
 * @author wangfeng
 *
 */
public class ApkTool {
	@SuppressWarnings("unused")
	private ApkDecoder decoder = new ApkDecoder();
	
	private ApkTool() {
		//
	}
	
	public static void unpack(String apk, String output) {
		ApkDecoder decoder = new ApkDecoder();
		File outDir = new File(output);
		try {
			decoder.setOutDir(outDir);
			decoder.setApkFile(new File(apk));
			decoder.decode();
		} catch (AndrolibException e) {
			e.printStackTrace();
		}
	}
	
	public static void pack(String input) {
		File outFile = new File(input + ".apk");
		Androlib al = new Androlib();
		try {
			al.build(new File(input), outFile, true,
					true);
		} catch (AndrolibException e) {
			e.printStackTrace();
		}
	}
}
