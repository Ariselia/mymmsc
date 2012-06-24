/**
 * 
 */
package com.fengxiafei.apps.user;

import java.util.ArrayList;
import java.util.List;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.user.bean.CodeInfo;
import com.fengxiafei.apps.user.bean.CodeInfo2;
import com.fengxiafei.apps.user.bean.CodeListResp;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 我的码列表
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码14X
 * 
 */
public class CodeList extends AppAction {
	private String userId = null;
	private int pageNum = 1;
	private int pageSize = 8;
	private int firstId = -1;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		int baseError = 140;
		CodeListResp result = new CodeListResp();
		if (Api.isEmpty(userId)) {
			result.set(baseError + 1, "用户ID不能为空");
		} else {
			String sql = "SELECT * FROM `media_core`";
			if (firstId > 0 && pageNum <= 0) {
				sql += " WHERE `id` >? AND `uuId`=? ORDER BY `ID` ASC";
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
			List<CodeInfo2> row2 = null;
			if (firstId > 0) {
				row2 = SQLApi.getRows(Consts.DataSource, CodeInfo2.class, sql,
						firstId, userId);
			} else {
				row2 = SQLApi
						.getRows(Consts.DataSource, CodeInfo2.class, sql, userId);
			}
			if (row2 == null) {
				result.set(baseError + 2, "没有找到码记录");
			} else {
				List<CodeInfo> list = new ArrayList<CodeInfo>();
				int count = row2.size();
				for (int i = 0; i < count; i++) {
					CodeInfo obj = new CodeInfo();
					CodeInfo2 row = row2.get(i);
					if (i == 0 && pageNum == 1) {
						result.setFirstId(row.getId());
					}
					obj.setType(row.getType());
					obj.setTitle(row.getTitle());
					obj.setCreateTime(row.getAddTime());
					obj.setUrl(Category.CODE_PREFIX + "?id=" + row.getUuid());
					list.add(obj);
				}
				result.setData(list);
				result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
			}
		}
		String resp = JsonAdapter.get(result, true);
		return resp;
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
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
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
	 * @param pageNum
	 *            the pageNum to set
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
	 * @param pageSize
	 *            the pageSize to set
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
	 * @param firstId
	 *            the firstId to set
	 */
	public void setFirstId(int firstId) {
		this.firstId = firstId;
	}

}
