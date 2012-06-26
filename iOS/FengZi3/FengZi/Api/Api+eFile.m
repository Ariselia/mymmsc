//
//  Api+eFile.m
//  FengZi
//
//  Created by a on 12-4-18.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+eFile.h"


//--------------------< 蜂夹 >--------------------
@implementation EFileMember

@synthesize sid, name;
@end

@implementation EFileMemberList

@synthesize sid, name,picurl;
@end

@implementation EFileMemberInfo

@synthesize  memberinfocodename,memberinfocodepicurl,memberinfocodecontent,memberinfocodenum,memberinfopicurl,memberinfocodeserialnum,memberinfocodeusetime,userid;
@end

@implementation EFileCard

@synthesize sid, name;
@end

@implementation EFileCardList
@synthesize sid, name,picurl,flag;

@end


@implementation EFileCardInfo

@synthesize  cardinfocode,cardinfocodepicurl,cardinfocontent,cardinfoname,cardinfodiscount,cardinfopicurl,cardinfoserialnum,cardinfousetime,cardinfousestate,cardlistarealist,cardlisttypelist,cardinfoshoplist,userid;
@end

@implementation Api(EFile)

//会员卡
+ (NSMutableArray *)get_member
{
    NSMutableArray *list = nil;
    return list;
}

+ (NSMutableArray *)get_member_list:(int)sid
{
    NSMutableArray *list = nil;
    return list;
}

+ (EFileMemberInfo *)get_member_info:(NSString*)sid
{
    EFileMemberInfo *iRet = nil;
    
    
    static NSString *method = @"clip";
    NSString *query = [NSString stringWithFormat:@"action=membershipcard&&type=info&userid=%d&&id=%@", [Api userId],sid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString valueOf:[Api userId]], @"userId",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EFILE, method, query];
    NSDictionary *response = [Api post:action header:params body:nil];
    if (response) {
        NSMutableArray *data1 = [response objectForKey:@"clip"];
        NSDictionary *data = [(NSDictionary*)data1 objectForKey:@"data"];
        
        
        if (data.count > 0) {
            //表数据
            NSLog(@"go here111");
             iRet = [data toObject:EFileMemberInfo.class];
            
        }
        
        
    }
    
    return iRet;
}

//电子券

+ (NSMutableArray *)get_card
{
    NSMutableArray *list = nil;
    return list;
}

+ (NSMutableArray *)get_card_list:(NSString*)sid
{ 
    NSMutableArray *list = nil;
    
    
    return list;
}


+ (EFileCardInfo *)get_card_info:(NSString*)sid
{
    EFileCardInfo *iRet = nil;

    static NSString *method = @"clip";
    NSString *query = [NSString stringWithFormat:@"action=coupon&type=info&userid=%d&&id=%@", [Api userId],sid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString valueOf:[Api userId]], @"userId",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EFILE, method, query];
    NSDictionary *response = [Api post:action header:params body:nil];
    if (response) {
        NSMutableArray *data1 = [response objectForKey:@"clip"];
        NSDictionary *data = [(NSDictionary*)data1 objectForKey:@"data"];
        
        
        if (data.count > 0) {
            //表数据
            NSLog(@"go here");
           iRet = [data toObject:EFileCardInfo.class];
            
        }
         
         
    }
    
    return iRet;
    

}



   
@end
