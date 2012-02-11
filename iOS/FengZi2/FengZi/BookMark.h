//
//  BookMark.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface BookMark : ITTBaseModelObject{
    NSString *_title;
	
	NSString *_url;	
	
	NSString *_logId;	
}

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *logId;
@end
