//
//  SettingViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UISwitch *_flashLightSwitch;
    IBOutlet UISwitch *_decodeMusicSwitch;
    IBOutlet UISwitch *_locationSwitch;
}

@end
