//
//  Shortmessage.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Shortmessage.h"

@implementation Shortmessage
@synthesize contente=_contente;
@synthesize logId=_logId;
@synthesize cellphone=_cellphone;

- (void)dealloc {
    RELEASE_SAFELY(_cellphone);
    RELEASE_SAFELY(_contente);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end
