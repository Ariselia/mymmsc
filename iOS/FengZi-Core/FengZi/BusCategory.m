//
//  BusCategory.m
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import "BusCategory.h"

@implementation BusCategory
@synthesize channel = _channel;
@synthesize type = _type;
@synthesize bKma;
@synthesize codeType = _codeType;

-(void)dealloc{
    [_type release];
    [super dealloc];
}
@end
