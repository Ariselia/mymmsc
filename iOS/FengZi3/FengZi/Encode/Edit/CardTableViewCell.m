//
//  CardTableViewCell.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell
@synthesize textField=_textField;
@synthesize nameField = _nameField;
@synthesize delegate=_delegate;
@synthesize indexPath=_indexPath;

+ (CardTableViewCell*)cellFromNib {
    
    UIViewController *cellController = [[UIViewController alloc] initWithNibName:@"CardTableViewCell" bundle:nil];
    CardTableViewCell *cell = (CardTableViewCell *)cellController.view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cellController release];
    
    return cell;
}

- (IBAction)editChanged:(id)sender {
    if (_delegate) {
        [_delegate editEnd:_textField.text key:[NSString stringWithFormat:@"%dfield",_indexPath.row]];
    }
}

- (IBAction)editBegin:(id)sender {
    if (_delegate) {
        [_delegate editBegin:_indexPath];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)editEnd:(id)sender {
    if (_delegate) {
        [_delegate editEnd:_textField.text key:[NSString stringWithFormat:@"%dfield",_indexPath.row]];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_delegate && [_delegate respondsToSelector:@selector(hideKeyBoard)]) {
        [_delegate hideKeyBoard];
    }
}

-(void)addPhoneButton:(UIButton*)btn{
    btn.frame = CGRectMake(275, 21, 30, 30);
    CGRect rect = _textField.frame;
    rect.size = CGSizeMake(rect.size.width-50, rect.size.height);
    _textField.frame = rect;
    rect = _inputBackView.frame;
    rect.size = CGSizeMake(rect.size.width-50, rect.size.height);
    _inputBackView.frame = rect;
    [self addSubview:btn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_indexPath.row > 12) {
        return NO;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(nextCellEdit:)]) {
        [_delegate nextCellEdit:_indexPath];
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_textField release];
    [_nameField release];
    [_inputBackView release];
    [super dealloc];
}
@end
