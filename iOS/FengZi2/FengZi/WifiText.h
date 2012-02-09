//
//  WifiText.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface WifiText : ITTBaseModelObject{	
	NSString* _name;
    
    NSString* _password;	
    
    //标示身份的id，用作记录传递
    NSString* _logId;	
}
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *logId;
@property (retain, nonatomic) NSString *password;



@end
