//
//  UCBookReader.h
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCBookReader : UIViewController {
    UIButton           *_btnRight; // 导航条按钮
    UIImage            *_curImage;
    
    NSString   *subject;
    NSString   *bookContent;
    UILabel *content;
    UILabel    *page;
    int         pageCur;
    int         pageNum;
    int         words;
}

@property (nonatomic, retain) NSString *subject, *bookContent;
@property (nonatomic, retain) IBOutlet UILabel *content;
@property (nonatomic, retain) IBOutlet UILabel *page;
@property (nonatomic, retain) IBOutlet UIButton *front;
@property (nonatomic, retain) IBOutlet UIButton *next;

- (IBAction)goFront:(id)sender;
- (IBAction)goNext:(id)sender;

@end
