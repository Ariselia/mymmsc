//
//  UITableViewCellExt.m
//  FengZi
//
//  Created by a on 12-4-18.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UITableViewCellExt.h"

@implementation UITableViewCell (UITableViewCellExt)


- (void)layout {  
    [super layoutSubviews];  
       
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,100,self.imageView.frame.size.height);  
       
    
}  

- (void)setBackgroundImage:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    self.backgroundView = imageView;
    [imageView release];
    
}


- (void)setBackgroundImageByName:(NSString*)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName]];
}


@end
