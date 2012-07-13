/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.logging.Logger;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;

import brut.androlib.AndrolibException;
import brut.androlib.err.CantFindFrameworkResException;
import brut.androlib.res.AndrolibResources;
import brut.androlib.res.ResSmaliUpdater;
import brut.androlib.res.data.ResPackage;
import brut.androlib.res.data.ResResource;
import brut.androlib.res.data.ResTable;
import brut.androlib.res.data.ResValuesFile;
import brut.androlib.res.decoder.ARSCDecoder;
import brut.androlib.res.decoder.ARSCDecoder.ARSCData;
import brut.androlib.res.decoder.ARSCDecoder.FlagsOffset;
import brut.androlib.res.decoder.AXmlResourceParser;
import brut.androlib.res.decoder.Res9patchStreamDecoder;
import brut.androlib.res.decoder.ResAttrDecoder;
import brut.androlib.res.decoder.ResFileDecoder;
import brut.androlib.res.decoder.ResRawStreamDecoder;
import brut.androlib.res.decoder.ResStreamDecoderContainer;
import brut.androlib.res.decoder.XmlPullStreamDecoder;
import brut.androlib.res.util.ExtFile;
import brut.androlib.res.util.ExtMXSerializer;
import brut.androlib.res.util.ExtXmlSerializer;
import brut.androlib.res.xml.ResValuesXmlSerializable;
import brut.common.BrutException;
import brut.directory.Directory;
import brut.directory.DirectoryException;
import brut.directory.FileDirectory;
import brut.util.Duo;
import brut.util.Jar;

/**
 * @author wangfeng
 * 
 */
public class XmlDecoder {
	
	public ResTable getResTable(ExtFile apkFile) throws AndrolibException {
		ResTable resTable = new ResTable();
		loadMainPkg(resTable, apkFile);
		return resTable;
	}

	public ResPackage loadMainPkg(ResTable resTable, ExtFile apkFile)
			throws AndrolibException {
		LOGGER.info("Loading resource table...");
		ResPackage[] pkgs = getResPackagesFromApk(apkFile, resTable,
				sKeepBroken);
		ResPackage pkg = null;

		switch (pkgs.length) {
		case 1:
			pkg = pkgs[0];
			break;
		case 2:
			if (pkgs[0].getName().equals("android")) {
				LOGGER.warning("Skipping \"android\" package group");
				pkg = pkgs[1];
			}
			break;
		}

		if (pkg == null) {
			throw new AndrolibException(
					"Arsc files with zero or multiple packages");
		}

		resTable.addPackage(pkg, true);
		LOGGER.info("Loaded.");
		return pkg;
	}

	public ResPackage loadFrameworkPkg(ResTable resTable, int id,
			String frameTag) throws AndrolibException {
		File apk = getFrameworkApk(id, frameTag);

		LOGGER.info("Loading resource table from file: " + apk);
		ResPackage[] pkgs = getResPackagesFromApk(new ExtFile(apk), resTable,
				true);

		if (pkgs.length != 1) {
			throw new AndrolibException(
					"Arsc files with zero or multiple packages");
		}

		ResPackage pkg = pkgs[0];
		if (pkg.getId() != id) {
			throw new AndrolibException("Expected pkg of id: "
					+ String.valueOf(id) + ", got: " + pkg.getId());
		}

		resTable.addPackage(pkg, false);
		LOGGER.info("Loaded.");
		return pkg;
	}

	public void decode(ResTable resTable, ExtFile apkFile, File outDir)
			throws AndrolibException {
		Duo<ResFileDecoder, AXmlResourceParser> duo = getResFileDecoder();
		ResFileDecoder fileDecoder = duo.m1;
		ResAttrDecoder attrDecoder = duo.m2.getAttrDecoder();

		attrDecoder.setCurrentPackage(resTable.listMainPackages().iterator()
				.next());

		Directory inApk, out;
		try {
			inApk = apkFile.getDirectory();
			out = new FileDirectory(outDir);

			fileDecoder.decode(inApk, "AndroidManifest.xml", out,
					"AndroidManifest.xml", "xml");
		} catch (DirectoryException ex) {
			throw new AndrolibException(ex);
		}
	}

	
	@SuppressWarnings("unchecked")
	public boolean detectWhetherAppIsFramework(File appDir)
			throws AndrolibException {
		File publicXml = new File(appDir, "res/values/public.xml");
		if (!publicXml.exists()) {
			return false;
		}

		Iterator<String> it;
		try {
			it = IOUtils.lineIterator(new FileReader(new File(appDir,
					"res/values/public.xml")));
		} catch (FileNotFoundException ex) {
			throw new AndrolibException(
					"Could not detect whether app is framework one", ex);
		}
		it.next();
		it.next();
		return it.next().contains("0x01");
	}

