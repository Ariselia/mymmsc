/**
 * 
 */
package com.fengxiafei.apps.code;

import java.io.IOException;
import java.util.List;

import org.mymmsc.api.assembly.Api;
import org.mymmsc.api.context.JsonAdapter;

import com.fengxiafei.apps.Adapter;
import com.fengxiafei.apps.AppAction;
import com.fengxiafei.apps.Consts;
import com.fengxiafei.apps.code.bean.CodeBean;
import com.fengxiafei.apps.code.bean.CodeResp;
import com.fengxiafei.apps.code.util.CodeApi;
import com.fengxiafei.core.Category;
import com.fengxiafei.core.qrcode.bean.MediaPage;
import com.fengxiafei.core.qrcode.bean.RichMedia;

/**
 * 富媒体,空码生码
 * 
 * @author wangfeng
 * @version 3.0.1 12/05/27
 * @remark 错误码范围210~229
 */
public class MakeCode extends AppAction {
	private String title;
	private String content = null; // 码内容
	private byte type = 0; // 业务类型
	private String codeId = null; // 码ID, 或者是码前缀
	private String userId = null; // 用户ID
	private int number = -1;

	@Override
	public String doService() {
		String sRet = null;
		addHeader("Content-Type", "application/json; charset=utf-8");
		// 加载配置文件
		Adapter adapter = Adapter.newInstance();
		adapter.loadConfig(webPath + "WEB-INF/" + Consts.APPS);
		// 检查类型
		String fileName = null;
		int rmbError = 210;
		CodeBean cb = new CodeBean();
		int isKma = (type >> 4);
		int codeType = type & 0X0F;
		if (codeType == 0 || codeType == 0X0F) {
			if (isKma == 1) {
				cb.setStatus(rmbError + 1);
				cb.setMessage("空码赋值类型不能为0, 取值范围0X11-0X1E");
			} else {
				cb.setStatus(rmbError + 2);
				cb.setMessage("业务类型类型不能为0, 取值范围0X01-0X0E");
			}
		} else {
			boolean bCompany = false;
			if (isKma >= 1) {
				if (Api.isNull(codeId)) {
					cb.setStatus(rmbError + 0);
					cb.setMessage("空码赋值, codeId不能为空, 且长度大于等于8");
					number = 0;
				} else {
					codeId = codeId.trim();
					if (codeId.length() < 8) {
						// 批量生码, 获得最大的码Id
						if (number < 1) {
							number = 1;
						}
						bCompany = true;
					} else {
						// 个人空码赋值
						number = 1;
						if (Api.isNull(userId)) {
							number = 0;
							cb.setStatus(rmbError + 1);
							cb.setMessage("空码赋值, 用户ID为空");
						}
					}
				}
			} else if (codeType == 0X0E) {
				number = 1;
				codeId = adapter.genKey(content);
			} else {
				number = 0;
			}
			if (number > 0) {
				if (bCompany) {
					// 不检查空码内容
					cb.setStatus(Category.API_iSUCCESS);
					cb.setMessage(Category.API_sSUCCESS);
				} else if (Api.isEmpty(content)) {
					cb.setStatus(rmbError + 3);
					cb.setMessage("富媒体解码失败");
				} else if (codeType == 0X0E) {
					// 富媒体, 测试是否能解码成功, 如果解码失败, 不保存
					JsonAdapter json = null;
					RichMedia rmb = null;
					try {
						json = JsonAdapter.parse(content);
						rmb = json.get(RichMedia.class);
					} catch (Exception e) {
						error("解码失败", e);
					}
					if (rmb == null) {
						// 解码失败
						cb.setStatus(rmbError + 3);
						cb.setMessage("富媒体解码失败");
					} else {
						// 检查媒体内容
						if (bCompany && Api.isNull(rmb.getTitle())) {
							cb.setStatus(rmbError + 4);
							cb.setMessage("标题不能为空");
						} else if (Api.isNull(rmb.getContent())) {
							cb.setStatus(rmbError + 5);
							cb.setMessage("媒体页没有文本内容");
						} else if (rmb.getPageList().size() < 1) {
							cb.setStatus(rmbError + 6);
							cb.setMessage("媒体页没有内容");
						} else if (!adapter.checkResouce(rmb.getAudio())) {
							cb.setStatus(rmbError + 7);
							cb.setMessage("背景音乐资源不存在");
						} else {
							// 先预置返回为正确
							cb.setStatus(Category.API_iSUCCESS);
							cb.setMessage(Category.API_sSUCCESS);
							rmb.setCodeId(codeId);
							// 检查媒体页
							List<MediaPage> list = rmb.getPageList();
							int count = 0;
							if (list != null) {
								count = list.size();
							}
							int pageError = 220;
							// 富媒体的bean是否被改变, 默认没改变
							boolean bChange = false;
							for (int i = 0; i < count; i++) {
								MediaPage media = list.get(i);
								if (media != null) {
									// 检查媒体内容
									if (Api.isNull(media.getTitle())) {
										cb.setStatus(pageError + 1);
										cb.setMessage("标题不能为空");
										break;
									} else if (Api.isNull(media.getContent())) {
										cb.setStatus(pageError + 2);
										cb.setMessage("媒体页没有内容");
										break;
									} else if (!adapter.checkResouce(media
											.getAudio())) {
										cb.setStatus(pageError + 3);
										cb.setMessage(media.getAudio()
												+ ", 背景音乐资源不存在");
										break;
									} else if (!adapter.checkResouce(media
											.getImage())) {
										cb.setStatus(pageError + 4);
										cb.setMessage(media.getImage()
												+ ", 图片资源不存在");
										break;
									} else if (!adapter.checkResouce(media
											.getVideo())) {
										cb.setStatus(pageError + 5);
										cb.setMessage(media.getVideo()
												+ ", 视频资源不存在");
										break;
									} else if (!Api.isEmpty(media
											.getVideo()) && adapter.checkResouce(media
											.getVideo())) {
										// 如果有视频, 检测图片文件
										String video = media.getVideo().trim();
										String image = video.substring(0, video.length() - 3) + "jpg";
										if (adapter.checkResouce(image)) {
											media.setImage(image);
											bChange = true;
										} else {
											error("视频文件, 没有缩略图: " + video);
										}
										break;
									}
								}
							}
							// 媒体页检查完毕
							if(bChange) {
								content = JsonAdapter.get(rmb, true);
							}
						}
					}
					if (json != null) {
						try {
							json.close();
						} catch (Exception e) {
							error("", e);
						}
					}
					// 富媒体检查完毕
				} else {
					// 其它类型为普通业务, 不对内容进行校验
					cb.setStatus(Category.API_iSUCCESS);
					cb.setMessage(Category.API_sSUCCESS);
					content = "\"" + content + "\"";
				}
				if (cb.getStatus() == Category.API_iSUCCESS) {
					// 如果检查正确, 则写入json文件
					String json = String
							.format("{\"status\":0,\"message\":\"success\",\"data\":%s}",
									content);
					try {
						String zipUrl = null;
						if (bCompany) {
							// 批量生码, 获得最大的码Id
							int prefix = Api.valueOf(int.class, codeId);
							int ct = codeType;
							if (Api.isEmpty(content)) {
								ct = 0;
							}
							int startId = CodeApi.getLastId(title, ct, prefix, number);
							if (startId >= 0) {
								if (!Api.isEmpty(content)) {
									for (int i = 0; i < number; i++) {
										codeId = String.format("%02d%06d", prefix, startId + i);
										String filePath = Adapter.genPath(codeId);
										fileName = filePath + codeId + ".json";
										Adapter.toFile(adapter.getUploadPath() + "/json/"
												+ fileName, json.getBytes());
									}
								}
								zipUrl = CodeApi.batchCode(adapter.codePath(), prefix * 1000000 + startId, number);
								if (number == 1) {
									int base = (prefix * 1000000 + startId) /100;
									String subPath = String.format("%06d", base);
									zipUrl = String.format("%s/%02d%06d.%s", subPath, prefix, startId + 0, CodeApi.pictype);
								}
								codeId = String.format("%02d%06d", prefix, startId + 0);
							} else {
								// 其它类型为普通业务, 不对内容进行校验
								cb.setStatus(rmbError + 3);
								cb.setMessage("没有找到匹配的商户生码信息");
								codeId = null;
							}
						} else {
							String filePath = Adapter.genPath(codeId);
							fileName = filePath + codeId + ".json";
							Adapter.toFile(adapter.getUploadPath() + "/json/"
									+ fileName, json.getBytes());
							CodeApi.kmaAssign(userId, codeId, title, codeType);
						}
						if (codeId != null) {
							CodeResp cr = new CodeResp();
							cr.setCodeId(codeId);
							cr.setType(type);
							cr.setNumber(number);
							//cr.setUrl(adapter.getDownloadUrl() + "/apps/getCode.action?id=" + codeId);
							cr.setUrl(Category.CODE_PREFIX + "?id=" + codeId);
							if (zipUrl != null) {
								cr.setZipUrl(adapter.getDownloadUrl() + '/' + Category.QRCodePath+ "/" + zipUrl);
							}							
							cb.setData(cr);
						}						
					} catch (IOException e) {
						error("写文件[" + fileName + "]失败", e);
						cb.setStatus(901);
						cb.setMessage("创建文件失败");
					}
				}
			}
		}
		sRet = JsonAdapter.get(cb, true);
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
	 * @return the content
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content
	 *            the content to set
	 */
	public void setContent(String content) {
		this.content = content;
	}

	public byte getType() {
		return type;
	}

	public void setType(byte type) {
		this.type = type;
	}

	/**
	 * @return the codeId
	 */
	public String getCodeId() {
		return codeId;
	}

	/**
	 * @param codeId
	 *            the codeId to set
	 */
	public void setCodeId(String codeId) {
		this.codeId = codeId;
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
	 * @return the number
	 */
	public int getNumber() {
		return number;
	}

	/**
	 * @param number the number to set
	 */
	public void setNumber(int number) {
		this.number = number;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

}
