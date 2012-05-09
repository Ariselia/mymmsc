//
//  EBAdBar.h
//  FengZi
//
//  Created by wangfeng on 12-3-23.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

//
// 广告条
//

#import <iOSApi/iOSImageView.h>
#import <iOSApi/UIImageView+Utils.h>

@interface EBAdBar : UITableViewCell{
    NSTimer *_timer;
    NSMutableArray *_items;
    int             _number;
}

@property (nonatomic, assign) id ownerId;
@property (nonatomic, retain) IBOutlet iOSImageView *pic;

@end
