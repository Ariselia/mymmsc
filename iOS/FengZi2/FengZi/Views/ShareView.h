//
//  ShareView.h
//  FengZi
//
//  Created by lt ji on 11-12-20.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKItem.h"
@interface ShareView : UIActionSheet{
    SHKItem *_item;
    UIView *_mainView;
}

-(id)initWithItem:(SHKItem*)item;

@end
