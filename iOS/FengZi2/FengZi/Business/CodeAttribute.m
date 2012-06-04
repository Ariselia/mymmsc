//
//  CodeAttribute.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "CodeAttribute.h"

@implementation CodeAttribute
@synthesize backGroudUrl=_backGroudUrl;
@synthesize type=_type;
@synthesize height=_height;
@synthesize width=_width;
@synthesize hasLogo=_hasLogo;
@synthesize hasBackGroud=_hasBackGroud;
@synthesize size=_size;
@synthesize uuid=_uuid;
@synthesize color=_color;
@synthesize utype=_utype;
@synthesize madeIn=_madeIn;
@synthesize channel=_channel;
@synthesize userid=_userid;     

-(id)init{
    self = [super init];
    if (self) {
        _hasLogo = DATA_ENV.encodeImageType;
        _width = 156;
        _height = 156;
        _size = 4;
        _madeIn = 2;
    }
    return self;
}

- (id)initWithCode:(NSString*)code{
    self = [super init];
    if (self) {
        if(code == nil){
            return self;
        }
        
        NSArray *attArr = [code componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *attMap = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];		
        
        for(NSString *attStr in attArr){
            NSArray *keyValueStr = [attStr componentsSeparatedByString:@"="];
            if([keyValueStr count]==2){
                [attMap setObject:[keyValueStr objectAtIndex:1] forKey:[keyValueStr objectAtIndex:0]];
            }			
        }
        
        NSString *idIn = [attMap objectForKey:@"id"];
        if(idIn != nil && idIn.length > 0){
            _uuid = [idIn longLongValue];
        }
        
        NSString *typeIn = [attMap objectForKey:@"t"];
        if(typeIn != nil && typeIn.length > 0){
            _type = typeIn;
        }
        
        
        NSString *colorIn = [attMap objectForKey:@"c"];
        if(colorIn != nil && colorIn.length > 0){
            _color = [colorIn intValue];
        }
        
        NSString *sizeIn = [attMap objectForKey:@"s"];
        if(sizeIn != nil && sizeIn.length > 0){
            _size = [sizeIn intValue];
        }
        
        NSString *heightIn = [attMap objectForKey:@"h"];
        if(heightIn != nil && heightIn.length > 0){
            _height = [heightIn intValue];
        }
        
        NSString *widthIn = [attMap objectForKey:@"w"];
        if(widthIn != nil && widthIn.length > 0){
            _width = [widthIn intValue];
        }
        
        NSString *hasLogoIn = [attMap objectForKey:@"l"];
        if(hasLogoIn != nil && hasLogoIn.length > 0){
            _hasLogo = [hasLogoIn intValue];
        }
        
        NSString *hasBackGroudIn = [attMap objectForKey:@"bg"];
        if(hasBackGroudIn != nil && hasBackGroudIn.length > 0){
            _hasBackGroud = [hasBackGroudIn intValue];
        }
        
        NSString *backGroudUrlIn = [attMap objectForKey:@"bgUrl"];
        if(backGroudUrlIn != nil && backGroudUrlIn.length > 0){
            _backGroudUrl = backGroudUrlIn;
        }
        
        NSString *userIdIn = [attMap objectForKey:@"uid"];
        if(userIdIn != nil && userIdIn.length > 0){
            _userid = [userIdIn intValue];
        }
        
        NSString *utypeIn = [attMap objectForKey:@"utype"];
        if(utypeIn != nil && utypeIn.length > 0){
            _utype = [utypeIn intValue];
        }
        
        NSString *channelIn = [attMap objectForKey:@"ch"];
        if(channelIn != nil && channelIn.length > 0){
            _channel = [channelIn intValue];
        }
        
        NSString *madeInIn = [attMap objectForKey:@"mIn"];
        if(madeInIn != nil && madeInIn.length > 0){
            _madeIn = [madeInIn intValue];
        }
    }
    return self;
}

- (NSString *)codeToString{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    [buffer appendString:@"id="];
    [buffer appendFormat:@"%l",_uuid];
    [buffer appendString:@"&"];
    
    if(_type != nil && _type.length > 0){
        [buffer appendString:@"t="];
        [buffer appendString:_type];
        [buffer appendString:@"&"];
    }
    
    if(_color  > 0){
        [buffer appendString:@"c="];
        [buffer appendFormat:@"%d",_color];
        [buffer appendString:@"&"];
    }
    
    if(_size > 0){
        [buffer appendString:@"s="];
        [buffer appendFormat:@"%d",_size];
        [buffer appendString:@"&"];
    }
    
    if(_height > 0){
        [buffer appendString:@"h="];
        [buffer appendFormat:@"%d",_height];
        [buffer appendString:@"&"];
    }
    
    if(_width > 0){
        [buffer appendString:@"w="];
        [buffer appendFormat:@"%d",_width];
        [buffer appendString:@"&"];
    }
    
    [buffer appendString:@"l="];
    [buffer appendFormat:@"%d",_hasLogo];
    [buffer appendString:@"&"];
    
    [buffer appendString:@"bg="];
    [buffer appendFormat:@"%d",_hasBackGroud];
    [buffer appendString:@"&"];
    
    if(_backGroudUrl != nil && _backGroudUrl.length > 0){
        [buffer appendString:@"bgUrl="];
        [buffer appendString:_backGroudUrl];
        [buffer appendString:@"&"];
    }
    
    [buffer appendString:@"uid="];
    [buffer appendFormat:@"%d",_userid];
    [buffer appendString:@"&"];
    
    [buffer appendString:@"utype="];
    [buffer appendFormat:@"%d",_utype];
    [buffer appendString:@"&"];
    
    [buffer appendString:@"ch="];
    [buffer appendFormat:@"%d",_channel];
    [buffer appendString:@"&"];
    
    [buffer appendString:@"mIn="];
    [buffer appendFormat:@"%d",_madeIn];
    
    return buffer;
}
-(void)dealloc{
    [_type release];
    [_backGroudUrl release];
    [super dealloc];
}
@end
