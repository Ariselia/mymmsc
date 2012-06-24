/**
 * 
 */
package com.fengxiafei.apps.code;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.code.bean.MediaInfo;
import com.fengxiafei.apps.util.bean.ScanCode;

/**
 * 获得码信息
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 */
public class CodeInfo extends AppAction {
	private String id;
	private int userId = 0;

	@Override
	public String doService() {
		String sRet = null;
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);

		String codeId = id;
		String sql = "SELECT * FROM `media_core` WHERE `uuid`=?";
		MediaInfo media = SQLApi.getOneRow(Consts.DataSource, MediaInfo.class,
				sql, codeId);
		if (media == null) {
			// 没有码的记录
			sRet = "{\"status\":904,\"message\":\"Data Error\",\"data\":{}}";
		} else {
			// 码存在, 进一步判断码的json文件
			String filePath = Adapter.genPath(codeId);
			String fileName = filePath + codeId + ".json";
			fileName = adapter.getUploadPath() + "/json/" + fileName;
			if (Api.isFile(fileName)) {
				try {
					StringBuffer sb = new StringBuffer();
					FileInputStream fis = new FileInputStream(fileName);
					BufferedReader buff = new BufferedReader(
							new InputStreamReader(fis));
					String temp = null;
					while ((temp = buff.readLine()) != null) {
						sb.append(temp.trim());
					}
					sRet = sb.toString();
					sql = "SELECT * FROM `media_statis` WHERE `codeid`=?";
					ScanCode sc = SQLApi.getOneRow(Consts.DataSource,
							ScanCode.class, sql, codeId);
					if (sc == null) {
						// 扫码记录不存在, 增加
						sql = "INSERT INTO `media_statis` (`codeId`,`userId`,`scantime`,`scancount`) VALUES (?,?,current_date(), 1)";
						SQLApi.insert(Consts.DataSource, sql, codeId, userId);
					} else if (userId <= 0 || userId != sc.getUserId()) {
						// 不能自己给你刷扫码数
						sql = "UPDATE `media_statis` SET `scancount`=`scancount`+1 WHERE `codeid`=? AND `userid`=?";
						SQLApi.execute(Consts.DataSource, sql, codeId,
								sc.getUserId());
					}
				} catch (FileNotFoundException e) {
					sRet = "{\"status\":404,\"message\":\"Not Found\",\"data\":{}}";
				} catch (IOException e) {
					sRet = "{\"status\":904,\"message\":\"Data Error\",\"data\":{}}";
				}
			} else {
				sRet = "{\"status\":404,\"message\":\"Not Found\",\"data\":{}}";
			}
		}
		System.out.println("response = [" + sRet + "], "
				+ sRet.getBytes().length);
		info(sRet);
		return sRet;
	}

	@Override
	public void close() {
		//
	}

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the userId
	 */
	public int getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(int userId) {
		this.userId = userId;
	}
}
