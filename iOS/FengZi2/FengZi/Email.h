//
//  Email.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface Email : ITTBaseModelObject{
    NSString* _mail;
	
	NSString* _title;
	
	NSString* _contente;	
	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *mail;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *contente;
@property (retain, nonatomic) NSString *logId;
@end
