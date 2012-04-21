//
//  Api+Database.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api.h"
//====================================< 本地数据库 - 接口 >====================================
#import "sqlite3.h"
#import "Api+Category.h"

@interface DataBaseOperate : NSObject{
    BOOL _isOpen;
}
+ (DataBaseOperate *)shareData;

- (void)insertFavirote:(FaviroteObject*)model;
- (void)deleteFavirote:(int)objectID;
- (NSArray*)loadFavirote:(int)pageIndex;

- (void)insertHistory:(HistoryObject*)model;
- (void)deleteHistory:(int)objectID;
- (NSArray*)loadHistory:(int)pageIndex withType:(BOOL)isEncode;
- (NSArray*)searchHistory:(int)pageIndex withKey:(NSString*)key withType:(BOOL)isEncode;
@end

//====================================< 本地数据库 - 接口 >====================================
@interface Api (Database)

@end
