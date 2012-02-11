//
//  MoreViewCell.h
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewCell : UITableViewCell{
    
    IBOutlet UIImageView *_image;
    IBOutlet UILabel *_nameLabel;
}
+ (MoreViewCell*)cellFromNib;
-(void)initDataWithTitile:(NSString*)title withImage:(NSString*)image;
@end
