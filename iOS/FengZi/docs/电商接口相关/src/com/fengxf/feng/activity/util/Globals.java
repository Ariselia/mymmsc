package com.fengxf.feng.activity.util;

public class Globals {
	
	//是否带有logo
	public static boolean isLogo =false;
	//业务类型
	public static int TYPE=0;
	//业务对象
	public static Object qrObj;
	//富媒体mediakey，用于保存时
	public static Object qrMediaKey;
	/**系统常量**/
	public static String  CUR_NETWORK="WIFI";
	public static String  CUR_NETWORK_WIFI="WIFI";
	public static String  CUR_NETWORK_3G="3G";
	public static String  CUR_NETWORK_NONE=""; 
	public static String TOKEN = "uLN9UhI9Uhd-UhGGuh78uQ";
	public static final int QROBJTYPE_HTTP=1;//网址
	public static final int QROBJTYPE_WEBCARD=2;// 网页书签
	public static final int QROBJTYPE_APK=3;//  应用程序
	public static final int QROBJTYPE_WEIBO=4;//微博
	public static final int QROBJTYPE_CARD=5;//名片
	public static final int QROBJTYPE_TEL=6;//电话号
	public static final int QROBJTYPE_EMAIL=7;//邮件
	public static final int QROBJTYPE_TXE=8;//文本
	public static final int QROBJTYPE_UNTXT=9;//加密文本
	public static final int QROBJTYPE_SM=10;//短信
	public static final int QROBJTYPE_WIFI=11;//wifi
	public static final int QROBJTYPE_MAP=12;//地图
	public static final int QROBJTYPE_DATE=13;// 日程
	public static final int QROBJTYPE_DYNAMIC=14;// 富媒体和空码赋值
	
	public static Class sendBackClass;// 日程

	public static final String PHONEBOOKNUMBER = "";
	public static final String MAPURL="http://ditu.google.cn/maps?ll=";//27.939592,107.11118699999997&z=12";
	public static final String SFBL="&z=12";

	public static final String DOMAIN="http://220.231.48.34:7000/"; 
	public static final String DOMAIN_WEBNAMW="eshop"; 
	public static final String DYNAMIC="http://192.168.1.60:8080/"+"mb/dynamic";//富媒体
	public static final String KMA="http://192.168.1.60:8080/"+"mb/kma";//空码

	//creat for sunchao
	
	public static final String DYNAMIC_TEXT_UPLOAD=DOMAIN+"/mb/kma/m_uploadTraditionInfo.action";//13种文本业务上传地址
	public static final String DYNAMIC_SOUND_UPLOAD=DOMAIN+"mb/dynamic/m_soundUpload.action";//音频上传
	public static final String DYNAMIC_VIDEO_UPLOAD=DOMAIN+"mb/dynamic/m_videoUpload.action";//视频上传
	public static final String DYNAMIC_PIC_UPLOAD=DOMAIN+"mb/dynamic/m_picUpload.action";//图片上传
	public static final String DYNAMIC_FLASH_UPLOAD=DOMAIN+"mb/dynamic/m_flashUpload.action";//FLASH上传
	public static final String DYNAMIC_UPLOAD=DOMAIN+"mb/dynamic/m_uploadMediaInfo.action";//富媒体上传
	public static final String DYNAMIC_UPLOADINFO=DOMAIN+"mb/dynamic/m_uploadCodeIinfo.action";//富媒体信息上传
	public static final String DYNAMIC_SOUND_ENDWITH=".midi<>.amr<>.mp3<>.wav";//富媒体音频支持格式 <>作为格式分隔符
	public static final String DYNAMIC_PIC_ENDWITH=".jpg<>.gif<>.png";//富媒体音频支持格式<>作为格式分隔符
	public static final String DYNAMIC_VIDEO_ENDWITH=".gif<>.mms<>.cmx<>.Sis<>.3gp<>.mp4";//富媒体音频支持格式<>作为格式分隔符
	public static final String DYNAMIC_FLASH_ENDWITH=".swf<>.flv";//富媒体音频支持格式<>作为格式分隔符
	public static String UPLOAD_TOKEN="uLN9UhI9Uhd-UhGGuh78uQ";
	
	
	
	/****登录和个人中心接口地址****/
	public static final String FENG_LOGIN = "http://192.168.1.60:8080/uc/m_login.action";//登录
	public static final String FENG_FORGET_PWD = "http://192.168.1.60:8080/uc/m_resetpass.action"; //重置密码
	public static final String FENG_GET_CHECKBOX = "http://192.168.1.60:8080/uc/m_genCheckCode.action";//手机下发验证码
	public static final String FENG_REGISTER = "http://192.168.1.60:8080/uc/m_register.action";//注册
	public static final String MODIFY_PWD_URL="http://192.168.1.60:8080/uc/m_modpass.action";//修改密码
	public static final String MODIFY_NICKNAME_URL = "http://192.168.1.60:8080/uc/m_modnicname.action";//修改昵称
	public static final String FENG_MYCODE_URL = "http://192.168.1.60:8080/mb/kma/m_getCodeList.action";//我的码列表
	public static final String FENG_FEEDBACK_URL = "http://192.168.1.60:8080/mb/fb/fb.action";//意见反馈接口
	/****正则表达式****/
	public static final String PHONE_REGEX = "^((\\+86)|(86))?(13[0-9]|15[0-9]|18[8|9]) \\d{8}$";//手机号码正则表达式
	public static final String EMAIL_REGEX = "^ \\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$";//邮件正则表达式
	/**用户信息**/
	public static int USERID = 0;
	public static String USERNAME = "";
	public static String USERPWD = "";
	public static String USERNICK = "";
	
