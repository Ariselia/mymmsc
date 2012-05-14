//
//  EggReward.h
//  FengZi
//
//  Created by a on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EggReward : UIViewController

{
    NSString *imgUrl;
    NSString *text;
}
@property (nonatomic, retain)  IBOutlet UILabel *content;
@property (nonatomic, retain)  IBOutlet UIImageView *imgView;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imgUrl;
@end
