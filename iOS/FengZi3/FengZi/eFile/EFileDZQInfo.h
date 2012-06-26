//
//  EFileHYKInfo.h
//  FengZi
//
//  Created by a on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+eFile.h"
@interface EFileDZQInfo : UIViewController
{
    EFileCardList *param;
}

@property (nonatomic, retain)  IBOutlet UILabel *u_name;
@property (nonatomic, retain)  IBOutlet UILabel *u_serialNum;
@property (nonatomic, retain)  IBOutlet UILabel *u_num;
@property (nonatomic, retain)  IBOutlet UILabel *u_usetime;
@property (nonatomic, retain)  IBOutlet UIImageView *u_pic;
@property (nonatomic, retain)  IBOutlet UIImageView *u_codepic;
@property (nonatomic, retain)  IBOutlet UILabel *u_content;
@property (nonatomic, retain)  IBOutlet UILabel *u_code;
@property (nonatomic, retain) EFileCardList *param;


@end
