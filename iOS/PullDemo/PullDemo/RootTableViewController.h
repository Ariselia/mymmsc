//
//  RootTableViewController.h
//  PullDemo
//
//  Created by  on 11-11-24.
//  Copyright (c) 2011年 watsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRefreshTableView.h"

@interface RootTableViewController : UITableViewController<iOSRefreshTableViewDelegate>
{
    NSMutableArray       *_array;
    iOSRefreshTableView  *_refreshView;
}

@property (nonatomic,retain) NSMutableArray *array;

@end
