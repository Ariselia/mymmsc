//
//  HistoryObject.m
//  FengZi
//
//  Created by lt ji on 11-12-13.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "HistoryObject.h"

@implementation HistoryObject
@synthesize uuid=_uuid;
@synthesize type=_type;
@synthesize content=_content;
@synthesize image=_image;
@synthesize date=_date;
@synthesize isEncode=_isEncode;

-(void)dealloc{
    [_content release];
    [_image release];
    [_date release];
    [super dealloc];
}
@end
