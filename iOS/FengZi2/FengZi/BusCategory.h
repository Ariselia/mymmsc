//
//  BusCategory.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusCategory : NSObject{
    NSString *_type;	
	
	int _channel;
}
@property(nonatomic, retain)NSString *type;
@property(nonatomic, assign)int channel;

@end
