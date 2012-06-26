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
#import "Api.h"
//--------------------< 本地数据库 - 接口 - eFile >--------------------
#import "Api+eFile.h"
#import <iOSApi/iOSDatabase.h>


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
	 
	{
        if (sqlite3_open([path UTF8String], &database ) == SQLITE_OK) {
            //创建数据库
            const char* createSql = "CREATE TABLE `favirote` (`id` INTEGER PRIMARY KEY  DEFAULT '', `type` INTEGER DEFAULT 0, `date` DATETIME DEFAULT '', `content` VARCHAR DEFAULT '', `image` VARCHAR DEFAULT '')";
            sqlite3_exec( database, createSql, NULL, NULL, nil);
            
            createSql = "CREATE TABLE `history` (`id` INTEGER PRIMARY KEY  DEFAULT '', `type` INTEGER DEFAULT 0,`is_encode` smallint DEFAULT 0, `date` DATETIME DEFAULT '', `content` VARCHAR DEFAULT '', `image` VARCHAR DEFAULT '')";
            sqlite3_exec( database, createSql, NULL, NULL, nil);
            
            createSql = "create table if not exists `member` (`id` INTEGER PRIMARY KEY  DEFAULT '', `memberclassid` VARCHAR DEFAULT '',`memberclassname` VARCHAR DEFAULT '',`memberlistid` VARCHAR DEFAULT '',`memberlistname` VARCHAR DEFAULT '',`memberlistpicurl` VARCHAR DEFAULT '',`memberinfocodename` VARCHAR DEFAULT '',`memberinfocodepicurl` VARCHAR DEFAULT '',`memberinfocodecontent` VARCHAR DEFAULT '',`memberinfocodenum` VARCHAR DEFAULT '',`memberinfopicurl` VARCHAR DEFAULT '',`memberinfocodeserialnum` VARCHAR DEFAULT '',`memberinfocodeusetime` VARCHAR DEFAULT '',`userid` VARCHAR DEFAULT '',`userphone` VARCHAR DEFAULT '')";
            sqlite3_exec( database, createSql, NULL, NULL, nil);
            createSql = "create table if not exists `card` (`id` INTEGER PRIMARY KEY  DEFAULT '', `cardclassid` VARCHAR DEFAULT '',`cardclassname` VARCHAR DEFAULT '',`cardlistid` VARCHAR DEFAULT '',`cardlistname` VARCHAR DEFAULT '',`cardlistpicurl` VARCHAR DEFAULT '',`cardlistflag` VARCHAR DEFAULT '',`cardinfocode` VARCHAR DEFAULT '',`cardinfocodepicurl` VARCHAR DEFAULT '',`cardinfocontent` VARCHAR DEFAULT '',`cardinfoname` VARCHAR DEFAULT '',`cardinfodiscount` VARCHAR DEFAULT '',`cardinfopicurl` VARCHAR DEFAULT '',`cardinfoserialnum` VARCHAR DEFAULT '',`cardinfousetime` VARCHAR DEFAULT '',`cardinfousestate` VARCHAR DEFAULT '',`cardlistarealist` VARCHAR DEFAULT '',`cardlisttypelist` VARCHAR DEFAULT '',`cardinfoshoplist` VARCHAR DEFAULT '',`userid` VARCHAR DEFAULT '',`userphone` VARCHAR DEFAULT '')";
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

#define API_DB_NAME @"ifengzi.db"

#define SQL_CREATE_MEMBER  @"create table if not exists `member` (`id` INTEGER PRIMARY KEY  DEFAULT '', `memberclassid` VARCHAR DEFAULT '',`memberclassname` VARCHAR DEFAULT '',`memberlistid` VARCHAR DEFAULT '',`memberlistname` VARCHAR DEFAULT '',`memberlistpicurl` VARCHAR DEFAULT '',`memberinfocodename` VARCHAR DEFAULT '',`memberinfocodepicurl` VARCHAR DEFAULT '',`memberinfocodecontent` VARCHAR DEFAULT '',`memberinfocodenum` VARCHAR DEFAULT '',`memberinfopicurl` VARCHAR DEFAULT '',`memberinfocodeserialnum` VARCHAR DEFAULT '',`memberinfocodeusetime` VARCHAR DEFAULT '',`userid` VARCHAR DEFAULT '',`userphone` VARCHAR DEFAULT '')"

#define SQL_CREATE_CARD @"create table if not exists `card` (`id` INTEGER PRIMARY KEY  DEFAULT '', `cardclassid` VARCHAR DEFAULT '',`cardclassname` VARCHAR DEFAULT '',`cardlistid` VARCHAR DEFAULT '',`cardlistname` VARCHAR DEFAULT '',`cardlistpicurl` VARCHAR DEFAULT '',`cardlistflag` VARCHAR DEFAULT '',`cardinfocode` VARCHAR DEFAULT '',`cardinfocodepicurl` VARCHAR DEFAULT '',`cardinfocontent` VARCHAR DEFAULT '',`cardinfoname` VARCHAR DEFAULT '',`cardinfodiscount` VARCHAR DEFAULT '',`cardinfopicurl` VARCHAR DEFAULT '',`cardinfoserialnum` VARCHAR DEFAULT '',`cardinfousetime` VARCHAR DEFAULT '',`cardinfousestate` VARCHAR DEFAULT '',`cardlistarealist` VARCHAR DEFAULT '',`cardlisttypelist` VARCHAR DEFAULT '',`cardinfoshoplist` VARCHAR DEFAULT '',`userid` VARCHAR DEFAULT '',`userphone` VARCHAR DEFAULT '')"
#define SQL_MEMBER_HAS_USERPHONE @"select userphone from member"
#define SQL_CARD_HAS_USERPHONE @"select userphone from card"
- (void)addColumn:(NSString*)table column:(NSString*)column type:(NSString*)type
{
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
     NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@ '';",table,column,type];
    [db execute2:sql];
    
}
- (void)checkTableMember:(iOSDatabase *)db{
    [db execute2:SQL_CREATE_MEMBER];
    if (![db execute2:SQL_MEMBER_HAS_USERPHONE]) {
        [self addColumn:@"member" column:@"userphone" type:@"VARCHAR DEFAULT"];
    }
}

-(void)checkTableCard:(iOSDatabase *)db{
    [db execute2:SQL_CREATE_CARD];
    if (![db execute2:SQL_CARD_HAS_USERPHONE]) {
        [self addColumn:@"card" column:@"userphone" type:@"VARCHAR DEFAULT"
         ];
    }

}

-(BOOL)checkMemberExists:(NSString*)sid
{
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];    if (db != nil) {
        [self checkTableMember:db];
    }
    BOOL _isExists= NO;
    NSString *sql = @"select memberlistid from member where memberlistid = ? and userphone = ?";
    _isExists = [db prepare:sql];
    if ([db prepare:sql])
    {   
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        if ([db execute]) {
            _isExists = YES;
        } else {
            // NSLog(@"NO");
            _isExists=NO;
        }
    }
    [db release];
    return _isExists;
}


- (BOOL)checkCardExists:(NSString*)sid
{
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    if (db != nil) {
        [self checkTableCard:db];
    }
    BOOL _isExists= NO;
    NSString *sql = @"select cardlistid from card where cardlistid = ? and userphone = ?";
    if ([db prepare:sql])
    {   
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        if ([db execute]) {
            _isExists = YES;
        } else {
            _isExists=NO;
        }
        
    }
    [db release];
    return _isExists;
}

- (void)insertMember:(NSString*)a b:(NSString*)b c:(NSString*)c d:(NSString*)d e:(NSString*)e f:(NSString*)f g:(NSString*)g h:(NSString*)h i:(NSString*)i j:(NSString*)j k:(NSString*)k l:(NSString*)l m:(NSString*)m{
    
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableMember:db];
    NSString *sql = @"INSERT INTO member (memberclassid,memberclassname,memberlistid,memberlistname,memberlistpicurl,memberinfocodename,memberinfocodepicurl,memberinfocodecontent,memberinfocodenum,memberinfopicurl,memberinfocodeserialnum,memberinfocodeusetime,userid,userphone) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if ([db prepare:sql])
    {                    
        [db bind:1 text:a];
        [db bind:2 text:b];
        [db bind:3 text:c];
        [db bind:4 text:d];
        [db bind:5 text:e];
        [db bind:6 text:f];
        [db bind:7 text:g];
        [db bind:8 text:h];
        [db bind:9 text:i];
        [db bind:10 text:j];
        [db bind:11 text:k];
        [db bind:12 text:l];
        [db bind:13 text:m];
        [db bind:14 text:[Api userPhone]];
        [db execute];
    } else {
		//NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
	}
    [db release];
}

