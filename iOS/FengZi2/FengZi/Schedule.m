//
//  Schedule.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
@synthesize content=_content;
@synthesize logId=_logId;
@synthesize date=_date;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_date);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end
