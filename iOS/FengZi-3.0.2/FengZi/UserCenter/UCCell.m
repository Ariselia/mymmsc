//
//  UCCell.m
//  FengZi
//
//  Created by a on 12-5-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UCCell.h"

@implementation UCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {  
    [super layoutSubviews];  
    
    float desiredWidth = 60;  
   
    
    self.imageView.frame = CGRectMake(10,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);  
    self.textLabel.frame = CGRectMake(80,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);  
    self.detailTextLabel.frame = CGRectMake(80,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);  
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;  
} 
@end
