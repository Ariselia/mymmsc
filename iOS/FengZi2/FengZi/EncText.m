//
//  EncText.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncText.h"

@implementation EncText
@synthesize content=_content;
@synthesize encContent=_encContent;
@synthesize logId=_logId;
@synthesize key=_key;

- (void)dealloc {
    RELEASE_SAFELY(_encContent);
    RELEASE_SAFELY(_key);
    RELEASE_SAFELY(_logId);
    RELEASE_SAFELY(_content);
    [super dealloc];
}
@end
