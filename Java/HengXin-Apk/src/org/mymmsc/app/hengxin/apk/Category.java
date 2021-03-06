/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

/**
 * HengXin-Apk 词条
 * 
 * @author wangfeng
 *
 */
public final class Category {
	/** android apk主配置文件 */
	public final static String Manifest = "AndroidManifest.xml";
	/** pem */
	public final static String PEM = "testkey.x509.pem";
	/** pk8 */
	public final static String PK8 = "testkey.pk8";
	public final static String SMALI_DIRNAME = "smali";
	public final static String APK_DIRNAME = "build/apk";
	public final static String[] APK_RESOURCES_FILENAMES =
        new String[]{"resources.arsc", "AndroidManifest.xml", "res"};
	public final static String[] APK_RESOURCES_WITHOUT_RES_FILENAMES =
        new String[]{"resources.arsc", "AndroidManifest.xml"};
	public final static String[] APP_RESOURCES_FILENAMES =
        new String[]{"AndroidManifest.xml", "res"};
}
