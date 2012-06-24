/**
 * 
 */
package com.fengxiafei.apps.util;

import java.sql.Connection;

import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.util.bean.CodeCount;
import com.fengxiafei.apps.util.bean.CodeCountResp;
import com.fengxiafei.core.Category;

/**
 * 个人中心 - 码的统计
 * 
 * @author wangfeng
 * @version 3.0.2 2012/06/19
 */
public class GetCodeCountAction extends AppAction {
	/** 用户ID */
	private int userId = -1;

	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		int baseError = 190;
		CodeCountResp result = new CodeCountResp();
		if (userId < 1) {
			result.set(baseError + 1, "用户id不能为空");
		} else {
			Connection conn = SQLApi.getConnection(Consts.DataSource);
			if (conn == null) {
				result.set(Category.API_iSQL_BAD_CONNECTION, Category.API_sSQL_BAD_CONNECTION);
			} else {
				CodeCount cc = new CodeCount();
				try {
					// 计算码的数量
					String sql = "SELECT count(*) FROM `media_core` WHERE `userId`=?";
					int numCode = SQLApi.getRow(conn, Integer.class, sql, userId);
					sql = "SELECT sum(`scancount`) FROM `media_statis` WHERE `userId`=?";
					int numScan = SQLApi.getRow(conn, Integer.class, sql, userId);
					cc.setNumCode(numCode);
					cc.setNumScan(numScan);
					result.setData(cc);
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
				} catch (Exception e) {
					error("", e);
					result.set(Category.API_iSQL_FAILED, Category.API_sSQL_FAILED);
				} finally {
					SQLApi.closeQuietly(conn);
				}
			}
			
		}
		return JsonAdapter.get(result, true);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		//
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
