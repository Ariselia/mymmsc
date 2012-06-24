/**
 * 
 */
package com.fengxiafei.apps.code.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.imageio.ImageIO;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.sql.DbUtils;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.code.bean.TraderInfo;
import com.fengxiafei.core.CodeAdapter;
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
	
	public static boolean kmaAssign(String userId, String codeId, String title, int type){
		boolean bRet = false;
		Connection conn = SQLApi.getConnection(Consts.DataSource);
		if (conn != null) {
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			int count = -1;
			try {
				int id = -1;
				conn.setAutoCommit(false);
				String sql = "SELECT id FROM `media_core` WHERE uuid=?";
				pstmt1 = conn.prepareStatement(sql);
				pstmt1.setString(1, codeId);
				ResultSet rs = pstmt1.executeQuery();
				if (rs.next()) {
					id = rs.getInt(1);
				}
				SQLApi.closeQuietly(rs);
				//SQLApi.getRow(conn, Integer.class, sql, "");
				// conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
				if (id < 1) {
					String sql2 = "INSERT INTO `media_core` (`flag`,`userid`,`traderid`,`uuid`,`type`,`title`,`addtime`) values('1', ?, ?, ?, ?, ?, now())";
					pstmt2 = conn.prepareStatement(sql2);
					pstmt2.setString(1, userId);
					pstmt2.setString(2, "");
					pstmt2.setString(3, codeId);
					pstmt2.setInt(4, type);
					pstmt2.setString(5, title);
					count = pstmt2.executeUpdate();
				} else {
					String sql2 = "update `media_core` set `type`=?,`userid`=?,`title`=?,`modtime`=now() WHERE id=?";
					pstmt2 = conn.prepareStatement(sql2);
					pstmt2.setInt(1, type);
					pstmt2.setString(2, userId);
					pstmt2.setString(3, title);
					pstmt2.setInt(4, id);
					count = pstmt2.executeUpdate();
				}
				conn.commit();
				bRet = true;
			} catch (SQLException e) {
				e.printStackTrace();
				try {
					SQLApi.rollback(conn);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			} finally {
				if (count < 1) {
					try {
						SQLApi.rollback(conn);
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
					bRet = false;
				}
				SQLApi.closeQuietly(pstmt1);
				SQLApi.closeQuietly(pstmt2);
				SQLApi.closeQuietly(conn);
			}
		}
		return bRet;
	}
	
	/** 压缩一个文件 */
	private static void compressFile(File file, ZipOutputStream out,
			String basedir) {
		if (!file.exists()) {
			return;
		}
		try {
			BufferedInputStream bis = new BufferedInputStream(
					new FileInputStream(file));
			ZipEntry entry = new ZipEntry(basedir + file.getName());
			out.putNextEntry(entry);
			int count;
			byte data[] = new byte[1024 * 10];
			while ((count = bis.read(data, 0, 1024 * 10)) != -1) {
				out.write(data, 0, count);
			}
			bis.close();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 获得可以批量生产的码起始ID
	 * 
	 * @param traderId
	 * @param num
	 * @return
	 */
	public static int getLastId(String title, int type, int traderId,
			Integer num) {
		int iRet = -1;
		Connection conn = DbUtils.getConnection(Consts.DataSource);
		if (conn != null) {
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			ResultSet rs = null;
			int count = -1;
			try {
				conn.setAutoCommit(false);
				conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
				String sql = "SELECT * FROM `kma_code` WHERE `prefix`=? LIMIT 0,1";
				pstmt1 = conn.prepareStatement(sql);
				pstmt1.setInt(1, traderId);
				rs = pstmt1.executeQuery();
				TraderInfo ti = null;
				if (rs.next()) {
					ti = DbUtils.valueOf(rs, TraderInfo.class);
				}
				if (ti != null) {
					if (1000000 - ti.getLastId() < num) {
						num = 1000000 - ti.getLastId();
					}
					boolean ret = makeCode(ti.getUserId(), traderId, title,
							type, ti.getLastId(), num);
					if (ret) {
						sql = "UPDATE `kma_code` set `lastid`=? where id=?";
						pstmt2 = conn.prepareStatement(sql);
						pstmt2.setInt(1, ti.getLastId() + num);
						pstmt2.setInt(2, ti.getId());
						count = pstmt2.executeUpdate();
					} else {
						count = -1;
					}

				} else {
					num = 0;
				}
				conn.commit();
				iRet = ti.getLastId();
			} catch (SQLException e) {
				e.printStackTrace();
				try {
					DbUtils.rollback(conn);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			} finally {
				if (count < 1) {
					try {
						DbUtils.rollback(conn);
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
					iRet = -1;
				}
				DbUtils.closeQuietly(rs);
				DbUtils.closeQuietly(pstmt1);
				DbUtils.closeQuietly(pstmt2);
				DbUtils.closeQuietly(conn);
			}
		}
		return iRet;
	}

	/**
	 * 批量生码
	 * 
	 * @param userId
	 * @param traderId
	 * @param title
	 * @param type
	 * @param codeid
	 * @param num
	 * @return
	 */
	public static boolean makeCode(Integer userId, int traderId, String title,
			int type, int codeid, int num) {
		boolean bRet = false;
		Connection conn = DbUtils.getConnection(Consts.DataSource);
		if (conn != null) {
			PreparedStatement pstmt = null;
			int count = 1;
			try {
				conn.setAutoCommit(false);
				// conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
				if (count > 0) {
					String qserial_number = String.format("%d%06d", traderId, codeid
							+ 0);
					String uid = userId.toString();
					String tid = String.valueOf(traderId);
					String sql2 = "INSERT INTO `media_core` (`flag`,`userid`,`traderid`,`uuid`,`type`,`title`,`addtime`, `qserial_number`) values('1', ?, ?, ?, ?, ?, now(), ?)";
					for (int i = 0; i < num; i++) {
						String uuid = String.format("%02d%06d", traderId, codeid+ i);
						pstmt = conn.prepareStatement(sql2);
						pstmt.setString(1,uid);
						pstmt.setString(2, tid);
						pstmt.setString(3, uuid);
						pstmt.setInt(4, type);
						pstmt.setString(5, title);
						pstmt.setString(6, qserial_number);
						count = pstmt.executeUpdate();
						//kmaAssign(userId.toString(), uuid, title, type);
						// 码可能会重复, 忽略添加失败, 继续进行
						if (count < 1) {
							break;
						}
					}
				}
				conn.commit();
				bRet = true;
			} catch (SQLException e) {
				e.printStackTrace();
				try {
					DbUtils.rollback(conn);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			} finally {
				if (count < 1) {
					try {
						DbUtils.rollback(conn);
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
					bRet = false;
				}
				DbUtils.closeQuietly(pstmt);
				DbUtils.closeQuietly(conn);
			}
		}
		return bRet;
	}

	/**
	 * 生成二维码图片
	 * 
	 * @param path
	 * @param codeId
	 */
	public static String createQRCode(String filename, String codeId) {
		String sRet = String.format("%s.%s", codeId, pictype);
		String codeUrl = CodeAdapter.codeUrl(codeId);
		Hashtable<EncodeHintType, Object> param = new Hashtable<EncodeHintType, Object>(
				2);
		param.put(EncodeHintType.CHARACTER_SET, "utf-8");
		param.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
		BitMatrix byteMatrix = null;
		try {
			byteMatrix = QRCodeApi.encodeMultiple(codeUrl,
					BarcodeFormat.QR_CODE, times, param);
		} catch (WriterException e1) {
			e1.printStackTrace();
		}
		// 在图片下面加上ID,字体部分的高度为宽度的12%
		int stringHeight = (int) (byteMatrix.getHeight() * 0.12);
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

		// 画文字，怎么才能让文字东东居中呢？
		g2.drawString(codeId, (byteMatrix.getWidth() - times * 15) / 2,
				byteMatrix.getHeight() + stringHeight * 5 / 6);
		// 这里需要根据放大倍数计算
		// g2.DrawString (startId.toString(), font, new Brush(), Single,
		// Single, StringFormat)

		// 先将文件保存在一个临时文件夹中
		try {
			ImageIO.write(image, pictype, new File(filename));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sRet;
	}

	/**
	 * 批量生码
	 * 
	 * @param startId
	 *            第一个码,8位传
	 * @param num
	 *            码数量
	 */
	public static String batchCode(String filepath, int startId, int num) {
		String zipPath = String.format("%d/", startId);
		String sRet = String.format("%d.zip", startId);
		int base = startId / 100;
		String subPath = String.format("%06d", base);
		String codePath = filepath + '/' + subPath;
		Api.mkdirs(codePath);
		// 下面为图片打包（应该可以直接将生成的图片流输出到打包文件中，就不用再打包一次了
		String zippath = filepath + '/' + sRet;
		File zipFile = new File(zippath);// 生成压缩文件路径
		FileOutputStream fileOutputStream;
		try {
			fileOutputStream = new FileOutputStream(zipFile);
			CheckedOutputStream cos = new CheckedOutputStream(fileOutputStream,
					new CRC32());
			ZipOutputStream out = new ZipOutputStream(cos);
			for (int i = 0; i < num; i++) {
				String codeId = String.format("%08d", startId + i);
				String fileName = String.format("%s/%s.%s", codePath, codeId,
						pictype);
				createQRCode(fileName, codeId);
				compressFile(new File(fileName), out, zipPath);
			}
			out.close();// 关闭流
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return sRet;
	}

	/**
	 * 格式化商户id
	 * 
	 * @param traderId
	 * @return
	 */
	public static String getTraderId(String traderId) {
		String sRet = null;
		if (traderId != null) {
			int tid = Integer.parseInt(traderId);
			String exp = String.format("%%0%dd", Consts.TRADERID_MAX_LANGTH);
			sRet = String.format(exp, tid);
		}
		return sRet;
	}

	public static String getCoreLastId(String traderId) {
		String sRet = getTraderId(traderId);

		return sRet;
	}

	public static void main(String[] argv) {
		String tid = "70";
		System.out.println(CodeApi.getTraderId(tid));
		String a = CodeApi.getTraderId(tid);
		System.out.println(CodeApi.getTraderId(a));
	}
}
