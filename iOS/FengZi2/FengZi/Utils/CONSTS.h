//
//  CONSTS.h
//  Hupan
//
//  Copyright 2011-2012 ifengzi.cn. All rights reserved.
//


#define REQUEST_DOMAIN @"http://cx.itotemstudio.com/api.php" // default env

#define API_QRCODE_DIMENSION (150) // 二维码尺寸
#define APPSTORE_URL @"http://itunes.apple.com/us/app//id494490342?l=zh&ls=1&mt=8"//appstore 地址
#define REQUEST_URL @"http://m.ifengzi.cn/mb"
#define DEFAULT_SEARCH @"http://www.baidu.com/s?wd=%@"
#define DEFAULT_MAP_SEARCH @"http://maps.google.com/maps?q=%@"

#define CHANNEL_NUMBER @"0" // 渠道号
#define BUSINESS_NUM 14 //业务数目
#define HELPSHOW @"HELPSHOW"
//
#define DECODE_FAIL @"识别的码非标准QR码或破损严重，请调整重新识别"
#define TABLE_PAGESIZE 15
#define HISTORY_TOTAL 100 // 历史记录上限
#define FlashLightStatus @"FlashLightStatus"
#define DecodeMusicStatus @"DecodeMusicStatus"
#define LocationStatus @"LocationStatus"
#define Service_Tel @"010-62666855"
#define Service_Email @"feng@fengxiafei.com"
#define Service_WebSite @"http://www.ifengzi.cn"
#define RecommendContent @"我正在使用蜂子生成二维码，无论文字、链接、图片、视频都可以变成二维码哟，快制作一个属于你的二维码分享给你的亲朋好友，一起来疯吧。蜂子链接地址www.ifengzi.cn"

//DataCacheManager keys
#define KEY_USER                    @"KEY_USER"
#define KEY_ALLCATEGORY             @"KEY_ALLCATEGORY"
#define KEY_UPDATETIME              @"KEY_UPDATETIME"
#define KEY_TOPIC_NEWS_LIST         @"KEY_TOPIC_NEWS_LIST"
#define KEY_TOPIC_FOCUS_IMAGE       @"KEY_TOPIC_FOCUS_IMAGE"
#define KEY_OPNION_LIST             @"KEY_OPNION_LIST"
#define KEY_VISIONS_PICTURE_LIST    @"KEY_VISIONS_PICTURE_LIST"
#define KEY_VISIONS_VIDEO_LIST      @"KEY_VISIONS_VIDEO_LIST"
#define KEY_UPDATE_NEWS_LIST        @"KEY_UPDATE_NEWS_LIST"
#define SHARE_FINISH        @"SHARE_FINISH"
#define SHARE_AUTH_FINISH @"SHARE_AUTH_FINISH"

/*User Default Key*/
//Setting
#define UD_OFFLINE_DOWNLOAD         @"UD_OFFLINE_DOWNLOAD"

//TTPage
#define TTPAGE_DOT_NUM      3   //滚动图片数目

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."

//update time tag for key in DataEnvironment.updateTimeDic
typedef enum 
{
    CXUpdateTimeTagAllCategory = 0,
    CXUpdateTimeTagLastest
}CXUpdateTimeTag;

typedef enum{
    ImpressionViewColorOrange = 0,
    ImpressionViewColorBlue = 1,
    ImpressionViewColorRed = 2,
    ImpressionViewColorYellow = 3,
    ImpressionViewColorPink = 4,
    ImpressionViewColorLightBlue = 5,
    ImpressionViewColorPurple = 6,
    ImpressionViewColorGreen = 7
}ImpressionViewColor;

//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;

typedef enum{
    UILabelDividePositionUnknown = 0,
    UILabelDividePositionFront,
    UILabelDividePositionBehind,
    UILabelDividePositionHere
} UILabelDividePosition;

typedef enum{
    EncodeImageTypeCommon = 0,
    EncodeImageTypeIcon
} EncodeImageType;

/*
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
*/

typedef enum{
    BusinessTypeUrl=0,
    BusinessTypeBookMark,
    BusinessTypeAppUrl,
    BusinessTypeWeibo,
    BusinessTypeCard,
    BusinessTypePhone,
    BusinessTypeEmail,
    BusinessTypeText,
    BusinessTypeEncText,
    BusinessTypeShortMessage,
    BusinessTypeWifiText,
    BusinessTypeGmap,
    BusinessTypeSchedule,
    BusinessTypeRichMedia//=14 // 富媒体为14
}BusinessType;

typedef enum{
    BOOKMARK = 0,
    WEIBO,
    GMAP,
    APP
} UrlType;

typedef enum{
    LinkTypeNone = 0,
    LinkTypeUrl,
    LinkTypeSms,
    LinkTypeCardPhone,
    LinkTypePhone,
    LinkTypeEmail,
    LinkTypeEmailText,
    LinkTypeMap,
    LinkTypeText,
    LinkTypeTitle,
    LinkTypeAppUrl,
    LinkTypeCompany,
    LinkTypeWeibo,
    LinkTypeWifi
} LinkType;

typedef enum{
    ScanCodeTypeCamera = 0,
    ScanCodeTypeImage,
    ScanCodeTypeWeisite
} ScanCodeType;

typedef enum{
    HistoryTypeNone = 0,// 不进行收藏和历史
    HistoryTypeFavAndHistory,// 可以收藏
    HistoryTypeFav,// 可以收藏
    HistoryTypeHistory //记录历史
} HistoryType;

//functions
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define DATA_ENV [DataEnvironment sharedDataEnvironment]
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
