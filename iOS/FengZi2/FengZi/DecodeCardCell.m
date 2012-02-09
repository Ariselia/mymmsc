//
//  DecodeCardCell.m
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "DecodeCardCell.h"

@implementation DecodeCardCell
@synthesize contentLabel = _contentLabel;
@synthesize moreButton = _moreButton;
@synthesize nameLabel=_nameLabel;
@synthesize delegate = _delegate;
+ (DecodeCardCell*)cellFromNib {
    
    UIViewController *cellController = [[UIViewController alloc] initWithNibName:@"DecodeCardCell" bundle:nil];
    DecodeCardCell *cell = (DecodeCardCell *)cellController.view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cellController release];
    
    return cell;
}
-(void)addPhoneButton:(UIButton*)btn withFavirote:(UIButton*)favrBtn{
    _nameLabel.hidden = YES;
    _moreButton.hidden = YES;
    _moreVIew.hidden = YES;
    btn.frame = CGRectMake(20, 21, 30, 30);
    [self addSubview:btn];
    
    favrBtn.frame = CGRectMake(275, 21, 30, 30);
    [self addSubview:favrBtn];
    
    CGRect rect = _contentLabel.frame;
    _contentLabel.font = [UIFont systemFontOfSize:20];
    _contentLabel.textAlignment = UITextAlignmentCenter;
    rect.origin = CGPointMake(rect.origin.x-10, rect.origin.y);
    _contentLabel.frame = rect;
}
-(void)initDataWithTitile:(NSString*)title withName:(NSString*)name withType:(LinkType)type{
    _nameLabel.text = title;
    _contentLabel.text = name;
    _type=type;
    if (!_contentLabel.text || [_contentLabel.text isEqualToString:@""] || _type == LinkTypeNone) {
        _moreButton.hidden = YES;
        _moreVIew.hidden = YES;
    }
    _popView = [[PopButtonsView viewFromNib] retain];
    _popView.frame = CGRectMake(320, 4, 140, 36);
    [self addSubview:_popView];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)moreDidClick:(id)sender {
    if (!_contentLabel.text || [_contentLabel.text isEqualToString:@""]) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(hidePopButton)]) {
        [_delegate hidePopButton];
    }
    [_popView initDataWithType:_type withText:_contentLabel.text];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_delegate && [_delegate respondsToSelector:@selector(hidePopButton)]) {
        [_delegate hidePopButton];
    }
}

-(void)removePopButton{
    if (_popView) {
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:@"pull" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _popView.frame = CGRectMake(320, 4, 140, 36);
        [UIView commitAnimations];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_popView release];
    [_nameLabel release];
    [_contentLabel release];
    [_moreButton release];
    [_moreVIew release];
    [super dealloc];
}
@end
