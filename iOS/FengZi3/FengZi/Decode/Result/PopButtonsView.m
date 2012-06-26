//
//  PopButtonsView.m
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "PopButtonsView.h"
#import "CommonUtils.h"
@implementation PopButtonsView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (PopButtonsView*)viewFromNib{
    UIViewController *cellController = [[UIViewController alloc] initWithNibName:@"PopButtonsView" bundle:nil];
    PopButtonsView *cell = (PopButtonsView *)cellController.view;
    [cellController release];
    return cell;
}
-(void)initDataWithType:(LinkType)type withText:(NSString*)text{
    _content = [text retain];
    self.frame = CGRectMake(320, 4, 140, 36);
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:@"pull" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _type=type;
    int width;
    int offsetx;
    switch (type) {
        case LinkTypeCompany:
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _searchBtn.center = CGPointMake(offsetx, 18);
            break;
        case LinkTypeEmail:
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _emailBtn.center = CGPointMake(offsetx, 18);
            break;
        case LinkTypeEmailText:
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _emailBtn.center = CGPointMake(offsetx, 18);
            break;
        case LinkTypeMap:
            width = 120;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"decode_popbtn2_bg.png"];
            _locationBtn.center = CGPointMake(offsetx, 18);
            _searchBtn.center = CGPointMake(offsetx*3, 18);
            break;
        case LinkTypeCardPhone:{
            width = 120;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"decode_popbtn2_bg.png"];
            _dialBtn.center = CGPointMake(offsetx, 18);
            _smsBtn.center = CGPointMake(offsetx*3, 18);
            break;
        }
        case LinkTypePhone:{
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _dialBtn.center = CGPointMake(offsetx, 18);
            break;
        }
        case LinkTypeSms:{
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _smsBtn.center = CGPointMake(offsetx, 18);
            break;
        }
        case LinkTypeText:
            width = 120;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"decode_popbtn2_bg.png"];
            _smsBtn.center = CGPointMake(offsetx*3, 18);
            _emailBtn.center = CGPointMake(offsetx, 18);
            break;
        case LinkTypeUrl:
            width = 120;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"decode_popbtn2_bg.png"];
            _netWorkBtn.center = CGPointMake(offsetx, 18);
            _favBtn.center = CGPointMake(offsetx*3, 18);
            break;
        case LinkTypeWeibo:
            width = 60;
            offsetx = 30;
            self.frame = CGRectMake(self.superview.width-10-width, 4, width, 36);
            _backImageView.frame = self.bounds;
            _backImageView.image = [UIImage imageNamed:@"pop_button1_bg.png"];
            _weiboBtn.center = CGPointMake(offsetx, 18);
            break;
            
            break;
        default:
            break;
    }
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)dialClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_content]]];
}
- (IBAction)emailClick:(id)sender {
    if (_type == LinkTypeText||_type==LinkTypeEmailText) {
        if (_delegate && [_delegate respondsToSelector:@selector(showMail)]) {
            [_delegate showMail];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",_content]]];
    }
}
- (IBAction)locationClick:(id)sender {
    NSString *key = [CommonUtils encodeURL:_content];
    NSString* urlText = [NSString stringWithFormat:DEFAULT_MAP_SEARCH, key];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
- (IBAction)netWorkClick:(id)sender {
    NSString *key = _content;
    if ([_content rangeOfString:@"http://"].location == NSNotFound) {
        key = [NSString stringWithFormat:@"http://%@",_content];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:key]]; 
}
- (IBAction)smsClick:(id)sender {
    if (_type == LinkTypeSms||_type == LinkTypeText) {
        if (_delegate && [_delegate respondsToSelector:@selector(showSms)]) {
            [_delegate showSms];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_content]]];
    }
}
- (IBAction)searchClick:(id)sender {
    NSString *key = [CommonUtils encodeURL:_content];
    NSString* urlText = [NSString stringWithFormat:DEFAULT_SEARCH, key];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]]; 
}
- (IBAction)weiboClick:(id)sender {
    NSString *key = _content;
    if ([_content rangeOfString:@"://"].location == NSNotFound) {
        key = [NSString stringWithFormat:@"http://%@",_content];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:key]];
}
- (IBAction)_favClick:(id)sender {
    
}

- (void)dealloc {
    [_content release];
    [_delegate release];
    [_backImageView release];
    [_dialBtn release];
    [_emailBtn release];
    [_locationBtn release];
    [_netWorkBtn release];
    [_searchBtn release];
    [_smsBtn release];
    [_weiboBtn release];
    [_favBtn release];
    [super dealloc];
}
@end