	public void tagSmaliResIDs(ResTable resTable, File smaliDir)
			throws AndrolibException {
		new ResSmaliUpdater().tagResIDs(resTable, smaliDir);
	}

	public void updateSmaliResIDs(ResTable resTable, File smaliDir)
			throws AndrolibException {
		new ResSmaliUpdater().updateResIDs(resTable, smaliDir);
	}

	public Duo<ResFileDecoder, AXmlResourceParser> getResFileDecoder() {
		ResStreamDecoderContainer decoders = new ResStreamDecoderContainer();
		decoders.setDecoder("raw", new ResRawStreamDecoder());
		decoders.setDecoder("9patch", new Res9patchStreamDecoder());

		AXmlResourceParser axmlParser = new AXmlResourceParser();
		axmlParser.setAttrDecoder(new ResAttrDecoder());
		decoders.setDecoder("xml", new XmlPullStreamDecoder(axmlParser,
				getResXmlSerializer()));

		return new Duo<ResFileDecoder, AXmlResourceParser>(new ResFileDecoder(
				decoders), axmlParser);
	}

	public ExtMXSerializer getResXmlSerializer() {
		ExtMXSerializer serial = new ExtMXSerializer();
		serial.setProperty(ExtXmlSerializer.PROPERTY_SERIALIZER_INDENTATION,
				"    ");
		serial.setProperty(ExtXmlSerializer.PROPERTY_SERIALIZER_LINE_SEPARATOR,
				System.getProperty("line.separator"));
		serial.setProperty(ExtMXSerializer.PROPERTY_DEFAULT_ENCODING, "utf-8");
		serial.setDisabledAttrEscape(true);
		return serial;
	}

	@SuppressWarnings("unused")
	private void generateValuesFile(ResValuesFile valuesFile, Directory out,
			ExtXmlSerializer serial) throws AndrolibException {
		try {
			OutputStream outStream = out.getFileOutput(valuesFile.getPath());
			serial.setOutput((outStream), null);
			serial.startDocument(null, null);
			serial.startTag(null, "resources");

			for (ResResource res : valuesFile.listResources()) {
				if (valuesFile.isSynthesized(res)) {
					continue;
				}
				((ResValuesXmlSerializable) res.getValue())
						.serializeToResValuesXml(serial, res);
			}

			serial.endTag(null, "resources");
			serial.newLine();
			serial.endDocument();
			serial.flush();
			outStream.close();
		} catch (IOException ex) {
			throw new AndrolibException("Could not generate: "
					+ valuesFile.getPath(), ex);
		} catch (DirectoryException ex) {
			throw new AndrolibException("Could not generate: "
					+ valuesFile.getPath(), ex);
		}
	}

	private ResPackage[] getResPackagesFromApk(ExtFile apkFile,
			ResTable resTable, boolean keepBroken) throws AndrolibException {
		try {
			return ARSCDecoder.decode(
					apkFile.getDirectory().getFileInput("resources.arsc"),
					false, keepBroken, resTable).getPackages();
		} catch (DirectoryException ex) {
			throw new AndrolibException(
					"Could not load resources.arsc from file: " + apkFile, ex);
		}
	}

