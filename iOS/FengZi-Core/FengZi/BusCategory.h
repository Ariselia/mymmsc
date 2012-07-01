//
//  BusCategory.h
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import "Api+Category.h"

@interface BusCategory : NSObject{
    NSString     *_type;	
	int           _channel;
    BusinessType  _codeType;
    BOOL          bKma;
}

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) int channel;
@property (nonatomic, assign) BusinessType codeType;
@property (nonatomic, assign) BOOL bKma;

@end
