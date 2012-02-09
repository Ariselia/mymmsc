//
//  Phone.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Phone.h"

@implementation Phone
@synthesize telephone=_telephone;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_telephone);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end
