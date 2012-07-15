/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.CRC32;
import java.util.zip.CheckedInputStream;
import java.util.zip.ZipInputStream;

import org.mymmsc.api.assembly.Api;

public class Unzip {

	/**
	 * 使用 java api 中的 ZipInputStream 类解压文件，但如果压缩时采用了
	 * org.apache.tools.zip.ZipOutputStream时，而不是 java 类库中的
	 * java.util.zip.ZipOutputStream时，该方法不能使用，原因就是编码方 式不一致导致，运行时会抛如下异常：
	 * java.lang.IllegalArgumentException at
	 * java.util.zip.ZipInputStream.getUTF8String(ZipInputStream.java:290)
	 * 当然，如果压缩包使用的是java类库的java.util.zip.ZipOutputStream 压缩而成是不会有问题的，但它不支持中文 @param
	 * archive 压缩包路径@param decompressDir 解压路径 @throws FileNotFoundException * @throws
	 * IOException
	 */
	public static void readByZipInputStream(String archive, String decompressDir)
			throws FileNotFoundException, IOException {
		BufferedInputStream bi;
		// ----解压文件(ZIP文件的解压缩实质上就是从输入流中读取数据):
		System.out.println("开始读压缩文件");

		// 这是解压ZIP格式的操作

		FileInputStream fi = new FileInputStream(archive);
		CheckedInputStream csumi = new CheckedInputStream(fi, new CRC32());
		ZipInputStream in2 = new ZipInputStream(csumi);
		bi = new BufferedInputStream(in2);
		java.util.zip.ZipEntry ze;// 压缩文件条目
		
		// end

		// 遍历压缩包中的文件条目
		while ((ze = in2.getNextEntry()) != null) {
			String entryName = ze.getName();
			String filePath =decompressDir + "/"
					+ entryName;
			if (ze.isDirectory()) {
				System.out.println("正在创建解压目录 - " + entryName);
				File decompressDirFile = new File(filePath);
				if (!decompressDirFile.exists()) {
					decompressDirFile.mkdirs();
				}
			} else {
				System.out.println("正在创建解压文件 - " + entryName);
				int pos = filePath.lastIndexOf("/");
				if (pos > 0) {
					String dirName = filePath.substring(0, pos);
					Api.mkdirs(dirName);
				}
				BufferedOutputStream bos = new BufferedOutputStream(
						new FileOutputStream(filePath));
				byte[] buffer = new byte[1024];
				int readCount = bi.read(buffer);

				while (readCount != -1) {
					bos.write(buffer, 0, readCount);
					readCount = bi.read(buffer);
				}
				bos.close();
			}
		}
		bi.close();
		System.out.println("Checksum: " + csumi.getChecksum().getValue());
	}

	public static void main(String[] args) throws Exception {
		String dirName = "/Users/wangfeng/Downloads";
		String apkname = dirName + "/" + "海豚浏览器.apk";
		
		String zippath = dirName + "/testzip/";// /解压到的目标文件路径
		readByZipInputStream(apkname, zippath);
	}
}