	public static  final String Tag="Feng";
	public static final String FENG_ESHOP_MAIN =DOMAIN+DOMAIN_WEBNAMW+"/main.action"; 
	public static final String FENG_ESHOP_DOWNLOAD = DOMAIN+DOMAIN_WEBNAMW+"book.txt";
	public static final String FENG_ESHOP_BRAND = DOMAIN+DOMAIN_WEBNAMW+"/person.action"; 
	public static final String FENG_ESHOP_COMMENT = DOMAIN+DOMAIN_WEBNAMW+"/commnetlist.action"; 
	public static final String FENG_ESHOP_COMMENT_SUBMIT = DOMAIN+DOMAIN_WEBNAMW+"/commnet.action"; 
	
	public static final String FENG_ESHOP_INFO = DOMAIN+DOMAIN_WEBNAMW+"/info.action"; 
	public static final String FENG_ESHOP_ORDER = DOMAIN+DOMAIN_WEBNAMW+"/order.action"; 
	public static final String FENG_ESHOP_PUBLISH = DOMAIN+DOMAIN_WEBNAMW+"/publish.action"; 
	public static final String FENG_ESHOP_ORDERLIST = DOMAIN+DOMAIN_WEBNAMW+"/orderlist.action"; 
	
	//空码
	public static int ISKMA = 0;
	public static int KMAID = 0;
	
	/*电商URL*/
	public static final String Host="192.168.2.115:8080";
	/*商品搜索*/ 
	public static final String EBUY_SEARCH="http://"+Host+"/ebuy/search";
	/*商品推荐*/
	public static final String EBUY_PUSH="http://"+Host+"/ebuy/push";
	/*分类*/
	public static final String EBUY_TYPE="http://"+Host+"/ebuy/type";
	/*分类*/
	public static final String EBUY_GOODSLIST="http://"+Host+"/ebuy/goodslist";
	/*快报资讯推荐*/
	public static final String EBUY_NEW="http://"+Host+"/ebuy/new";
	/*快报资讯详情*/
	public static final String EBUY_MESSAGENEWINFO="http://"+Host+"/ebuy/messagenewinfo";
	/*站内信列表-收件箱*/
	public static final String EBUY_MESSAGE_RECV="http://"+Host+"/ebuy/messagerecv";
	/*站内信列表-发件箱*/
	public static final String EBUY_MESSAGE_SEND="http://"+Host+"/ebuy/messagesend";
	/*站内信信息详情*/
	public static final String EBUY_MESSAGEINFO="http://"+Host+"/ebuy/messageinfo";
	/*站内回复*/
	public static final String EBUY_ADDMESSAGE="http://"+Host+"/ebuy/addmessage";
	/*订单获取列表*/
	public static final String EBUY_ORDERLIST="http://"+Host+"/ebuy/orderlist";
	/*我的收藏列表*/
	public static final String EBUY_COLLECT="http://"+Host+"/ebuy/collect";
	/*添加一个收藏*/
	public static final String EBUY_ADDCOLLECT="http://"+Host+"/ebuy/addcollect";
	/*删除一个收藏*/
	public static final String EBUY_DELCOLLECT="http://"+Host+"/ebuy/delcollect";
	/*心得和评价列表*/
	public static final String EBUY_ADDCOMMENT="http://"+Host+"/ebuy/addcomment";
	/*发表评论*/
	public static final String EBUY_SDANDCOMMENTLIST="http://"+Host+"/ebuy/sdandcomentlist";

	/*商品详情*/
	public static final String EBUY_GOODINFO="http://"+Host+"/ebuy/goodsinfo";
	/*查看商品评论*/
	public static final String EBUY_GOODCOMMENT="http://"+Host+"/ebuy/goodscomment";
	/*商品心得列表*/
	public static final String EBUY_REALIZE="http://"+Host+"/ebuy/realize";
	/*商品心得详情*/
	public static final String EBUY_REALIZEINFO="http://"+Host+"/ebuy/realizeinfo";
	/*订购接口*/
	public static final String EBUY_ORDER="http://"+Host+"/ebuy/order";
	/*订购详情*/
	public static final String EBUY_ORDER_INFO="http://"+Host+"/ebuy/orderinfo";
	/*上传图片接口*/
	public static final String EBUY_UPLOAD_PIC="http://"+Host+"/ebuy/file/pic";
	
}
