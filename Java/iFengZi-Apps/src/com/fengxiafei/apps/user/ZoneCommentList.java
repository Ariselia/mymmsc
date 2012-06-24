/**
 * 
 */
package com.fengxiafei.apps.user;

import java.util.List;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.ZoneComment;
import com.fengxiafei.apps.user.bean.ZoneCommentResp;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 空间评论列表
 * 
 * @author wangfeng
 *
 */
public class ZoneCommentList extends AppAction {
	private String userId = null;
	private int pageNum = 1;
	private int pageSize = 8;
	private int firstId = -1;
	
	/* (non-Javadoc)
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		int baseError = 140;
		ZoneCommentResp result = new ZoneCommentResp();
		if (Api.isEmpty(userId)) {
			result.set(baseError + 1, "用户ID不能为空");
		} else {
			String sql = "SELECT * FROM `users_comment`";
			if (firstId > 0 && pageNum <= 0) {
				sql += " WHERE `id` > ? AND `userId`=? ORDER BY `ID` ASC";
			} else if (firstId > 0) {
				sql += " WHERE `id` <=? AND `userId`=? ORDER BY `ID` DESC";
			} else {
				sql += " WHERE `userId`=? ORDER BY `ID` DESC";
			}
			if (pageNum < 1) {
				pageNum = 1;
			}
			if (pageSize < 1) {
				pageSize = 8;
			}
			int pos = (pageNum - 1) * pageSize;
			sql = String.format("%s LIMIT %d,%d", sql, pos, pageSize);
			List<ZoneComment> list = null;
			if (firstId > 0) {
				list = SQLApi.getRows(Consts.DataSource, ZoneComment.class, sql, firstId, userId);
			} else {
				list = SQLApi.getRows(Consts.DataSource, ZoneComment.class, sql, userId);
			}
			if (list == null) {
				result.set(baseError + 2, "没有找到码记录");
			} else {
				if (pageNum == 1 && list.size() > 0) {
					result.setFirstId(list.get(0).getId());
				}
				result.setData(list);
				result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
			}
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
	}

	/* (non-Javadoc)
	 * @see org.mymmsc.api.adapter.AutoObject#close()
	 */
	@Override
	public void close() {
		// 
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the pageNum
	 */
	public int getPageNum() {
		return pageNum;
	}

	/**
	 * @param pageNum the pageNum to set
	 */
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * @param pageSize the pageSize to set
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * @return the firstId
	 */
	public int getFirstId() {
		return firstId;
	}

	/**
	 * @param firstId the firstId to set
	 */
	public void setFirstId(int firstId) {
		this.firstId = firstId;
	}
}
