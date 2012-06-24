/**
 * 
 */
package com.fengxiafei.apps.code;

import java.io.IOException;

import org.mymmsc.api.assembly.ImageUtils;
import org.mymmsc.api.context.JsonAdapter;
import org.mymmsc.j2ee.http.HttpFile;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.code.bean.FileBean;
import com.fengxiafei.apps.code.bean.FileResp;
import com.fengxiafei.apps.code.bean.FileType;
import com.fengxiafei.core.Category;

/**
 * 文件上传
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 * @remark 错误码范围 20X
 */
public class FileUpload extends AppAction {
	private HttpFile content;

	@Override
	public String doService() {
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 检查表单字段
		// 设定响应内容
		FileBean ub = new FileBean();
		FileResp ur = null;
		// 上传文件, 其它字段都不重要, 只关注content字段
		if (content == null) {
			ub.setStatus(404);
			ub.setMessage("没有上传文件");
		} else {
			FileType fileType = adapter.getFileType(content.getFileType());
			// 检查文件类型
			if (fileType == null || fileType.getType() == 0) {
				ub.setStatus(201);
				ub.setMessage("未知文件类型");
			} else if (content.getFileData().length < 1) {
				// 检查文件长度
				ub.setStatus(202);
				ub.setMessage("文件长度为0");
			} else {
				// 检查文件类型, 这里暂时不用处理
				// 保存文件
				String key = adapter.genKey(content.getFileData());
				info("key = " + key);
				String filePath = Adapter.genPath(key);
				String fileName = filePath + key + '.' + fileType.getExt();
				try {
					Adapter.toFile(adapter.filePath() + fileName, content.getFileData());
					if (fileType.getType() == Category.MEDIA_FILE_VIDEO) {
						// 需要实现截图
						String command = "ffmpeg -i " + adapter.filePath() + fileName
								+ " -f image2 -ss 0 -vframes 1 " + adapter.filePath() + filePath + key + ".jpg";
						info("执行命令##" + command);
						try {
							Process proc = Runtime.getRuntime().exec(command);
							proc.waitFor();// 等待上面的命令执行完毕

						} catch (Exception e) {
							error(e.getMessage(), e);
							error("执行截图命令异常");
						}
					} else if (fileType.getType() == Category.MEDIA_FILE_IMAGE) {
						String picPath = adapter.filePath() + filePath;
						String picName = key + '.' + fileType.getExt();
						String xPic = key + "_1." + fileType.getExt();
						String zPic = key + "_2." + fileType.getExt();
						ImageUtils.compressPic(picPath, picPath, picName, xPic, 100, 100, true);
						ImageUtils.compressPic(picPath, picPath, picName, zPic, 240, 240, true);
					}
					ur = new FileResp();
					ur.setType(fileType.getType());
					ur.setFileType(fileType.getExt());
					ur.setFileUrl(adapter.getDownloadUrl() + "/apps/show.cgi?id=" + key + "&type=" + fileType.getExt());
					//ur.setFileUrl(adapter.getDownloadUrl() + "/file/" + fileName);
					ub.setStatus(0);
					ub.setMessage("success");
				} catch (IOException e) {
					error("写文件[" +fileName+ "]失败", e);
					ub.set(901, "创建文件失败");
				}
			}
		}
		
		ub.setData(ur);

		String resp = JsonAdapter.get(ub, true);
		System.out.println("response = [" + resp + "], " + resp.getBytes().length);
		info(resp);
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

}
