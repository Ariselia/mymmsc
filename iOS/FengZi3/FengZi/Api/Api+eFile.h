//
//  Api+eFile.h
//  FengZi
//
//  Created by ZhichaoLiu on 12-4-18.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

//====================================< 电子蜂夹 - 常量定义 >====================================
#define API_EBUY_SCROLL_IMGCOUNT (3)
#define API_EBUY_SCROLL_IMGWIDTH (48.0f)

//====================================< 电子蜂夹 - 接口 >====================================

//--------------------< 电子蜂夹 - 对象 --会员卡  >--------------------

//会员卡
@interface EFileMember : NSObject {
    NSString *sid;     // 蜂夹编号
    NSString *name;       // 蜂夹名称
  
}
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;

@end

//--------------------< 电子蜂夹 - 对象 －－ 会员卡>--------------------
//会员卡列表
@interface EFileMemberList : NSObject {
    NSString *sid;	//会员卡id
    NSString *name	;//会员卡名称
    NSString *picurl	;//会员卡图片缩略图
    //int flag	;//0:新的,1:旧的
}
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picurl;
//@property (nonatomic, assign) int flag;
@end


@interface EFileMemberInfo : NSObject {
 //memberinfocodename,memberinfocodepicurl,memberinfocodecontent,memberinfocodenum,memberinfopicurl,memberinfocodeserialnum,memberinfocodeusetime,userid   
    NSString *memberinfocodename;	
    NSString *memberinfocodepicurl	;
    NSString *memberinfocodecontent;
    NSString *memberinfocodenum;
    NSString *memberinfopicurl;
    NSString *memberinfocodeserialnum;
    NSString *memberinfocodeusetime;
    NSString *userid;

    
}
@property (nonatomic, copy)  NSString *memberinfocodename;
@property (nonatomic, copy)  NSString *memberinfocodepicurl;
@property (nonatomic, copy)  NSString *memberinfocodecontent;
@property (nonatomic, copy) NSString *memberinfocodenum;
@property (nonatomic, copy) NSString *memberinfopicurl;
@property (nonatomic, copy) NSString *memberinfocodeserialnum;
@property (nonatomic, copy) NSString *memberinfocodeusetime;
@property (nonatomic, copy) NSString *userid;

@end

//--------------------< 电子券 - 对象 -  >--------------------
//电子券
@interface EFileCard : NSObject {
@private
    NSString *sid;
    NSString *name;
 }

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;

@end

//电子券列表
@interface EFileCardList : NSObject {
    NSString *sid;	//电子券id
    NSString *name	;//电子券名称
    NSString *picurl	;//电子券图片缩略图
    NSString *flag	;//0:新的,1:旧的
}
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, assign) NSString *flag;

@end

//电子券详细信息
@interface EFileCardInfo : NSObject {
// cardinfocode,cardinfocodepicurl,cardinfocontent,cardinfoname,cardinfodiscount,cardinfopicurl,cardinfoserialnum,cardinfousetime,cardinfousestate,cardlistarealist,cardlisttypelist,cardinfoshoplist,userid 
    
      NSString *cardinfocode;
      NSString *cardinfocodepicurl;
      NSString *cardinfocontent;
    
     NSString *cardinfoname;
     NSString *cardinfodiscount;
     NSString *cardinfopicurl;
    NSString *cardinfoserialnum;
    NSString *cardinfousetime;
     NSString *cardinfousestate;
    
     NSString *cardlistarealist;
    NSString *cardlisttypelist;
     NSString *cardinfoshoplist;
    NSString *userid;   
    
}
@property (nonatomic, copy)  NSString *cardinfocode;
@property (nonatomic, copy)  NSString *cardinfocodepicurl;
@property (nonatomic, copy)  NSString *cardinfocontent;

@property (nonatomic, copy) NSString *cardinfoname;
@property (nonatomic, copy) NSString *cardinfodiscount;
@property (nonatomic, copy) NSString *cardinfopicurl;
@property (nonatomic, copy) NSString *cardinfoserialnum;
@property (nonatomic, copy) NSString *cardinfousetime;
@property (nonatomic, copy) NSString *cardinfousestate;

@property (nonatomic, copy) NSString *cardlistarealist;
@property (nonatomic, copy) NSString *cardlisttypelist;
@property (nonatomic, copy) NSString *cardinfoshoplist;
@property (nonatomic, copy) NSString *userid;
@end



@interface Api(EFile)

//会员卡
+ (NSMutableArray *)get_member;

+ (NSMutableArray *)get_member_list:(int) sid;

+ (EFileMemberInfo *)get_member_info:(NSString*) sid;
//电子券

+ (NSMutableArray *)get_card;

+ (NSMutableArray *)get_card_list:(NSString*) sid;

+ (EFileCardInfo *)get_card_info:(NSString*) sid;


@end
