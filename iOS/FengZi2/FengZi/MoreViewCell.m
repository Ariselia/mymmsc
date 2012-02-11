//
//  MoreViewCell.m
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "MoreViewCell.h"

@implementation MoreViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (MoreViewCell*)cellFromNib {
    
    UIViewController *cellController = [[UIViewController alloc] initWithNibName:@"MoreViewCell" bundle:nil];
    MoreViewCell *cell = (MoreViewCell *)cellController.view;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cellController release];
    
    return cell;
}
-(void)initDataWithTitile:(NSString *)title withImage:(NSString *)image{
    _image.image = [UIImage imageNamed:image];
    _nameLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [super dealloc];
}
@end
