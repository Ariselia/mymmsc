//
//  RecommandViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface RecommandViewController : UIViewController<MFMessageComposeViewControllerDelegate>{
    IBOutlet UITableView *_tableview;
}

@end
