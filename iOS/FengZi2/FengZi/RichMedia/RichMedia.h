//
//  RichMedia.h
//  FengZi
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Api+Category.h"

// 富媒体, 生码只对纯URL进行编码
@interface RichMedia : ITTBaseModelObject {
    NSString *_title; // 标题
    NSString *_content; // 内容
    NSString *_url; // 服务器返回的url
    int       _type; // 媒体类型
	
	//标示身份的id，用作记录传递
	NSString *_logId;
}
@property (nonatomic, assign) int type;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *logId;
@property (nonatomic, retain) NSString *url;

@end
