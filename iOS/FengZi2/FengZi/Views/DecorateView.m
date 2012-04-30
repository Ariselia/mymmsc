//
//  DecorateView.m
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "DecorateView.h"

@implementation DecorateView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)getColorArray{
    for (int i=0; i<8; i++) {
        [_contentArray addObject:[DATA_ENV getColorWithIndex:i]];
    }
}

-(void)getSkinArray{
    [_contentArray addObjectsFromArray:[DATA_ENV getSkinThumbnail]];
}

-(void)getIconArray{
    [_contentArray addObjectsFromArray:[DATA_ENV getIconImage]];
}


-(void)initColorScrollView{
    int offsetX = 10;
    for (UIColor *color in _contentArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (offsetX/60 == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"color_frame.png"] forState:UIControlStateNormal];
        }
        
        btn.frame = CGRectMake(offsetX, 5, 45, 45);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"color%d.png",offsetX/60]] forState:UIControlStateNormal];
        btn.tag = 3000+offsetX/60;
        [btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        offsetX+=60;
    }
    [_scrollView setContentSize:CGSizeMake(offsetX, _scrollView.bounds.size.height)];
}

-(void)initSkinScrollView{
    int offsetX = 10;
    for (UIImage *image in _contentArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (offsetX/40 == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"skin_frame.png"] forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(offsetX, 5, 30, 46);
        [btn setImage:image forState:UIControlStateNormal];
        btn.tag = 3000+offsetX/40;
        [btn addTarget:self action:@selector(selectSkin:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        offsetX+=40;
    }
    [_scrollView setContentSize:CGSizeMake(offsetX, _scrollView.bounds.size.height)];
}

-(void)initIconScrollView{
    int offsetX = 10;
    UIImage *bgImage = [_contentArray objectAtIndex:0];
    for (UIImage *image in _contentArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offsetX, 5, 45, 45);
        [btn setImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        btn.tag = 3000+offsetX/60;
        [btn addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        offsetX+=60;
    }
    [_scrollView setContentSize:CGSizeMake(offsetX, _scrollView.bounds.size.height)];
}

-(void)initDataWithType:(EditImageType)Type{
    [_scrollView removeAllSubviews];
    if (_contentArray) {
        [_contentArray removeAllObjects];
    }else{
        _contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    switch (Type) {
        case EditImageTypeSkin:
            _backGroundView.image = [UIImage imageNamed:@"skin_bg.png"];
            [self getSkinArray];
            [self initSkinScrollView];
            break;
        case EditImageTypeIcon:
            _backGroundView.image = [UIImage imageNamed:@"icon_bg.png"];
            [self getIconArray];
            [self initIconScrollView];
            break;
        case EditImageTypeColor:
            _backGroundView.image = [UIImage imageNamed:@"color_bg.png"];
            [self getColorArray];
            [self initColorScrollView];
            break;
        default:
            break;
    }
    if (Type>0) {
        CGRect rect = _scrollView.frame;
        rect.origin.y = 0;
        _scrollView.frame = rect;
    }
}

-(void)selectIcon:(UIButton*)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(iconSelected:)]) {
        int index = sender.tag-3000;
        if (index == 0) {
            [_delegate iconSelected:nil];
        }else{
            [_delegate iconSelected:[_contentArray objectAtIndex:index]];
        }
    }
}

-(void)selectSkin:(UIButton*)sender{
    for (int i =0; i<[_contentArray count]; i++) {
        UIButton *b = (UIButton*)[self viewWithTag:3000+i];
        [b setBackgroundImage:nil forState:UIControlStateNormal];
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"skin_frame.png"] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(imageSelected:)]) {
        int index = sender.tag-3000;
        [_delegate imageSelected:index];
    }
}

-(void)selectColor:(UIButton*)sender{
    for (int i =0; i<[_contentArray count]; i++) {
        UIButton *b = (UIButton*)[self viewWithTag:3000+i];
        [b setBackgroundImage:nil forState:UIControlStateNormal];
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"color_frame.png"] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(colorSelect:withIndex:)]) {
        [_delegate colorSelect:[_contentArray objectAtIndex:sender.tag-3000] withIndex:sender.tag-3000];
    }
}

- (void)dealloc {
    [_contentArray release];
    [_scrollView release];
    [_backGroundView release];
    [super dealloc];
}
@end
