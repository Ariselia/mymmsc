//
//  ShareView.m
//  FengZi
//
//  Created by lt ji on 11-12-20.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ShareView.h"
#import "SHKMail.h"
#import "SHKSina.h"
#import "SHKTencent.h"
@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithItem:(SHKItem*)item{
    self = [super init];
    if (self) 
	{
         _item = [item retain];
		int btnnum = 200/50;
		for(int i=0; i<btnnum; i++)
		{
//			[self addButtonWithTitle:@" "];
		}
    }
    return self;
}

-(void)layoutSubviews{
    for (id did in self.subviews) {
        [did removeFromSuperview];
    }
    self.frame = CGRectMake(0, 195, 320, 220);
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    _mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:_mainView];
    
    UIButton *sina=[UIButton buttonWithType:UIButtonTypeCustom];
    sina.frame = CGRectMake(30, 15, 260, 44);
    [sina setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sina setBackgroundImage:[UIImage imageNamed:@"sharebtn.png"] forState:UIControlStateNormal];
    [sina setBackgroundImage:[UIImage imageNamed:@"sharebtn_tap.png"] forState:UIControlStateHighlighted];
    [sina addTarget:self action:@selector(sinaShare:) forControlEvents:UIControlEventTouchUpInside];
    [sina setTitle:@"新浪微博分享" forState:UIControlStateNormal];
    [_mainView addSubview:sina];
    UIButton *tencent=[UIButton buttonWithType:UIButtonTypeCustom];
    [tencent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tencent setBackgroundImage:[UIImage imageNamed:@"sharebtn.png"] forState:UIControlStateNormal];
    [tencent setBackgroundImage:[UIImage imageNamed:@"sharebtn_tap.png"] forState:UIControlStateHighlighted];
    tencent.frame = CGRectMake(30, 65, 260, 44);
    [tencent addTarget:self action:@selector(tencentShare:) forControlEvents:UIControlEventTouchUpInside];
    [tencent setTitle:@"腾讯微博分享" forState:UIControlStateNormal];
    [_mainView addSubview:tencent];
    UIButton *mail=[UIButton buttonWithType:UIButtonTypeCustom];
    [mail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mail setBackgroundImage:[UIImage imageNamed:@"sharebtn.png"] forState:UIControlStateNormal];
    [mail setBackgroundImage:[UIImage imageNamed:@"sharebtn_tap.png"] forState:UIControlStateHighlighted];
    mail.frame = CGRectMake(30, 115, 260, 44);
    [mail addTarget:self action:@selector(mailShare:) forControlEvents:UIControlEventTouchUpInside];
    [mail setTitle:@"邮件分享" forState:UIControlStateNormal];
    [_mainView addSubview:mail];
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
     [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage imageNamed:@"sharebtn.png"] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage imageNamed:@"sharebtn_tap.png"] forState:UIControlStateHighlighted];
    cancel.frame = CGRectMake(30, 165, 260, 44);
    [cancel addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_mainView addSubview:cancel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)sinaShare:(id)sender {
    [SHKSina shareItem:_item];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
- (IBAction)tencentShare:(id)sender {
    [SHKTencent shareItem:_item];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
- (IBAction)mailShare:(id)sender {
    [SHKMail shareItem:_item];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)cancelShare:(id)sender {
   [self dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)dealloc {
    [_mainView release];
    [super dealloc];
}
@end
