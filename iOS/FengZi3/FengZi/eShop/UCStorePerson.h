//
//  UCStorePerson.h
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCStorePerson : UIViewController {
    UIImageView *person1;
    UIImageView *person2;
    UIImageView *person3;
    UIImageView *person4;
    UIImageView *person5;
    UIImageView *person6;
    UIImageView *person7;
    UIImageView *person8;
    
    UIButton           *_btnRight; // 导航条按钮
    UIImage            *_curImage;
    NSMutableArray     *items;
}

@property (nonatomic, retain) IBOutlet UIImageView *person1;
@property (nonatomic, retain) IBOutlet UIImageView *person2;
@property (nonatomic, retain) IBOutlet UIImageView *person3;
@property (nonatomic, retain) IBOutlet UIImageView *person4;
@property (nonatomic, retain) IBOutlet UIImageView *person5;
@property (nonatomic, retain) IBOutlet UIImageView *person6;
@property (nonatomic, retain) IBOutlet UIImageView *person7;
@property (nonatomic, retain) IBOutlet UIImageView *person8;

@end