- (void)insertCard:(NSString*)a b:(NSString*)b c:(NSString*)c d:(NSString*)d e:(NSString*)e f:(NSString*)f g:(NSString*)g h:(NSString*)h i:(NSString*)i j:(NSString*)j k:(NSString*)k l:(NSString*)l m:(NSString*)m  n:(NSString*)n o:(NSString*)o p:(NSString*)p q:(NSString*)q r:(NSString*)r s:(NSString*)s{
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableCard:db];
    /*
     1 cardclassid,2 cardclassname,3 cardlistid,
     4 cardlistname,5 cardlistpicurl,6 cardlistflag,7 cardinfocode,
     8 cardinfocodepicurl,9 cardinfocontent,10 cardinfoname,
     11 cardinfodiscount,12 cardinfopicurl,13 cardinfoserialnum,14 cardinfousetime,
     15 cardinfousestate,16 cardlistarealist,17 cardlisttypelist,18 cardinfoshoplist,19 userid
     */
    
    NSString *sql = @"INSERT INTO card (cardclassid,cardclassname,cardlistid,cardlistname,cardlistpicurl,cardlistflag,cardinfocode,cardinfocodepicurl,cardinfocontent,cardinfoname,cardinfodiscount,cardinfopicurl,cardinfoserialnum,cardinfousetime,cardinfousestate,cardlistarealist,cardlisttypelist,cardinfoshoplist,userid,userphone) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if ([db prepare:sql])
    {                    
        [db bind:1 text:a];
        [db bind:2 text:b];
        [db bind:3 text:c];
        [db bind:4 text:d];
        [db bind:5 text:e];
        [db bind:6 text:f];
        [db bind:7 text:g];
        [db bind:8 text:h];
        [db bind:9 text:i];
        [db bind:10 text:j];
        [db bind:11 text:k];
        [db bind:12 text:l];
        [db bind:13 text:m];
        [db bind:14 text:n];
        [db bind:15 text:o];
        [db bind:16 text:p];
        [db bind:17 text:q];
        [db bind:18 text:r];
        [db bind:19 text:s];
        [db bind:20 text:[Api userPhone]];

        [db execute];
    } else {
		//NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
	}
    [db release];
}

