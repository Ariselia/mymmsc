//
//  WifiText.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "WifiText.h"

@implementation WifiText
@synthesize name=_name;
@synthesize logId=_logId;
@synthesize password=_password;

- (void)dealloc {
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_password);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end
