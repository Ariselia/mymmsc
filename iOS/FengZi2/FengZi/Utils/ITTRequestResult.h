//
//  HHRequestResult.h
//
//  Copyright 2010 Apple Inc. All rights reserved.
//
#import "Api+Category.h"

@interface ITTRequestResult : NSObject {
    NSNumber *_code;
    NSString *_message;
}
@property (nonatomic,retain) NSNumber *code;
@property (nonatomic,retain) NSString *message;
-(id)initWithCode:(NSString*)code withMessage:(NSString*)message;
-(BOOL)isSuccess;
-(void)showErrorMessage;
@end
