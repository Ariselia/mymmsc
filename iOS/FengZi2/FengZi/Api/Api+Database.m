//
//  Api+Database.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api+Database.h"
//====================================< 本地数据库 - 接口 >====================================
#import "FileUtil.h"
@implementation DataBaseOperate
static DataBaseOperate *shareData = nil;
static sqlite3 *database;

-(void)openDatabase{
    if (_isOpen) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentszDirectory = [paths objectAtIndex:0];
	NSString *path = [documentszDirectory stringByAppendingString:@"/fengzi.db"];
	if ([fileManager fileExistsAtPath:path] == YES)
	{
        if (sqlite3_open([path UTF8String], &database ) != SQLITE_OK) {
            NSLog(@"Error: failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
	}
	else 
	{
        if (sqlite3_open([path UTF8String], &database ) == SQLITE_OK) {
            //创建数据库
            const char* createSql = "CREATE TABLE `favirote` (`id` INTEGER PRIMARY KEY  DEFAULT '', `type` INTEGER DEFAULT 0, `date` DATETIME DEFAULT '', `content` VARCHAR DEFAULT '', `image` VARCHAR DEFAULT '')";
            sqlite3_exec( database, createSql, NULL, NULL, nil);
            
            createSql = "CREATE TABLE `history` (`id` INTEGER PRIMARY KEY  DEFAULT '', `type` INTEGER DEFAULT 0,`is_encode` smallint DEFAULT 0, `date` DATETIME DEFAULT '', `content` VARCHAR DEFAULT '', `image` VARCHAR DEFAULT '')";
            sqlite3_exec( database, createSql, NULL, NULL, nil);
            
            _isOpen = YES;
        }else{
            NSLog(@"Error: failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
        [FileUtil addSkipBackupAttributeToItemAtURL:path];
	}	    
}

+ (void)closeDataBase{
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}



- (id)init{
	if ((self = [super init]) ) {
		shareData = self;
	}
	return shareData;
}

+ (id)shareData{
	@synchronized( self ) {
		if ( shareData == nil ) {
			shareData = [[self alloc] init];
            [shareData openDatabase];
		}
	}
	return shareData;
}

//插入
- (void)insertFavirote:(FaviroteObject*)model{
    sqlite3_stmt* statement = NULL;
    const char* sql = "INSERT INTO favirote (content,date,image,type) VALUES(?,datetime('now', 'localtime'),?,?)";
    if (SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &statement, NULL))
    {                    
        sqlite3_bind_text(statement, 1, [model.content UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [model.image UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, model.type);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    } else {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
	}
}

- (void)deleteFavirote:(int)objectID{
    const char *sql = "DELETE FROM favirote WHERE id=?";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, objectID);
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}

- (NSArray*)loadFavirote:(int)pageIndex{
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0]  autorelease];
	sqlite3_stmt *statement;
	const char *sql = "select id,content,image,type,date FROM favirote  order by date desc limit ?,?";
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, pageIndex);
        sqlite3_bind_int(statement, 2, TABLE_PAGESIZE);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            FaviroteObject *item = [[FaviroteObject alloc] init];
            item.uuid = (int)sqlite3_column_int(statement, 0);
            if ((char *)sqlite3_column_text(statement, 1)) {
                item.content =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            }
            item.image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            item.type = (int)sqlite3_column_int(statement, 3);
            if ((char *)sqlite3_column_text(statement, 4)) {
                item.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            }
            [result addObject:item];
            [item release];
        }       
	} else {
		NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_finalize(statement);
	return result;
}

-(void)checkBase{
    sqlite3_stmt* statement = NULL;
    int count = -1;
    int uuid=0;
    const char* sql = "select count(*),id from history order by date asc";
    if (SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &statement, NULL))
    {                   
        while (sqlite3_step(statement) == SQLITE_ROW) {
            count = (int)sqlite3_column_int(statement, 0);
        }
    } else {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
	}
    sqlite3_finalize(statement);
    sqlite3_stmt* statement1 = NULL;
    
    if (count>HISTORY_TOTAL) {
        NSString *image;
        BusinessType _isEncodeModel;
        
        sql = "select id,image from history  order by date asc limit 1";
        if (SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &statement1, NULL))
        {                   
            while (sqlite3_step(statement1) == SQLITE_ROW) {
                uuid = (int)sqlite3_column_int(statement1, 0);
                image=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 1)];
                _isEncodeModel = (int)sqlite3_column_int(statement1, 2);
            }
        } else {
            NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement1);
        if (uuid==0) {
            return;
        }
        [self deleteHistory:uuid];
        if (_isEncodeModel) {
            [FileUtil deleteFile:[FileUtil filePathInEncode:image]];
        } else {
            [FileUtil deleteFile:[FileUtil filePathInScan:image]];
        }
    }
}
//插入
- (void)insertHistory:(HistoryObject*)model{
    [self checkBase];
    sqlite3_stmt* statement = NULL;
    const char* sql = "INSERT INTO history (content,date,image,type,is_encode) VALUES(?,datetime('now', 'localtime'),?,?,?)";
    if (SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &statement, NULL))
    {                    
        sqlite3_bind_text(statement, 1, [model.content UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [model.image UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, model.type);
        sqlite3_bind_int(statement, 4, model.isEncode);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    } else {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
	}
}

- (void)deleteHistory:(int)objectID{
    const char *sql = "DELETE FROM history WHERE id=?";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, objectID);
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}

- (NSArray*)loadHistory:(int)pageIndex withType:(BOOL)isEncode{
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	sqlite3_stmt *statement;
	const char *sql = "select id,content,image,type,date FROM history where is_encode=? order by date desc limit?,?";
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, isEncode);
        sqlite3_bind_int(statement, 2, pageIndex);
        sqlite3_bind_int(statement, 3, TABLE_PAGESIZE);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            HistoryObject *item = [[HistoryObject alloc] init];
            item.uuid = (int)sqlite3_column_int(statement, 0);
            if ((char *)sqlite3_column_text(statement, 1)) {
                item.content =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            }
            item.image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            item.type = (int)sqlite3_column_int(statement, 3);
            if ((char *)sqlite3_column_text(statement, 4)) {
                item.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            }
            [result addObject:item];
            [item release];
        }       
	} else {
		NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_finalize(statement);
	return result;
}
- (NSArray*)searchHistory:(int)pageIndex withKey:(NSString*)key withType:(BOOL)isEncode{
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"select id,content,image,type,date FROM history where is_encode=? and content like '%%%@%%'  order by date desc limit?,?",key];
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, isEncode);
        sqlite3_bind_int(statement, 2, pageIndex);
        sqlite3_bind_int(statement, 3, TABLE_PAGESIZE);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            HistoryObject *item = [[HistoryObject alloc] init];
            item.uuid = (int)sqlite3_column_int(statement, 0);
            if ((char *)sqlite3_column_text(statement, 1)) {
                item.content =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            }
            item.image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            item.type = (int)sqlite3_column_int(statement, 3);
            if ((char *)sqlite3_column_text(statement, 4)) {
                item.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            }
            [result addObject:item];
            [item release];
        }       
	} else {
		NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	sqlite3_finalize(statement);
	return result;
}
@end

//====================================< 本地数据库 - 接口 >====================================
@implementation Api (Database)

@end