	public File getFrameworkApk(int id, String frameTag)
			throws AndrolibException {
		File dir = getFrameworkDir();
		File apk;

		if (frameTag != null) {
			apk = new File(dir, String.valueOf(id) + '-' + frameTag + ".apk");
			if (apk.exists()) {
				return apk;
			}
		}

		apk = new File(dir, String.valueOf(id) + ".apk");
		if (apk.exists()) {
			return apk;
		}

		if (id == 1) {
			InputStream in = null;
			OutputStream out = null;
			try {
				in = AndrolibResources.class
						.getResourceAsStream("/brut/androlib/android-framework.jar");
				out = new FileOutputStream(apk);
				IOUtils.copy(in, out);
				return apk;
			} catch (IOException ex) {
				throw new AndrolibException(ex);
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException ex) {
					}
				}
				if (out != null) {
					try {
						out.close();
					} catch (IOException ex) {
					}
				}
			}
		}

		throw new CantFindFrameworkResException(id);
	}

	public void installFramework(File frameFile, String tag)
			throws AndrolibException {
		InputStream in = null;
		ZipOutputStream out = null;
		try {
			ZipFile zip = new ZipFile(frameFile);
			ZipEntry entry = zip.getEntry("resources.arsc");

			if (entry == null) {
				throw new AndrolibException("Can't find resources.arsc file");
			}

			in = zip.getInputStream(entry);
			byte[] data = IOUtils.toByteArray(in);

			ARSCData arsc = ARSCDecoder.decode(new ByteArrayInputStream(data),
					true, true);
			publicizeResources(data, arsc.getFlagsOffsets());

			File outFile = new File(getFrameworkDir(), String.valueOf(arsc
					.getOnePackage().getId())
					+ (tag == null ? "" : '-' + tag)
					+ ".apk");

			out = new ZipOutputStream(new FileOutputStream(outFile));
			out.setMethod(ZipOutputStream.STORED);
			CRC32 crc = new CRC32();
			crc.update(data);
			entry = new ZipEntry("resources.arsc");
			entry.setSize(data.length);
			entry.setCrc(crc.getValue());
			out.putNextEntry(entry);
			out.write(data);

			LOGGER.info("Framework installed to: " + outFile);
		} catch (ZipException ex) {
			throw new AndrolibException(ex);
		} catch (IOException ex) {
			throw new AndrolibException(ex);
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException ex) {
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException ex) {
				}
			}
		}
	}

	public void publicizeResources(File arscFile) throws AndrolibException {
		byte[] data = new byte[(int) arscFile.length()];

		InputStream in = null;
		OutputStream out = null;
		try {
			in = new FileInputStream(arscFile);
			in.read(data);

			publicizeResources(data);

			out = new FileOutputStream(arscFile);
			out.write(data);
		} catch (IOException ex) {
			throw new AndrolibException(ex);
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException ex) {
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException ex) {
				}
			}
		}
	}

	public void publicizeResources(byte[] arsc) throws AndrolibException {
		publicizeResources(arsc,
				ARSCDecoder.decode(new ByteArrayInputStream(arsc), true, true)
						.getFlagsOffsets());
	}

	public void publicizeResources(byte[] arsc, FlagsOffset[] flagsOffsets)
			throws AndrolibException {
		for (FlagsOffset flags : flagsOffsets) {
			int offset = flags.offset + 3;
			int end = offset + 4 * flags.count;
			while (offset < end) {
				arsc[offset] |= (byte) 0x40;
				offset += 4;
			}
		}
	}

	private File getFrameworkDir() throws AndrolibException {
		File dir = new File(System.getProperty("user.home")
				+ File.separatorChar + "apktool" + File.separatorChar
				+ "framework");
		if (!dir.exists()) {
			if (!dir.mkdirs()) {
				throw new AndrolibException("Can't create directory: " + dir);
			}
		}
		return dir;
	}

	public File getAndroidResourcesFile() throws AndrolibException {
		try {
			return Jar
					.getResourceAsFile("/brut/androlib/android-framework.jar");
		} catch (BrutException ex) {
			throw new AndrolibException(ex);
		}
	}

	// TODO: dirty static hack. I have to refactor decoding mechanisms.
	public static boolean sKeepBroken = false;

	private final static Logger LOGGER = Logger
			.getLogger(AndrolibResources.class.getName());
}
