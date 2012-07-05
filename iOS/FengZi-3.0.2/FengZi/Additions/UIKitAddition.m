//
//  UIKitAddition.m
//  AiTuPianPad
//
// on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIKitAddition.h"
#import "CONSTS.h"
#import "NSStringAdditions.h"

@implementation UIView(add)
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

-(void)showIndicatorWithMask:(BOOL)isShow 
                  atPosition:(CGPoint)position{
	UIView *indicatorView = (UIView*)[self viewWithTag:kTagWindowIndicatorView];
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:kTagWindowIndicator];
	if (indicatorView == nil) {
		indicatorView = [[UIView alloc] initWithFrame:[self bounds]];
		indicatorView.backgroundColor = RGBACOLOR(100,100,100,0.7);
		indicatorView.tag = kTagWindowIndicatorView;
		[self addSubview:indicatorView];
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicator.frame = CGRectMake(position.x, position.y, 30, 30);
		indicator.tag = kTagWindowIndicator;
		[indicatorView addSubview:indicator];
		[indicator release];
		[indicatorView release];
	}
	if (isShow) {
		[indicatorView setHidden:NO];
		[indicator startAnimating];
		[self bringSubviewToFront:indicatorView];
	}else {
		[indicatorView setHidden:YES];
		[indicator stopAnimating];
		[self sendSubviewToBack:indicatorView];
	}
}

-(void)showIndicator:(BOOL)isShow 
          atPosition:(CGPoint)position{
	UIView *indicatorView = (UIView*)[self viewWithTag:kTagWindowIndicatorView];
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:kTagWindowIndicator];
	if (indicatorView == nil) {
		indicatorView = [[UIView alloc] initWithFrame:CGRectMake(position.x, position.y, 20, 20)];
		indicatorView.backgroundColor = [UIColor clearColor];
        
		indicatorView.tag = kTagWindowIndicatorView;
		[self addSubview:indicatorView];
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		indicator.frame = CGRectMake(0, 0, 20, 20);
		indicator.tag = kTagWindowIndicator;
		[indicatorView addSubview:indicator];
		[indicator release];
		[indicatorView release];
	}
	if (isShow) {
		[indicatorView setHidden:NO];
		[indicator startAnimating];
		[self bringSubviewToFront:indicatorView];
	}else {
		[indicatorView setHidden:YES];
		[indicator stopAnimating];
		[self sendSubviewToBack:indicatorView];
	}
}

-(void)removeSubviews{
	for( UIView* view in self.subviews ){
		[view removeFromSuperview];
	}
}

-(void)showHintAtPosition:(CGPoint)hintCenter
              textContent:(NSString*)text{
	[self showHintAtPosition:hintCenter 
                 textContent:text
             timeToDisappear:2];
}
-(void)showHintAtPosition:(CGPoint)hintCenter 
              textContent:(NSString*)text
          timeToDisappear:(NSInteger)t{
	UIView *hintView = [self viewWithTag:kTagHintView];
	UIFont *textFont = [UIFont systemFontOfSize:18];
	CGFloat maxWidth = 255;
	int textLines = [text numberOfLinesWithFont:textFont
                                  withLineWidth:maxWidth];
	CGFloat textHeight = [text heightWithFont:textFont
                                withLineWidth:maxWidth];
	int hintLblTag = 1;
	UILabel *hintLbl;
	if( !hintView ){
		hintView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 256, 64)] autorelease];
		hintView.center = hintCenter;
		hintView.backgroundColor = [UIColor clearColor]; 
		hintView.tag = kTagHintView;
		[self addSubview:hintView];

		UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:hintView.bounds];
		frameImageView.image = [[UIImage imageNamed:@"alert_frameImg_light.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
		frameImageView.frame = hintView.bounds;		
		[hintView addSubview:frameImageView];
		[frameImageView release];
		
		hintLbl = [ComponentsFactory newLabelWithFrame:CGRectMake(0, 0, maxWidth, textHeight)
                                                  text:text
                                             textColor:[UIColor whiteColor]
                                                  font:textFont
                                                   tag:hintLblTag
                                             hasShadow:NO];
		hintLbl.numberOfLines = textLines;
		hintLbl.center = CGPointMake(134.0,32.0);
		[hintLbl sizeToFit];
		[hintView addSubview:hintLbl];
		[hintLbl release];
	}else {
		hintLbl = (UILabel*)[hintView viewWithTag:hintLblTag];
		hintLbl.text = text;
		hintLbl.numberOfLines = textLines;
		[hintLbl sizeToFit];
	}
	hintLbl.left = round(hintLbl.left);
	hintLbl.top = round(hintLbl.top);
	
	CATransform3D transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
	hintView.layer.transform = transform;
	hintView.alpha = 0;
	transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	hintView.layer.transform = transform;
	hintView.alpha = 1;
	[UIView commitAnimations];
	
	if (t > 0) {
		transform = CATransform3DMakeScale(0.001, 0.001, 0.001);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:t];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		hintView.layer.transform = transform;
		hintView.alpha = 0;
		[UIView commitAnimations];
	}
}

-(void)adjustPositionToPixel{
	self.center = CGPointMake(round(self.center.x), round(self.center.y));
}

-(void)adjustPositionToPixelByOrigin{
	self.left = round(self.left);
    self.top = round(self.top);
}

-(void)setRoundCornerWithRadius:(CGFloat)r{
    self.layer.cornerRadius = r;
    [self setNeedsDisplay];
}

-(void)setBorderWithWidth:(CGFloat)width
                     Color:(UIColor*)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self setNeedsDisplay];
}
@end

@implementation UITextField(add)
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
@end

@implementation UIButton(add)
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
@end

@implementation UILabel(add)
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

+ (UILabel *)navigationBarTitleLabelWithTitle:(NSString*)t{
	UIFont *titleFont = [UIFont systemFontOfSize:22];
	CGSize titleSize = [t sizeWithFont:titleFont];
	UILabel *titleLbl = [[self newLabelWithFrame:CGRectMake(120,0,titleSize.width,titleSize.height)
                                                         text:t
                                                    textColor:[UIColor whiteColor]
                                                         font:titleFont
                                                          tag:0
                                                    hasShadow:NO] autorelease];
    
	titleLbl.center = CGPointMake(160, 22);
	[UIUtil adjustPositionToPixelByOrigin:titleLbl];
	return titleLbl;
}
@end

@implementation UIDevice(add)
+(BOOL)isHighResolutionDevice {
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0) {
		UIScreen *mainScreen = [UIScreen mainScreen];
		if( mainScreen.scale>1 ){
            return TRUE;
		}
	}
	return FALSE;
}

+ (UIInterfaceOrientation)currentOrientation{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
@end

@implementation UIAlertView(add)
+ (void) popupAlertByDelegate:(id)delegate Title:(NSString *)title Message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

+ (void) popupAlertByDelegate:(id)delegate Title:(NSString *)title Message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil] autorelease];
    [alert show];	
}
@end