//
//  ComponentsFactory.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComponentsFactory: NSObject

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

+ (UILabel *)newLabelWithFrame:(CGRect)frame
						  text:(NSString *)text
					 textColor:(UIColor *)textColor
						  font:(UIFont *)font
						   tag:(NSInteger)tag
					 hasShadow:(Boolean)hasShadow;

+ (UITextField *)newTextFieldWithFrame:(CGRect)frame
						   borderStyle:(UITextBorderStyle)borderStyle
							 textColor:(UIColor *)textColor
					   backgroundColor:(UIColor *)backgroundColor
								  font:(UIFont *)font
						  keyboardType:(UIKeyboardType)keyboardType
								   tag:(NSInteger)tag;
+ (UIView*)newHHStyleTextFieldViewWithFrame:(CGRect)frame
								   delegate:(id)delegate
									   text:(NSString*)t
								placeHolder:(NSString*)ph
								  textColor:(UIColor *)textColor
									   font:(UIFont *)font
							   keyboardType:(UIKeyboardType)keyboardType
										tag:(NSInteger)tag;
+ (UILabel *)navigationBarTitleLabelWithTitle:(NSString*)t;


+ (UIBarButtonItem *)settingBarButtonItem:(id)target action:(SEL)selector;

+ (UIBarButtonItem *)scanBarButtonItem:(id)target action:(SEL)selector;


@end