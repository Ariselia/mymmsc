#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FaviroteObject.h"
#import "HistoryObject.h"

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
