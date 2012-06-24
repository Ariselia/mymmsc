/**
 * 
 */
package com.fengxiafei.apps.user;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.api.sql.SQLApi;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * @author wangfeng
 *
 */
public class NewZoneComment extends AppAction {
	private String userId;
	private int commentUserId;
	private String commentName;
	private String commentContent;

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
		int baseError = 150;
		ActionStatus result = new ActionStatus();
		if (Api.isEmpty(userId)) {
			result.set(baseError + 1, "用户ID不能为空");
		} else if (commentUserId < 0) {
			result.set(baseError + 2, "评论人ID不能为空");
		} else if (Api.isEmpty(commentContent)) {
			result.set(baseError + 2, "评论内容不能为空");
		} else {
			if (Api.isEmpty(commentName)) {
				commentName = "匿名";
			}
			String sql = "INSERT INTO `users_comment` (`userId`,`commentUserId`,`commentName`,`commentContent`,`commentDate`) VALUES";
			sql += "(?, ?, ?, ?, now())";
			int num = SQLApi.insert(Consts.DataSource, sql, userId, commentUserId,
					commentName, commentContent);
			if (num < 1) {
				result.set(901, "添加评论记录失败");
			} else {
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
	 * @return the commentUserId
	 */
	public int getCommentUserId() {
		return commentUserId;
	}

	/**
	 * @param commentUserId
	 *            the commentUserId to set
	 */
	public void setCommentUserId(int commentUserId) {
		this.commentUserId = commentUserId;
	}

	/**
	 * @return the commentName
	 */
	public String getCommentName() {
		return commentName;
	}

	/**
	 * @param commentName
	 *            the commentName to set
	 */
	public void setCommentName(String commentName) {
		this.commentName = commentName;
	}

	/**
	 * @return the commentContent
	 */
	public String getCommentContent() {
		return commentContent;
	}

	/**
	 * @param commentContent
	 *            the commentContent to set
	 */
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
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
}
