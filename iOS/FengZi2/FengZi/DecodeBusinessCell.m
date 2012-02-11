//
//  DecodeBusinessCell.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "DecodeBusinessCell.h"
@implementation DecodeBusinessCell
@synthesize nameLabel=_nameLabel;
@synthesize textButton = _textButton;
@synthesize type=_type;
@synthesize delegate=_delegate;
@synthesize contentLabel=_contentLabel;
+ (DecodeBusinessCell*)cellFromNib {
    UIViewController *cellController = [[UIViewController alloc] initWithNibName:@"DecodeBusinessCell" bundle:nil];
    DecodeBusinessCell *cell = (DecodeBusinessCell *)cellController.view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cellController release];
    return cell;
}

- (NSString*)shortString:(NSString*)text
{
	if (text.length>24) {
        return [NSString stringWithFormat:@"%@...",[text substringToIndex:24]];
    }
    return text;
}

-(void)initDataWithTitile:(NSString*)title withText:(NSString*)text withType:(LinkType)type{
    _nameLabel.text = title;
    _type = type;
    if (type == LinkTypeTitle) {
        _moreBtn.hidden = YES;
        CGRect rect = _contentLabel.frame;
        rect.size.width+=30;
        _contentLabel.frame = rect;
    }
    if (text && ![text isEqualToString:@""]) {
        _contentLabel.text = text;
        if (_type == LinkTypeWeibo || _type==LinkTypeUrl || _type == LinkTypeAppUrl || _type == LinkTypeEmail|| _type == LinkTypeMap) {
            _moreBtn.hidden=YES;
            NSString *shortText = [self shortString:text];
            ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:shortText attributes: nil];
            [str addAttribute:ZUnderlineStyleAttributeName value:[NSNumber numberWithInt:ZUnderlineStyleSingle] range:NSMakeRange(0, shortText.length)];
            [str addAttribute:ZForegroundColorAttributeName value:[UIColor colorWithRed:0 green:102.0/255 blue:204.0/255 alpha:1] range:NSMakeRange(0, shortText.length)];
            _contentLabel.zAttributedText = str;
            [str release];
            _moreBtn.hidden=YES;
            CGRect rect = _contentLabel.frame;
            rect.size.width+=35;
            _contentLabel.frame = rect;
        } else if(_type == LinkTypePhone||_type == LinkTypeCardPhone){
            _contentLabel.textColor = [UIColor colorWithRed:85.0/255 green:144.0/255 blue:0 alpha:1];
        }else{
            _textButton.hidden=YES;
        }
    }else{
        _moreBtn.hidden = YES;
        _textButton.hidden=YES;
    }
    
    _popView = [[PopButtonsView viewFromNib] retain];
    _popView.delegate = self;
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
- (IBAction)textClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(hidePopButton)]) {
        [_delegate hidePopButton];
    }
    if (_type == LinkTypeMap || _type == LinkTypeWeibo || _type==LinkTypeUrl  || _type == LinkTypeAppUrl){
        NSString *url = _contentLabel.text;
        if ([url rangeOfString:@"://"].location == NSNotFound) {
            url = [NSString stringWithFormat:@"http://%@",url];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if(_type == LinkTypeEmail){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",_contentLabel.text]]];
    }else if (_type == LinkTypePhone||_type == LinkTypeCardPhone||_type == LinkTypeSms||_type == LinkTypeText||_type == LinkTypeEmailText) {
        [_popView initDataWithType:_type withText:_contentLabel.text];
    }
}

-(void)showMail{
    if (_delegate && [_delegate respondsToSelector:@selector(showMail)]) {
        [_delegate showMail];
    }
}
-(void)showSms{
    if (_delegate && [_delegate respondsToSelector:@selector(showSms)]) {
        [_delegate showSms];
    }
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
    [_textButton release];
    [_contentLabel release];
    [_moreBtn release];
    [super dealloc];
}
@end
