//
//  MoreViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTDataRequest.h"
@interface MoreViewController : UIViewController<DataRequestDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *_tableview;
}

@end
