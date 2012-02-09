//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"
@interface ITTBaseModelObject :NSObject <NSCoding> {

}
-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
@end