- (EFileMemberInfo *)loadMemberInfo:(NSString *)sid{
    EFileMemberInfo *obj = nil;
    iOSDatabase *db =[[iOSDatabase open:API_DB_NAME] retain];    NSString *sql = @"select memberinfocodename,memberinfocodepicurl,memberinfocodecontent,memberinfocodenum,memberinfopicurl,memberinfocodeserialnum,memberinfocodeusetime,userid FROM member where memberlistid = ? and userphone=?";
    [self checkTableMember:db];
    if ([db prepare:sql]) {
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        NSMutableArray *list = [db execute:EFileMemberInfo.class];
        if (list.count > 0) {
            obj = [list objectAtIndex:0];
        }
	} else {
		NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	[db release];
    db = nil;
	return obj;
}


- (NSMutableArray*)loadCard:(int)pageIndex{
    NSMutableArray *list = nil;
    NSString *sql = @"select cardclassid as sid, cardclassname as name FROM card where  userphone=? group by cardclassid";
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
	[self checkTableCard:db];
    if ([db prepare:sql]) {
        
        [db bind:1 text:[Api userPhone]];
        list = [db execute:EFileCard.class];
    }
	
	[db release];
	return list;
}

- (NSMutableArray *)loadCardList:(int)pageIndex sid:(NSString *)sid{
    NSMutableArray *list = nil;
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableCard:db];
    NSString *sql = @"select cardlistid as sid,cardlistname as name,cardlistpicurl as picurl,cardlistflag as flag FROM card where cardclassid = ? and userphone=?";
    //const char *sql = "select memberclassid,memberclassname  FROM member";
	if ([db prepare:sql]) {
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        list = [db execute:EFileCardList.class];
	}
	
	[db release];
	return list;
}

- (EFileCardInfo *)loadCardInfo:(NSString *)sid{
    EFileCardInfo *obj = nil;
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableCard:db];
    NSString *sql = @"select cardinfocode,cardinfocodepicurl,cardinfocontent,cardinfoname,cardinfodiscount,cardinfopicurl,cardinfoserialnum,cardinfousetime,cardinfousestate,cardlistarealist,cardlisttypelist,cardinfoshoplist,userid FROM card where cardlistid = ? and userphone=?";
  	if ([db prepare:sql]) {
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        NSMutableArray *list = [db execute:EFileCardInfo.class];
        if (list.count > 0) {
            obj = [list objectAtIndex:0];
        }
	}
	
	[db release];
	return obj;
}

-(NSMutableArray*)loadMember:(int)pageIndex{
    NSMutableArray *list = nil;
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableMember:db];
	NSString *sql = @"select memberclassid as sid,memberclassname as name FROM member where  userphone=? group by memberclassid";
	if ([db prepare:sql]) {
         [db bind:1 text:[Api userPhone]];
        list = [db execute:EFileMember.class];
	}
	
	[db release];
	return list;
}


-(NSMutableArray*)loadMemberList:(int)pageIndex sid:(NSString *)sid{
    NSMutableArray *list = nil;
    iOSDatabase *db = [[iOSDatabase open:API_DB_NAME] retain];
    [self checkTableMember:db];
	NSString *sql = @"select memberlistid as sid,memberlistname as name,memberlistpicurl as picurl FROM member where memberclassid = ? and userphone = ?";
    if ([db prepare:sql]) {
        [db bind:1 text:sid];
        [db bind:2 text:[Api userPhone]];
        list = [db execute:EFileMemberList.class];
	}
	
	[db release];
	return list;
}

@end

//====================================< 本地数据库 - 接口 >====================================
@implementation Api (Database)

@end
