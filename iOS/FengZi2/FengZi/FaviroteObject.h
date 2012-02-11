//
//  FaviroteObject.h
//  FengZi
//
//  Created by lt ji on 11-12-13.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaviroteObject : NSObject{
    int _uuid;
    NSString *_content;
    NSString *_image;
    NSString *_date;
    BusinessType _type;
}

@property (nonatomic,retain) NSString *image;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,assign) int uuid;
@property (nonatomic,assign) BusinessType type;
@end
