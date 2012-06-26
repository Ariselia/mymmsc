//
//  UCMySpace.h
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "Api+UserCenter.h"

// 我的空间
@interface UCMySpace : UIViewController{
    //
    IBOutlet UIButton *sinaBtn;
    IBOutlet UIButton *qqBtn;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

-(IBAction)shareToSina:(id)sender;
-(IBAction)shareToQQ:(id)sender;
@end
