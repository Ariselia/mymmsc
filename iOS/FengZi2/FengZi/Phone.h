//
//  Phone.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface Phone : ITTBaseModelObject{
    NSString* _telephone;
	
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *logId;
@end
