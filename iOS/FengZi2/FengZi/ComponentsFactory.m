//
//  ComponentsFactory.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ComponentsFactory.h"
#import "DataEnvironment.h"
#import "CONSTS.h"
#import "ITTImageView.h"
#import "UIUtil.h"
#import "NSStringAdditions.h"

@implementation ComponentsFactory

// Generate a button by the given parameters.

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title 
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                       target:(id)target 
                       action:(SEL)selector 
                          tag:(NSInteger)tag{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
	if( title!=nil && title.length>0 ){
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitleColor:titleColor forState:UIControlStateNormal];
		[button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
		button.titleLabel.font = titleFont;
	}
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.tag = tag;
	if( image){
		[button setBackgroundImage:image forState:UIControlStateNormal];
	}
	if( tappedImage){
		[button setBackgroundImage:tappedImage forState:UIControlStateHighlighted];
	}
	
	return button;
}

+ (UIButton *)buttonWithType:(NSUInteger)type
                       title:(NSString *)title 
                       frame:(CGRect)frame
                   imageName:(NSString *)imageName
             tappedImageName:(NSString *)tappedImageName
                      target:(id)target 
                      action:(SEL)selector 
                         tag:(NSInteger)tag{
	UIImage *image = (imageName && imageName.length > 0)?[UIImage imageNamed:[UIUtil imageName:imageName]]:nil;
	UIImage *tappedImage = (tappedImageName && tappedImageName.length > 0)?[UIImage imageNamed:[UIUtil imageName:tappedImageName]]:nil;
	return [ComponentsFactory buttonWithFrame:frame
                                        title:title 
                                   titleColor:[UIColor whiteColor]
                          titleHighlightColor:[UIColor blackColor]
                                    titleFont:[UIFont boldSystemFontOfSize:15]
                                        image:image
                                  tappedImage:tappedImage
                                       target:target 
                                       action:selector 
                                          tag:tag];
}

+ (UIButton *)buttonWithType:(NSUInteger)type
					   title:(NSString *)title 
					fontSize:(UIFont *)size 
					   frame:(CGRect)frame
				   imageName:(NSString *)imageName
			 tappedImageName:(NSString *)tappedImageName
					  target:(id)target 
					  action:(SEL)selector 
						 tag:(NSInteger)tag{
	UIImage *image = (imageName && imageName.length > 0)?[UIImage imageNamed:[UIUtil imageName:imageName]]:nil;
	UIImage *tappedImage = (tappedImageName && tappedImageName.length > 0)?[UIImage imageNamed:[UIUtil imageName:tappedImageName]]:nil;
	return [ComponentsFactory buttonWithFrame:frame
										title:title 
								   titleColor:[UIColor whiteColor]
						  titleHighlightColor:[UIColor whiteColor]
									titleFont:size
										image:image
								  tappedImage:tappedImage
									   target:target 
									   action:selector 
										  tag:tag];
}

// Generate a label by the given parameters.
+ (UILabel *)newLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
                           tag:(NSInteger)tag
                     hasShadow:(Boolean)hasShadow{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.textColor = textColor;
	label.backgroundColor = [UIColor clearColor];
	if( hasShadow ){
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(1,1);
	}
	label.textAlignment = UITextAlignmentLeft;
	label.font = font;
	label.tag = tag;
	
	return label;
}


+ (UITextField *)newTextFieldWithFrame:(CGRect)frame
                           borderStyle:(UITextBorderStyle)borderStyle
                             textColor:(UIColor *)textColor
                       backgroundColor:(UIColor *)backgroundColor
                                  font:(UIFont *)font
                          keyboardType:(UIKeyboardType)keyboardType
                                   tag:(NSInteger)tag{
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	textField.borderStyle = borderStyle;
	textField.textColor = textColor;
	textField.font = font;
	
	textField.backgroundColor = backgroundColor;
	textField.keyboardType = keyboardType;
	textField.tag = tag;
	
	textField.returnKeyType = UIReturnKeyDone;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.leftViewMode = UITextFieldViewModeUnlessEditing;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	return textField;
}

+ (UIView*)newHHStyleTextFieldViewWithFrame:(CGRect)frame
                                   delegate:(id)delegate
                                       text:(NSString*)t
                                placeHolder:(NSString*)ph
                                  textColor:(UIColor *)textColor
                                       font:(UIFont *)font
                               keyboardType:(UIKeyboardType)keyboardType
                                        tag:(NSInteger)tag
{
	frame.size.height = 30;
	UIImageView *fieldView = [[UIImageView alloc] initWithFrame:frame];
	fieldView.image =[[UIImage imageNamed:[UIUtil imageName:@"text_field_bg"]] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	fieldView.userInteractionEnabled = YES;
	UITextField *field = [ComponentsFactory newTextFieldWithFrame:CGRectMake(10,4,fieldView.frame.size.width - 10 ,23)
                                                      borderStyle:UITextBorderStyleNone
                                                        textColor:textColor
                                                  backgroundColor:[UIColor clearColor]
                                                             font:font
                                                     keyboardType:keyboardType
                                                              tag:tag];
	field.placeholder = ph;
	field.delegate = delegate;
	field.text = t;
	[fieldView addSubview:field];
	[field release];
	
	return fieldView;
}
+ (UILabel *)navigationBarTitleLabelWithTitle:(NSString*)t{
	UIFont *titleFont = [UIFont systemFontOfSize:22];
	CGSize titleSize = [t sizeWithFont:titleFont];
	UILabel *titleLbl = [[ComponentsFactory newLabelWithFrame:CGRectMake(120,0,titleSize.width,titleSize.height)
                                                         text:t
                                                    textColor:[UIColor whiteColor]
                                                         font:titleFont
                                                          tag:0
                                                    hasShadow:NO] autorelease];

	titleLbl.center = CGPointMake(160, 22);
	[UIUtil adjustPositionToPixelByOrigin:titleLbl];
	return titleLbl;
}


+ (UIBarButtonItem *)settingBarButtonItem:(id)target action:(SEL)selector
{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(0, 0, 100, 30);
    [settingBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:settingBtn] autorelease];
    return barButtonItem;
}

+ (UIBarButtonItem *)scanBarButtonItem:(id)target action:(SEL)selector
{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    scanBtn.frame = CGRectMake(0, 0, 100, 30);
    [scanBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:scanBtn] autorelease];
    return barButtonItem;
}

@end
