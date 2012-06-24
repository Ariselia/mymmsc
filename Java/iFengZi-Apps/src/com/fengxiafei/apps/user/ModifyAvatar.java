/**
 * 
 */
package com.fengxiafei.apps.user;

import java.io.IOException;

import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.j2ee.http.HttpFile;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.code.bean.FileType;
import com.fengxiafei.core.ActionStatus;
import com.fengxiafei.core.Category;

/**
 * 用户中心 - 修改头像
 * 
 * @author wangfeng
 * @version 3.0.1 2012/05/27
 * @remark 登录错误码18X
 * 
 */
public class ModifyAvatar extends AppAction {
	private int userId = -1;
	private HttpFile content;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.mymmsc.j2ee.struts.HttpAction#execute()
	 */
	@Override
	public String doService() {
		// 设定HTTP-Header域
		addHeader("Content-Type", "application/json; charset=utf-8");
		addHeader("FengZi-Version", Consts.VERSION);
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 设定错误码基数
		int baseError = 180;
		ActionStatus result = new ActionStatus();
		if (userId < 0) {
			result.set(baseError + 1, "用户ID不能为空");
		} else if (content == null) {
			result.set(404, "没有上传文件");
		} else {
			FileType fileType = adapter.getFileType(content.getFileType());
			// 检查文件类型
			if (fileType == null || fileType.getType() == 0) {
				result.set(baseError + 2, "未知文件类型");
			} else if (fileType.getType() != Category.MEDIA_FILE_IMAGE) {
				result.set(baseError + 3, "头像必须是图片");
			} else if (content.getFileData().length < 1) {
				// 检查文件长度
				result.set(baseError + 4, "文件长度为0");
			} else {
				info("userid = " + userId);
				String key = String.format("%010d", userId);
				String filePath = Adapter.genPath(key);
				String fileName = filePath + key + ".jpg";
				try {
					Adapter.toFile(adapter.usersPath() + fileName, content.getFileData());
					result.set(Category.API_iSUCCESS, Category.API_sSUCCESS);
				} catch (IOException e) {
					error("写文件[" +fileName+ "]失败", e);
					result.set(901,"创建文件失败");
				}
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
		// TODO Auto-generated method stub

	}

	/**
	 * @return the content
	 */
	public HttpFile getContent() {
		return content;
	}

	/**
	 * @param content
	 *            the content to set
	 */
	public void setContent(HttpFile content) {
		this.content = content;
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
