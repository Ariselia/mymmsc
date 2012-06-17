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
public class ApkTool implements ApkRepackage{
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
		String in = input + "_new.tmp";
		String out = input + "_new.apk";
		File outFile = new File(in);
		Androlib al = new Androlib();
		//try {
			//al.build(new File(input), outFile, true, true);
			SignApk apk = new SignApk();
			apk.sign(in, out);
		//} catch (AndrolibException e) {
		//	e.printStackTrace();
		//}
	}

	@Override
	public byte[] pkgForChannel(byte[] input, String appId, String channelId) {
		// TODO Auto-generated method stub
		return null;
	}
}
