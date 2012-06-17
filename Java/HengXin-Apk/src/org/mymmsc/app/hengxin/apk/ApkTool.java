/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;

import org.jf.baksmali.main;

import brut.androlib.Androlib;
import brut.androlib.AndrolibException;
import brut.androlib.ApkDecoder;

/**
 * @author wangfeng
 * 
 */
public class ApkTool implements ApkRepackage {
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
		try {
			al.build(new File(input), outFile, true, true);
			String dir = "/Users/wangfeng/temp/";
			String[] aa = new String[4];
			aa[0] = dir + "apklib/testkey.x509.pem";
			aa[1] = dir + "apklib/testkey.pk8";
			aa[2] = in;
			aa[3] = out;
			SignApk.main(aa);
		} catch (AndrolibException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public byte[] pkgForChannel(byte[] input, String appId, String channelId) {
		// TODO Auto-generated method stub
		return null;
	}
}
