//
//  CustomTabbar.h
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTabbarDelegate;

@interface CustomTabbar : UIView

@property (nonatomic, assign) id<CustomTabbarDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *newsBtn;
@property (retain, nonatomic) IBOutlet UIButton *opinionBtn;
@property (retain, nonatomic) IBOutlet UIButton *audioVisualBtn;
@property (retain, nonatomic) IBOutlet UIButton *latestBtn;
@property (retain, nonatomic) IBOutlet UIButton *allBtn;

- (IBAction)tapOnDecodeBtn:(id)sender;
- (IBAction)tapOnEncodeBtn:(id)sender;
- (IBAction)tapOnFaviroteBtn:(id)sender;
- (IBAction)tapOnHistoryBtn:(id)sender;
- (IBAction)tapOnAllBtn:(id)sender;

- (void)selectTabAtIndex:(int)index;

@end

@protocol CustomTabbarDelegate <NSObject>

- (void)customTabbar:(CustomTabbar*)customTabbar didSelectTab:(int)tabIndex;

@end
