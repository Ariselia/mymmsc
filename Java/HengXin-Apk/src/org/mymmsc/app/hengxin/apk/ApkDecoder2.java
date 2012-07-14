/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;

import brut.androlib.Androlib;
import brut.androlib.AndrolibException;
import brut.androlib.err.InFileNotFoundException;
import brut.androlib.err.OutDirExistsException;
import brut.androlib.res.data.ResTable;
import brut.androlib.res.util.ExtFile;
import brut.androlib.src.SmaliDecoder;
import brut.common.BrutException;
import brut.directory.DirectoryException;
import brut.util.OS;

/**
 * 
 * @author wangfeng
 * 
 */
public class ApkDecoder2 {
	public final static short DECODE_SOURCES_NONE = 0x0000;
	public final static short DECODE_SOURCES_SMALI = 0x0001;
	public final static short DECODE_SOURCES_JAVA = 0x0002;

	public final static short DECODE_RESOURCES_NONE = 0x0100;
	public final static short DECODE_RESOURCES_FULL = 0x0101;

	private Androlib mAndrolib;
	private ExtFile mApkFile;
	private File mOutDir;
	private ResTable mResTable;
	private boolean mDebug = false;
	private boolean mForceDelete = false;
	private String mFrameTag;
	private boolean mKeepBrokenResources = false;

	public ApkDecoder2(File apkFile) {
		setApkFile(apkFile);
	}

	public ApkDecoder2() {
		this(new Androlib());
	}

	public ApkDecoder2(Androlib androlib)
	{
	this.mDebug = false;
	 this.mForceDelete = false;
	this.mKeepBrokenResources = false;
	this.mAndrolib = androlib;
	}
	
	public void setApkFile(File apkFile) {
		mApkFile = new ExtFile(apkFile);
		mResTable = null;
	}

	public void setOutDir(File outDir) throws AndrolibException {
		mOutDir = outDir;
	}
	
	private ResTable getResTable() throws AndrolibException {
		if (this.mResTable == null) {
			if (!(hasResources())) {
				throw new AndrolibException("Apk doesn't containt resources.arsc file");
			}
			brut.androlib.res.AndrolibResources.sKeepBroken = this.mKeepBrokenResources;
			this.mResTable = this.mAndrolib.getResTable(this.mApkFile);
			this.mResTable.setFrameTag(this.mFrameTag);
		}
		return this.mResTable;
	}
	
	private void decodeSourcesSmali(File apkFile, File outDir, boolean debug)
			throws AndrolibException {
		try {
			File smaliDir = new File(outDir, Category.SMALI_DIRNAME);
			OS.rmdir(smaliDir);
			smaliDir.mkdirs();
			SmaliDecoder.decode(apkFile, smaliDir, debug);
		} catch (BrutException ex) {
			throw new AndrolibException(ex);
		}
	}

	public void decode() throws AndrolibException {
		File outDir = getOutDir();

		if (!mForceDelete && outDir.exists()) {
			throw new OutDirExistsException();
		}

		if (!mApkFile.isFile() || !mApkFile.canRead()) {
			throw new InFileNotFoundException();
		}

		try {
			OS.rmdir(outDir);
		} catch (BrutException ex) {
			throw new AndrolibException(ex);
		}
		outDir.mkdirs();

		if (hasSources()) {
			decodeSourcesSmali(mApkFile, outDir, mDebug);
		}
		if (hasResources()) {
			XmlDecoder xd = new XmlDecoder();
			xd.decode(getResTable(), mApkFile, outDir);
		}
	}

	public void setDecodeSources(short mode) throws AndrolibException {
		if (mode != DECODE_SOURCES_NONE && mode != DECODE_SOURCES_SMALI
				&& mode != DECODE_SOURCES_JAVA) {
			throw new AndrolibException("Invalid decode sources mode: " + mode);
		}
	}

	public void setDecodeResources(short mode) throws AndrolibException {
		if (mode != DECODE_RESOURCES_NONE && mode != DECODE_RESOURCES_FULL) {
			throw new AndrolibException("Invalid decode resources mode");
		}
	}

	public void setDebugMode(boolean debug) {
		mDebug = debug;
	}

	public void setForceDelete(boolean forceDelete) {
		mForceDelete = forceDelete;
	}

	public void setKeepBrokenResources(boolean keepBrokenResources) {
		mKeepBrokenResources = keepBrokenResources;
	}

	public boolean hasSources() throws AndrolibException {
		try {
			return mApkFile.getDirectory().containsFile("classes.dex");
		} catch (DirectoryException ex) {
			throw new AndrolibException(ex);
		}
	}

	public boolean hasResources() throws AndrolibException {
		try {
			return mApkFile.getDirectory().containsFile("resources.arsc");
		} catch (DirectoryException ex) {
			throw new AndrolibException(ex);
		}
	}

	private File getOutDir() throws AndrolibException {
		if (mOutDir == null) {
			throw new AndrolibException("Out dir not set");
		}
		return mOutDir;
	}
}