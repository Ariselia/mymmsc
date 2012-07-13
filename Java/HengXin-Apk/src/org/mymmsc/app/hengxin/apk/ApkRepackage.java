/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

/**
 * @author wangfeng
 * 
 */
public interface ApkRepackage {
	/**
	 * @param input
	 *            input apk byte array
	 * @param appId
	 *            app id of result apk
	 * @param channelId
	 *            channel id of result apk
	 * @return apk with right app id and channel id
	 */
	byte[] pkgForChannel(byte[] input, String appId, String channelId);
}
