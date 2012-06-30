//
//  BusCategory.h
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusCategory : NSObject{
    NSString *_type;	
	BOOL bKma;
	int _channel;
}
@property(nonatomic, copy)NSString *type;
@property(nonatomic, assign)int channel;
@property (nonatomic, assign) BOOL bKma;
@end
