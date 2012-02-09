//
//  UIKitAddition.h
//  AiTuPianPad
//
// on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(add)
+ (UIView*)newHHStyleTextFieldViewWithFrame:(CGRect)frame
								   delegate:(id)delegate
									   text:(NSString*)t
								placeHolder:(NSString*)ph
								  textColor:(UIColor *)textColor
									   font:(UIFont *)font
							   keyboardType:(UIKeyboardType)keyboardType
										tag:(NSInteger)tag;

-(void)showIndicator:(BOOL)isShow 
          atPosition:(CGPoint)position;

-(void)showIndicatorWithMask:(BOOL)isShow 
                  atPosition:(CGPoint)position;

-(void)showHintAtPosition:(CGPoint)hintCenter
              textContent:(NSString*)text;

-(void)showHintAtPosition:(CGPoint)hintCenter 
               textContent:(NSString*)text
           timeToDisappear:(NSInteger)t;

-(void)removeSubviews;

-(void)adjustPositionToPixel;

-(void)adjustPositionToPixelByOrigin;

-(void)setRoundCornerWithRadius:(CGFloat)r;

-(void)setBorderWithWidth:(CGFloat)width
                     Color:(UIColor*)color;
@end

@interface UIDevice(add)
+ (BOOL)isHighResolutionDevice;
+ (UIInterfaceOrientation)currentOrientation;
@end

@interface UITextField(add)
+ (UITextField *)newTextFieldWithFrame:(CGRect)frame
						   borderStyle:(UITextBorderStyle)borderStyle
							 textColor:(UIColor *)textColor
					   backgroundColor:(UIColor *)backgroundColor
								  font:(UIFont *)font
						  keyboardType:(UIKeyboardType)keyboardType
								   tag:(NSInteger)tag;
@end

@interface UIButton(add)
+ (UIButton *)buttonWithType:(NSUInteger)type
					   title:(NSString *)title 
					   frame:(CGRect)frame
				   imageName:(NSString *)imageName
			 tappedImageName:(NSString *)tappedImageName
					  target:(id)target 
					  action:(SEL)selector 
						 tag:(NSInteger)tag;

+ (UIButton *)buttonWithType:(NSUInteger)type
					   title:(NSString *)title 
					fontSize:(UIFont *)size 
					   frame:(CGRect)frame
				   imageName:(NSString *)imageName
			 tappedImageName:(NSString *)tappedImageName
					  target:(id)target 
					  action:(SEL)selector 
						 tag:(NSInteger)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title 
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)imageName
                  tappedImage:(UIImage *)tappedImageName
                       target:(id)target 
                       action:(SEL)selector 
                          tag:(NSInteger)tag;
@end

@interface UILabel(add)
+ (UILabel *)newLabelWithFrame:(CGRect)frame
						  text:(NSString *)text
					 textColor:(UIColor *)textColor
						  font:(UIFont *)font
						   tag:(NSInteger)tag
					 hasShadow:(Boolean)hasShadow;

+ (UILabel *)navigationBarTitleLabelWithTitle:(NSString*)t;
@end

@interface UIAlertView(add)
+ (void) popupAlertByDelegate:(id)delegate Title:(NSString *)title Message:(NSString *)msg;
+ (void) popupAlertByDelegate:(id)delegate Title:(NSString *)title Message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;
@end