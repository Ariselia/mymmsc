//
//  Card.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface Card : ITTBaseModelObject{
    NSString* _name;
	
	NSString* _title;
	
	NSString* _department;
	
	NSString* _corporation;
	
	NSString* _cellphone;
	
	NSString* _telephone;
	
	NSString* _fax;
	
	NSString* _email;
	
	NSString* _url;
	
	NSString* _address;
	
	NSString* _zipCode;
	
	NSString* _qq;
	
	NSString* _msn;
	
	NSString* _weibo;
	
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *department;
@property (retain, nonatomic) NSString *corporation;
@property (retain, nonatomic) NSString *cellphone;
@property (retain, nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *fax;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *zipCode;
@property (retain, nonatomic) NSString *qq;
@property (retain, nonatomic) NSString *msn;
@property (retain, nonatomic) NSString *weibo;
@property (retain, nonatomic) NSString *logId;
@end
