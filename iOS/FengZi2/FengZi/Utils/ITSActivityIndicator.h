//
//  ITSActivityIndicator.h
//  ZhiYue
//

//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ITSActivityIndicator : UIView {
    
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;

@property (nonatomic, retain) UIActivityIndicatorView *spinner;


+ (ITSActivityIndicator *)currentIndicator;

- (void)show;
- (void)hideAfterDelay:(CGFloat)delayTime;
- (void)hide;
- (void)hidden;
- (void)displayMessage:(NSString *)m;
- (void)displayActivity:(NSString *)m;
- (void)displayCompleted:(NSString *)m;
- (void)displayFailed:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;

@end
