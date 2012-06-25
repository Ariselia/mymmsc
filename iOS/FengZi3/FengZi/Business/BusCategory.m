//
//  BusCategory.m
//  FengZi
//

//  Copyright (c) 2011年 ifengzi.cn. All rights reserved.
//

#import "BusCategory.h"

@implementation BusCategory

@synthesize channel=_channel;
@synthesize type=_type;
@synthesize bKma;

-(void)dealloc{
    [_type release];
    [super dealloc];
}

@end
