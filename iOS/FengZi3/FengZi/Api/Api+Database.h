//
//  Api+Database.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

//====================================< 本地数据库 - 接口 >====================================
#import "sqlite3.h"
#import "Api+Category.h"

@class EFileCardInfo;
@class EFileMemberInfo;

@interface DataBaseOperate : NSObject{
    BOOL _isOpen;
}
+ (DataBaseOperate *)shareData;

-(BOOL)checkFaviroteExists:(NSString*)content type:(int)type;
- (void)insertFavirote:(FaviroteObject*)model;
- (void)deleteFavirote:(int)objectID;
- (NSArray*)loadFavirote:(int)pageIndex;

- (void)insertHistory:(HistoryObject*)model;
- (void)deleteHistory:(int)objectID;
- (NSArray*)loadHistory:(int)pageIndex withType:(BOOL)isEncode;
- (NSArray*)searchHistory:(int)pageIndex withKey:(NSString*)key withType:(BOOL)isEncode;

//--------------------< 本地数据库 - 接口 - eFile >--------------------
-(BOOL)checkMemberExists:(NSString*)sid;
-(BOOL)checkCardExists:(NSString*)sid;
- (NSMutableArray*)loadMember:(int)pageIndex;
- (NSMutableArray*)loadCard:(int)pageIndex;
- (NSMutableArray*)loadMemberList:(int)pageIndex sid:(NSString*)sid;
- (NSMutableArray*)loadCardList:(int)pageIndex sid:(NSString*)sid;

- (void)insertMember:(NSString*)a b:(NSString*)b c:(NSString*)c d:(NSString*)d e:(NSString*)e f:(NSString*)f g:(NSString*)g h:(NSString*)h i:(NSString*)i j:(NSString*)j k:(NSString*)k l:(NSString*)l m:(NSString*)m;

- (void)insertCard:(NSString*)a b:(NSString*)b c:(NSString*)c d:(NSString*)d e:(NSString*)e f:(NSString*)f g:(NSString*)g h:(NSString*)h i:(NSString*)i j:(NSString*)j k:(NSString*)k l:(NSString*)l m:(NSString*)m  n:(NSString*)n o:(NSString*)o p:(NSString*)p q:(NSString*)q r:(NSString*)r s:(NSString*)s;

- (EFileMemberInfo *)loadMemberInfo:(NSString *)sid;

- (EFileCardInfo*)loadCardInfo:(NSString *)sid;

@end

//====================================< 本地数据库 - 接口 >====================================
@interface Api (Database)

@end
