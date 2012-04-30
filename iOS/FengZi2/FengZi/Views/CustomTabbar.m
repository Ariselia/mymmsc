//
//  CustomTabbar.m
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import "CustomTabbar.h"

@implementation CustomTabbar

@synthesize delegate;
@synthesize newsBtn;
@synthesize opinionBtn;
@synthesize audioVisualBtn;
@synthesize latestBtn;
@synthesize allBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)selectTabAtIndex:(int)index
{
    if (index == 0) {
        newsBtn.selected = YES;
        opinionBtn.selected = NO;
        audioVisualBtn.selected = NO;
        latestBtn.selected = NO;
        allBtn.selected = NO;
//        newsBtn.userInteractionEnabled = NO;
//        opinionBtn.userInteractionEnabled=YES;
//        latestBtn.userInteractionEnabled=YES;
//        allBtn.userInteractionEnabled=YES;
//        audioVisualBtn.userInteractionEnabled=YES;
    }
    else if(index == 1)
    {
        newsBtn.selected = NO;
        opinionBtn.selected = YES;
        audioVisualBtn.selected = NO;
        latestBtn.selected = NO;
        allBtn.selected = NO;
//        newsBtn.userInteractionEnabled = YES;
//        opinionBtn.userInteractionEnabled=NO;
//        latestBtn.userInteractionEnabled=YES;
//        allBtn.userInteractionEnabled=YES;
//        audioVisualBtn.userInteractionEnabled=YES;
    }
    else if(index == 2)
    {
        newsBtn.selected = NO;
        opinionBtn.selected = NO;
        audioVisualBtn.selected = YES;
        latestBtn.selected = NO;
        allBtn.selected = NO;
//        newsBtn.userInteractionEnabled = YES;
//        opinionBtn.userInteractionEnabled=YES;
//        latestBtn.userInteractionEnabled=YES;
//        allBtn.userInteractionEnabled=YES;
//        audioVisualBtn.userInteractionEnabled=NO;
    }
    else if(index == 3)
    {        
        newsBtn.selected = NO;
        opinionBtn.selected = NO;
        audioVisualBtn.selected = NO;
        latestBtn.selected = YES;
        allBtn.selected = NO;
//        newsBtn.userInteractionEnabled = YES;
//        opinionBtn.userInteractionEnabled=YES;
//        latestBtn.userInteractionEnabled=NO;
//        allBtn.userInteractionEnabled=YES;
//        audioVisualBtn.userInteractionEnabled=YES;
    }
    else if(index == 4)
    {        
        newsBtn.selected = NO;
        opinionBtn.selected = NO;
        audioVisualBtn.selected = NO;
        latestBtn.selected = NO;
        allBtn.selected = YES;
//        newsBtn.userInteractionEnabled = YES;
//        opinionBtn.userInteractionEnabled=YES;
//        latestBtn.userInteractionEnabled=YES;
//        allBtn.userInteractionEnabled=NO;
//        audioVisualBtn.userInteractionEnabled=YES;
    }
}

- (IBAction)tapOnDecodeBtn:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        [delegate customTabbar:self didSelectTab:0];
    }
}

- (IBAction)tapOnEncodeBtn:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        [delegate customTabbar:self didSelectTab:1];
    }
}

- (IBAction)tapOnFaviroteBtn:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        [delegate customTabbar:self didSelectTab:2];
    }
}


- (IBAction)tapOnHistoryBtn:(id)sender{
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        [delegate customTabbar:self didSelectTab:3];
    }

}
- (IBAction)tapOnAllBtn:(id)sender{
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        [delegate customTabbar:self didSelectTab:4];
    }

}
- (void)dealloc {
    [newsBtn release];
    [opinionBtn release];
    [audioVisualBtn release];
    [latestBtn release];
    [allBtn release];
    [super dealloc];
}
@end
