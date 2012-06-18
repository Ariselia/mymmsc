/**
 * 
 */
package org.mymmsc.api.qrcode;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Hashtable;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

/**
 * 功能杂项
 * 
 * @author wangfeng
 * @version 3.0.1 2012/06/07
 */
public class CodeApi {
	private static int times = 4;
	/** 二维码图片格式 */
	public static String pictype = "jpg";
	
	/**
	 * 生成二维码图片
	 * 
	 * @param path
	 * @param codeId
	 */
	public static boolean createQRCode(String filename, String content) {
		boolean bRet = false;
		Hashtable<EncodeHintType, Object> param = new Hashtable<EncodeHintType, Object>(
				2);
		param.put(EncodeHintType.CHARACTER_SET, "utf-8");
		param.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
		BitMatrix byteMatrix = null;
		try {
			byteMatrix = ZXingHelpers.encodeMultiple(content,
					BarcodeFormat.QR_CODE, times, param);
			// 在图片下面加上ID,字体部分的高度为宽度的12%
			int stringHeight = (int) (byteMatrix.getHeight() * 0.12);
			// 保留功能, 文字高度置为0
			stringHeight = 0;
			BufferedImage image = new BufferedImage(byteMatrix.getWidth(),
					byteMatrix.getHeight() + stringHeight,
					BufferedImage.TYPE_INT_RGB);
			Graphics2D g2 = (Graphics2D) image.getGraphics();
			Color paintColor = new Color(60, 95, 60);// 图片的颜色，Color.decode("#D10786")
			// 画二维码
			for (int x = 0; x < byteMatrix.getWidth(); x++) {
				for (int y = 0; y < byteMatrix.getHeight(); y++) {
					image.setRGB(x, y, byteMatrix.get(x, y) ? paintColor.getRGB()
							: 0xFFFFFFFF);
				}
			}
			// 画文字白底
			for (int x = 0; x < byteMatrix.getWidth(); x++) {
				for (int y = byteMatrix.getHeight(); y < byteMatrix.getHeight()
						+ stringHeight; y++) {
					image.setRGB(x, y, 0xFFFFFFFF);
				}
			}

			g2.setPaint(paintColor);
			Font font = new Font("TimesRoman", Font.PLAIN, times * 4);
			g2.setFont(font);
			ImageIO.write(image, pictype, new File(filename));
			bRet = true;
		} catch (WriterException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return bRet;
	}
}
