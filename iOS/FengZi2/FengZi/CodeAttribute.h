//
//  CodeAttribute.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeAttribute : NSObject{
    long _uuid;
	
	NSString *_type;
	
	int _color;
	
	int _size;
	
	int _height;
	
	int _width;
	
	int _hasLogo; //是否有logo
	
	int _hasBackGroud; //是否有皮肤
	
	NSString *_backGroudUrl;
	
	int _userid;
	
	int _utype;
	
	int _channel;
	
	int _madeIn;//是哪个平台生成的，0是PC，1是android，2是ios
}
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *backGroudUrl;
@property(nonatomic,assign)long uuid;
@property(nonatomic,assign)int color;
@property(nonatomic,assign)int size;
@property(nonatomic,assign)int height;
@property(nonatomic,assign)int width;
@property(nonatomic,assign)int hasLogo;
@property(nonatomic,assign)int hasBackGroud;
@property(nonatomic,assign)int userid;
@property(nonatomic,assign)int utype;
@property(nonatomic,assign)int channel;
@property(nonatomic,assign)int madeIn;

-(id)initWithCode:(NSString*)code;
-(NSString*)codeToString;
@end
