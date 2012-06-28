//
//  BusDecoder.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "BusDecoder.h"
#import "EncryptTools.h"
#import <objc/runtime.h>
#import "Api.h"
#define FENGZI_URL @"http://ifengzi.cn/show.cgi?"
#define SEPERATOR_PRE @":"
#define SEPERATOR_POST @";"
#define API_CODE_PREFIX @"http://ifengzi.cn/show.cgi?"
@implementation BusDecoder
static NSString *URL_FLAG = @"://"; 

//  需要对输入的：和；进行特殊转码

/**
 * 将冒号和分号分隔的字符串变成一个map对象
 */
//普通二维码解码
/**
 * 将冒号和分号分隔的字符串变成一个map对象
 */
+(NSArray *)parseList:(NSString *)input{
    NSMutableArray *list = nil;
    if(input != nil){
        list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        int preFlagPos = 0;
        NSMutableString *sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
        for(int i = 0; i < input.length; i ++){
            NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
            NSString *d = nil;
            if (i + 1 < input.length) {
                d = [input substringWithRange:NSMakeRange(i + 1, 1)];
            }
            if(![c isEqualToString:SEPERATOR_PRE]&& ![c isEqualToString:SEPERATOR_POST]){
                [sb appendString:[NSString stringWithFormat:@"%@",c]];
            } else if (d != nil && [c isEqualToString:SEPERATOR_PRE] && [d isEqualToString:SEPERATOR_POST]) {
                [list addObject:@""];
                preFlagPos = 0;
            } else {
                if([c isEqualToString:SEPERATOR_PRE]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        //preFlagPos = i - 1;
                    }else{
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        if(preFlagPos != 0){
                            [sb deleteCharactersInRange:NSMakeRange(0, preFlagPos + 1)];//删掉不对应的：
                        }
                        preFlagPos = sb.length - 1; //对应到位置
                    }					
                }
                
                if([c isEqualToString:SEPERATOR_POST]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    }else{
                        if(preFlagPos != 0){
                            //[result setObject:[sb substringFromIndex:preFlagPos+1] forKey:key];
                            [list addObject:[sb substringFromIndex:preFlagPos+1]];
                        }
                        
                        [sb deleteCharactersInRange:NSMakeRange(0, sb.length)];//清掉内容
                        preFlagPos = 0;
                    }					
                }
            }
        }
    }
    return list;
    
}

+ (NSDictionary *)parse0:(NSString *)input{
    NSMutableDictionary *list = nil;
    if(input != nil){
        list = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
        int preFlagPos = 0;
        NSMutableString *sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
        for(int i = 0; i < input.length; i ++){
            NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
            NSString *d = nil;
            if (i + 1 < input.length) {
                d = [input substringWithRange:NSMakeRange(i + 1, 1)];
            }
            if(![c isEqualToString:SEPERATOR_PRE]&& ![c isEqualToString:SEPERATOR_POST]){
                [sb appendString:[NSString stringWithFormat:@"%@",c]];
            } else if (d != nil && [c isEqualToString:SEPERATOR_PRE] && [d isEqualToString:SEPERATOR_POST]) {
                NSString *key = [[sb substringToIndex:preFlagPos] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [list setObject:@"" forKey:key];
                preFlagPos = 0;
            } else {
                if([c isEqualToString:SEPERATOR_PRE]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        //preFlagPos = i - 1;
                    }else{
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        if(preFlagPos != 0){
                            [sb deleteCharactersInRange:NSMakeRange(0, preFlagPos + 1)];//删掉不对应的：
                        }
                        preFlagPos = sb.length - 1; //对应到位置
                    }					
                }
                
                if([c isEqualToString:SEPERATOR_POST]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    }else{
                        NSString *key = [[sb substringToIndex:preFlagPos] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if(preFlagPos != 0){
                            [list setObject:[sb substringFromIndex:preFlagPos+1] forKey:key];
                        }
                        
                        [sb deleteCharactersInRange:NSMakeRange(0, sb.length)];//清掉内容
                        preFlagPos = 0;
                    }
                }
            }
        }
    }
    return list;
    
}

+(id)decode:(NSDictionary *)list className:(NSString *)className{
    id obj = [iOSApi objectFrom:className];
    [list fillObject:obj];
    return obj;
}


+ (NSMutableDictionary*)parser:(NSString *)input{
    if(input == nil){
        return nil;
    }
    
    NSMutableDictionary *result = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];			
    int preFlagPos = 0;
    NSMutableString *sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    for(int i = 0; i < input.length; i ++){
        
        NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
        
        if(![c isEqualToString:SEPERATOR_PRE]&& ![c isEqualToString:SEPERATOR_POST]){
            [sb appendString:[NSString stringWithFormat:@"%@",c]];
        }else{
            if([c isEqualToString:SEPERATOR_PRE]){
                if(i == 0){
                    continue; //舍弃：
                }
                if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                    [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                    [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    //preFlagPos = i - 1;
                }else{
                    [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    if(preFlagPos != 0){
                        [sb deleteCharactersInRange:NSMakeRange(0, preFlagPos + 1)];//删掉不对应的：
                    }
                    
                    preFlagPos = sb.length - 1; //对应到位置
                }					
            }
            
            if([c isEqualToString:SEPERATOR_POST]){
                if(i == 0){
                    continue; //舍弃：
                }
                
                if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                    [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                    [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    //preFlagPos = i - 1;
                }else{
                    NSString *key = [[sb substringToIndex:preFlagPos] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if(preFlagPos != 0 && ![result objectForKey:key]){
                        [result setObject:[sb substringFromIndex:preFlagPos+1] forKey:key];
                    }
                    
                    [sb deleteCharactersInRange:NSMakeRange(0, sb.length)];//清掉内容
                    preFlagPos = 0;
                }					
            }
        }
    }
    
    return result;			
}

+(BOOL)isAllEnglish:(NSString*)input{
    if(input == nil || input.length == 0){
        return NO;
    }
    NSString *regex = @"^[A-Za-z]+$"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [test evaluateWithObject:input];
}
/**
 * 判读是否为url，两个规则：
 * 1 ://存在，且前面全为英文字母，A-Z,a-z
 * 2 .,后面全为英文字母，A-Z,a-z
 * @param input
 * @return
 */
+(BOOL)isUrl:(NSString*)input{
    if(input == nil || input.length == 0){
        return false;
    }
    
    int position = [input rangeOfString:URL_FLAG].location;
    
    if(position != NSNotFound){
        NSString *preStr = [input substringToIndex:position];
        return [BusDecoder isAllEnglish:preStr];
    }
    
    position = [input rangeOfString:@"." options:NSBackwardsSearch].location;
    
    if(position < input.length - 1 && position != NSNotFound){
        NSString *posStr = [input substringFromIndex:position + 1];
        return [BusDecoder isAllEnglish:posStr];
    }
    
    return false;		
}

+(BOOL)isThisBus:(NSString*)flag bugTag:(NSString*)busTag{
    int position = -1;
    for(int i = 0; i < flag.length; i ++){
        char notViewChar = [flag characterAtIndex:i];
        if(notViewChar <= 31 && notViewChar >= 0){
            continue;
        }else{
            position = i;
            break;
        }
    }
    NSString *subFlag = @"";
    
    if(position >= 0){
        subFlag = [flag substringFromIndex:position];
    }
    subFlag = [subFlag stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [[subFlag uppercaseString] isEqualToString:busTag];
}


+(BusCategory*)classify:(NSString*)input{
    
    if(input == nil){
        return nil;
    }
    
    
    BusCategory *category = [[[BusCategory alloc] init] autorelease];
    
    
  
    if ([input hasPrefix:API_CODE_PREFIX]) {
        NSString *str = [input substringFromIndex:[API_CODE_PREFIX length]];
        
        const char *s = [[str substringToIndex:2] UTF8String];
        int type = -1;
        sscanf(s, "%02X", &type);
        
        
//        BusinessTypeUrl=0,
//        BusinessTypeBookMark,
//        BusinessTypeAppUrl,
//        BusinessTypeWeibo,
//        BusinessTypeCard,
//        BusinessTypePhone,
//        BusinessTypeEmail,
//        BusinessTypeText,
//        BusinessTypeEncText,
//        BusinessTypeShortMessage,
//        BusinessTypeWifiText,
//        BusinessTypeGmap,
//        BusinessTypeSchedule,
//        BusinessTypeRichMedia//=14 // 富媒体为14
        
        if(type==1)
        {
            category.type = CATEGORY_URL;	
            category.channel=URL_CHANNEL_FXF;
            
        }
        else if(type==2) {
            
            category.type = CATEGORY_BOOKMARK;			
            category.channel = WEIBO_CHANNEL_FXF;
        }
        else if(type==3) {
            category.type=CATEGORY_APP;			
            category.channel=APP_CHANNEL_FXF;
        }
        else if(type==4) {
            category.type = CATEGORY_WEIBO;			
            category.channel = WEIBO_CHANNEL_FXF;
        }
        else if(type==5) {
            category.type=CATEGORY_CARD;			
            category.channel=CARD_CHANNEL_VCARD;
        }
        else if(type==6) {
            category.type=CATEGORY_PHONE;
            category.channel=PHONE_CHANNEL_FXF;
        }
        else if(type==7) {
            category.type=CATEGORY_EMAIL;
             category.channel=MAIL_CHANNEL_FXF;
        }
        else if(type==8) {
            category.type=CATEGORY_TEXT;
            category.channel=DTXT_CHANNEL_FXF;
        }
        else if(type==9) {
            category.type=CATEGORY_ENCTEXT;			
            category.channel=ENCTEXT_CHANNEL_FXF;

        }
        else if(type==10) {
            category.type=CATEGORY_SHORTMESS;
            category.channel=SMS_CHANNEL_FXF;
        }
        else if(type==11) {
            category.type=CATEGORY_WIFI;			
            category.channel=WIFI_CHANNEL_FXF; 
        }
        else if(type==12) {
            category.type=CATEGORY_GMAP;			
            category.channel=GMAP_CHANNEL_FXF;
        }
        else if(type==13) {
            category.type=CATEGORY_SCHEDULE;			
            category.channel=SCH_CHANNEL_FXF;
           

        }
       return category;
    }

    
    
    
    NSRange range = [input rangeOfString:SEPERATOR_PRE];
    int position = range.location;
    
    if(position == NSNotFound || range.length == 0){//不存在：，可能是http链接，或者文本
        
        if([BusDecoder isUrl:input]){
            category.type=CATEGORY_URL;
            category.channel=URL_CHANNEL_HTTP;
        }else{
            category.type=CATEGORY_TEXT;
            category.channel=DTXT_CHANNEL_DEDAULT;
        }
        
        return category;
    }
    
    NSString *flage = [input substringToIndex:position];
    
    int logIDPos = [input rangeOfString:[NSString stringWithFormat:@"%@%@",ALL_LOGID,SEPERATOR_PRE]].location;
    
    // 富媒体业务
    if([[flage uppercaseString] rangeOfString:CATEGORY_MEDIA].location != NSNotFound){
        category.type = CATEGORY_MEDIA;
        if(logIDPos != NSNotFound){				
            category.channel=CARD_CHANNEL_FXF;
        }else{
            category.channel=CARD_CHANNEL_CMC;
        }
        return category;
    }
    
    //名片业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_CARD]){
        category.type = CATEGORY_CARD;
        if(logIDPos != NSNotFound){				
            category.channel=CARD_CHANNEL_FXF;
        }else{
            category.channel=CARD_CHANNEL_CMC;
        }
        
        return category;
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"BEGIN"]){
        
        category.type=CATEGORY_CARD;			
        category.channel=CARD_CHANNEL_VCARD;
        
        return category;
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"MECARD"]){
        
        category.type=CATEGORY_CARD;			
        category.channel=CARD_CHANNEL_MECARD;
        
        return category;
    }
    
    //书签，微薄，url，地图
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_BOOKMARK]){
        
        NSMutableDictionary *content = [BusDecoder parser:input];
                
        NSString *type = [content objectForKey:@"T"];
        
        if(type != nil && [type intValue] == WEIBO){
            category.type = CATEGORY_WEIBO;			
            category.channel = WEIBO_CHANNEL_FXF;
            return category;
        }
        
        if(type != nil && [type intValue] == GMAP){
            category.type=CATEGORY_GMAP;			
            category.channel=GMAP_CHANNEL_FXF;
            return category;
        }
        
        if(type != nil && [type intValue] == APP){
            category.type=CATEGORY_APP;			
            category.channel=APP_CHANNEL_FXF;
            return category;
        }
        
        
        if([content objectForKey:@"SUB"] != nil){ //书签、微薄类				
            
            category.type =  CATEGORY_BOOKMARK;	
            if([content objectForKey:@"P"]!= nil){
                category.channel=BM_CHANNEL_FXF;
            }else{
                category.channel=BM_CHANNEL_CMC;
            }
            
            return category;
        }else{//url中分地图/应用和普通url
            
            category.type = CATEGORY_URL;	
            category.channel=URL_CHANNEL_FXF;
            
            return category;
        }
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"MEBKM"]){
        
        category.type=CATEGORY_BOOKMARK;			
        category.channel=BM_CHANNEL_TO;
        
        return category;
    }
    
    //文本业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_TEXT]){
        
        category.type=CATEGORY_TEXT;
        
        if(logIDPos != NSNotFound){				
            category.channel=DTXT_CHANNEL_FXF;
        }else{
            category.channel=DTXT_CHANNEL_CMC;
        }
        
        return category;
    }
    
    //加密文本业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_ENCTEXT]){
        
        category.type=CATEGORY_ENCTEXT;			
        category.channel=ENCTEXT_CHANNEL_FXF;
        
        return category;
    }
    
    //wifi业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_WIFI]){
        
        category.type=CATEGORY_WIFI;			
        category.channel=WIFI_CHANNEL_FXF;
        
        return category;
    }
    
    //电话号码
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_PHONE]){
        
        category.type=CATEGORY_PHONE;
        
        if(logIDPos != NSNotFound){				
            category.channel=PHONE_CHANNEL_FXF;
        }else{
            category.channel=PHONE_CHANNEL_CMC;
        }
        
        return category;
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"TEL"]){
        
        category.type=CATEGORY_PHONE;			
        category.channel=PHONE_CHANNEL_TEL;
        
        return category;
    }
    
    //短信业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_SHORTMESS]){
        
        category.type=CATEGORY_SHORTMESS;
        
        if(logIDPos != NSNotFound){				
            category.channel=SMS_CHANNEL_FXF;
        }else{
            category.channel=SMS_CHANNEL_CMC;
        }
        
        return category;
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"SMSTO"]){
        
        category.type=CATEGORY_SHORTMESS;			
        category.channel=SMS_CHANNEL_TO;
        
        return category;
    }
    
    //电子邮件业务
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_EMAIL]){
        
        category.type=CATEGORY_EMAIL;
        
        if(logIDPos != NSNotFound){				
            category.channel=MAIL_CHANNEL_FXF;
        }else{
            category.channel=MAIL_CHANNEL_CMC;
        }
        
        return category;
    }
    
    if([BusDecoder isThisBus:flage bugTag:@"SMTP"]){
        
        category.type=CATEGORY_EMAIL;			
        category.channel=MAIL_CHANNEL_TO;
        
        return category;
    }		
    if([BusDecoder isThisBus:flage bugTag:@"MAILTO"]){
        
        category.type=CATEGORY_EMAIL;			
        category.channel=MAIL_CHANNEL_MAILTO;
        
        return category;
    }	
    //日程
    if([BusDecoder isThisBus:flage bugTag:CATEGORY_SCHEDULE]){
        
        category.type=CATEGORY_SCHEDULE;			
        category.channel=SCH_CHANNEL_FXF;
        return category;
    }
    
    /*
    //有冒号，但也有可能是url，或者文本
    if([BusDecoder isUrl:input]){
        category.type=CATEGORY_URL;
        category.channel=URL_CHANNEL_HTTP;
    }else{
        category.type=CATEGORY_TEXT;
        category.channel=DTXT_CHANNEL_DEDAULT;
    }
    */
    
    //有冒号，但也有可能是url，或者文本
    if([BusDecoder isUrl:input]){
        // 如果URL, 首先判断是否富媒体
        static NSString *kFLAG_RICHMEDIA = @"mb/dynamic/getContent.action";
        static NSString *kFLAG_KMA = @"mb/kma/getContent.action";
        NSRange range = [input rangeOfString:kFLAG_RICHMEDIA];
        if (range.length > 0) {
            // 富媒体业务
            category.type = CATEGORY_MEDIA;
            category.channel = URL_CHANNEL_HTTP;
            return category;
        } else if([input rangeOfString:kFLAG_KMA].length > 0) {
            // 空码业务
            category.type = CATEGORY_KMA;
            category.channel = URL_CHANNEL_HTTP;
            category.bKma = YES;
            return category;
        } else {
            // 视为传统业务
            category.type=CATEGORY_URL;
            category.channel=URL_CHANNEL_HTTP;
        }
    } else {
        // 默认为文本业务
        category.type=CATEGORY_TEXT;
        category.channel=DTXT_CHANNEL_DEDAULT;
    }
    return category;
}	

/**
 * 名片解码的统一入口
 * @param input
 * @param channel
 * @return
 */
+(Card*) decodeCard:(NSString*)input channel:(int)channele{
    
    if(channele == CARD_CHANNEL_VCARD){
        return [BusDecoder decodeVCARD:input];
    }else if(channele == CARD_CHANNEL_MECARD){
        return [BusDecoder decodeMECard:input];
    }else{
        return [BusDecoder decodeCardOnly:input];
    }
}

/**
 *  BEGIN:VCARD
 N:三;张
 TEL;CELL:13801019923
 TEL;HOME:010998877
 TEL;HOME;FAX:010997755
 ADR;HOME:;;北京市海口去;五道口;
 海淀;100084;中国
 ORG:百度;你好
 TITLE:经历
 EMAIL:zhangsan@baidu.com
 URL:http://ttt.com
 EMAIL;IM:5126004
 NOTE:附录
 BDAY:19870228
 END:VCARD
 */	

/**
 * 将字符串转换成名片对象	
 * @param input
 * @param channel
 * @return
 */
+(Card*) decodeVCARD:(NSString*) input{
    
    Card *card = [[[Card alloc] init]autorelease];
    
    NSMutableDictionary *content = [BusDecoder parserVCARD:input];
    
    NSString *tmpName = [content objectForKey:@"N"];
    
    if(tmpName != nil){
        NSArray *nameArr = [tmpName componentsSeparatedByString:@";"];
        NSString *name = [nameArr count] == 2 ? [NSString stringWithFormat:@"%@%@",[nameArr objectAtIndex:1],[nameArr objectAtIndex:0]] : [nameArr objectAtIndex:0];
        
        card.name = name;
    }
    
    
    NSString *cellPhone = [content objectForKey:@"TEL;CELL"]; //优先填充移动电话
    
    if(cellPhone != nil){
        card.cellphone=cellPhone;
    }
    
    
    NSString *telePhone = [content objectForKey:@"TEL;HOME"]; //
    
    if(telePhone != nil){
        card.telephone=telePhone;
    }
    
    NSString *fax = [content objectForKey:@"TEL;HOME;FAX"]; //
    
    if(fax != nil){
        card.fax=fax;
    }
    
    NSString *addresss = [content objectForKey:@"ADR;HOME"];
    if(addresss != nil){
        NSArray *addressArr = [addresss componentsSeparatedByString:@";"];
        
        if([addressArr count] == 7){
            card.address = [addressArr objectAtIndex:2];
            card.zipCode=[addressArr objectAtIndex:5];
        }
        
        if([addressArr count] == 5){
            card.address = [addressArr objectAtIndex:0];
            card.zipCode = [addressArr objectAtIndex:3];
        }			
    }
    
    NSString *org = [content objectForKey:@"ORG"];
    
    if(org != nil){
        
        NSArray *orgArr = [org componentsSeparatedByString:@";"];
        
        if([orgArr count] == 2 ){
            card.department= [orgArr objectAtIndex:1];
        }
        
        card.corporation = [orgArr objectAtIndex:0];
    }
    
    NSString *title = [content objectForKey:@"TITLE"]; 
    
    if(title != nil){
        card.title=title;
    }
    
    NSString *email = [content objectForKey:@"EMAIL"]; 
    
    if(email != nil){
        card.email =email;
    }
    
    NSString *url = [content objectForKey:@"URL"]; 
    
    if(url != nil){
        card.url=url;
    }
    
    NSString *qq = [content objectForKey:@"EMAIL;IM"]; 
    
    if(qq != nil){
        card.qq = qq;
    }
    
    return card;
}


/**
 * 1 以换行符为分隔符，进行split
 * 3 再取第一个：，进行key value分隔
 * 4 返回map
 */
+(NSMutableDictionary*) parserVCARD:(NSString *)input{
    
    if(input == nil){
        return nil;
    }
    
    NSMutableDictionary *result = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    NSArray *tmpContent = [input componentsSeparatedByString:@"\r"];
    
    int position = 0;
    
    for(int i = 0; i < [tmpContent count]; i ++){
        
        NSString *keyStr = [tmpContent objectAtIndex:i];
        
        if(keyStr == nil || keyStr.length == 0){
            continue;
        }
        
        if([[keyStr uppercaseString] isEqualToString:@"BEGIN:VCARD"] ||
           [[keyStr uppercaseString] isEqualToString:@"END:VCARD"]){
            continue;
        }
        
        position =  [keyStr rangeOfString:SEPERATOR_PRE].location;
        
        if(position != NSNotFound){
            [result setObject:[keyStr substringFromIndex:position + 1] forKey:[keyStr substringToIndex:position]];
        }
    }		
    
    return result;			
}



/**
 * 将冒号和分号分隔的字符串变成一个map对象
 * 1 先把mecard和最后一个分号去掉；
 * 2 以分号为分隔符，进行split
 * 3 再取第一个：，进行key value分隔
 * 4 返回map
 */
+(NSMutableDictionary*) parserMECARD:(NSString *)input{
    
    if(input == nil){
        return nil;
    }
    
    return [BusDecoder parser:input];
    
    /*String contenteStr = input.substring(7, input.length() - 1);//去除mecard和最后一个分号去掉
     
     NSArray tmpContent = contenteStr.split("" + [SEPERATOR_POST UTF8String][0]);
     
     NSMutableDictionary *result = new HashMap<String, String>();
     
     int position = 0;
     
     for(int i = 0; i < tmpContent.length; i ++){
     NSString *keyStr = tmpContent[i];
     
     if(keyStr == nil || keyStr.length() == 0){
     continue;
     }
     
     position =  keyStr rangeOfString:SEPERATOR_PRE].location;
     
     if(position != NSNotFound){
     result.put(keyStr.substring(0, position), keyStr.substring(position + 1));
     }
     }*/				
}

/**
 *  MECARD:N:三,张;TEL-AV:5126;
 TEL:13801018834;
 EMAIL:zhangsan@baidu.com;
 URL:http\://baidu.com;NOTE:附录;
 BDAY:19840225;
 ADR:,,北京市海淀区五道口,五道口,海淀,
 100086,中国;;
 */	

/**
 * 将字符串转换成名片对象	
 * @param input
 * @param channel
 * @return
 */
+(Card*)decodeMECard:(NSString *)input{
    
    Card *card = [[[Card alloc] init]autorelease];
    
    NSMutableDictionary* content = [BusDecoder parserMECARD:input];
    
    NSString *tmpName = [content objectForKey:@"N"];
    
    if(tmpName != nil){
        NSArray *nameArr = [tmpName componentsSeparatedByString:@","];
        NSString *name = [nameArr count] == 2 ? [NSString stringWithFormat:@"%@%@",[nameArr objectAtIndex:1],[nameArr objectAtIndex:0]]: [nameArr objectAtIndex:0];
        
        card.name = name;
    }
    
    NSString *telePhone = [content objectForKey:@"TEL"]; //
    
    if(telePhone != nil){
        card.telephone =telePhone;
    }
    
    NSString *cellPhone = [content objectForKey:@"TEL-AV"]; //优先填充移动电话
    
    if(cellPhone != nil){
        card.cellphone=cellPhone;
    }
    
    NSString *org = [content objectForKey:@"ORG"]; //公司
    
    if(org != nil){
        card.corporation=org;
    }
    NSString *title = [content objectForKey:@"TIL"]; //公司
    
    if(title != nil){
        card.title=title;
    }
    NSString *email = [content objectForKey:@"EMAIL"]; 
    
    if(email != nil){
        card.email=email;
    }
    
    NSString *url = [content objectForKey:@"URL"]; 
    
    if(url != nil){
        card.url=url;
    }
    NSString *qq = [content objectForKey:@"QQ"]; 
    
    if(qq != nil){
        card.qq=qq;
    }
    NSString *div = [content objectForKey:@"DIV"]; 
    
    if(div != nil){
        card.weibo=div;
    }
    NSString *addresss = [content objectForKey:@"ADR"];
    if(addresss != nil){
        NSArray *addressArr = [addresss componentsSeparatedByString:@","];
        
        if([addressArr count] == 7){
            card.address = [addressArr objectAtIndex:2];
            card.zipCode = [addressArr objectAtIndex:5];
        }else if([addressArr count] == 5){
            card.address = [addressArr objectAtIndex:0];
            card.zipCode = [addressArr objectAtIndex:3];
        }else {
            card.address = [addressArr objectAtIndex:0];
        }
    }
    
    return card;
}


/**
 * 将字符串转换成电话对象	
 * @param input
 * @param channel
 * @return
 */
+(Card*) decodeCardOnly:(NSString *)input{
    
    Card *card = [[[Card alloc] init]autorelease];
    
    NSMutableDictionary *content = [BusDecoder parser:input];
    
    NSString *name = [content objectForKey:CARD_NAME];		
    NSString *title = [content objectForKey:CARD_TITLE];		
    NSString *department = [content objectForKey:CARD_DEPARTMENT];		
    NSString *corporation = [content objectForKey:CARD_CORPORATION];		
    NSString *cellpone = [content objectForKey:CARD_CELLPHONE];		
    NSString *telephone = [content objectForKey:CARD_TELEPHONE];		
    NSString *fax = [content objectForKey:CARD_FAX];		
    NSString *email = [content objectForKey:CARD_EMAIL];		
    NSString *url = [content objectForKey:CARD_URL];		
    NSString *address = [content objectForKey:CARD_ADDRESS];		
    NSString *zipCode = [content objectForKey:CARD_ZIPCODE];
    NSString *qq = [content objectForKey:CARD_QQ];		
    NSString *msn = [content objectForKey:CARD_MSN];		
    NSString *weibo = [content objectForKey:CARD_WEIBO];		
    NSString *logId = [content objectForKey:ALL_LOGID];
    
    card.address=address;
    card.cellphone=cellpone;
    card.corporation=corporation;
    card.department=department;
    card.email=email;
    card.fax=fax;
    card.msn=msn;
    card.name=name;
    card.qq=qq;
    card.telephone=telephone;
    card.title=title;
    card.url=url;
    card.weibo=weibo;
    card.zipCode=zipCode;
    
    card.logId=logId;
    
    return card;
}

/**
 * 将字符串转换成电话对象	
 * @param input
 * @param channel
 * @return
 */
+(Phone*) decodePhone:(NSString *)input channel:(int)channele{
    
    Phone *phone = [[[Phone alloc] init]autorelease];
    
    if(channele == PHONE_CHANNEL_TEL){
        
        int position = [input rangeOfString:SEPERATOR_PRE].location;
        
        if(position == NSNotFound){
            return nil;
        }
        
        phone.telephone = [input substringFromIndex:position+1];
        
    }else{
        
        NSMutableDictionary *content = [BusDecoder parser:input];
        
        NSString *cellpone = [content objectForKey:PHONE_TELEPHONE];
        NSString *mphone = [content objectForKey:PHONE_MPHONE];
        NSString *logId = [content objectForKey:ALL_LOGID];
        
        if(mphone == nil){
            phone.telephone=cellpone?cellpone:@"";
        }else{
            phone.telephone=mphone;
        }			
        
        phone.logId=logId;
    }		
    
    return phone;		
}


/**
 * 解析smtp格式的电子邮件，进行编码转换
 * @param input
 * @return
 * SMSTO:145:神射手
 */
+(ShortMessage*) parserSMSTO:(NSString *)input{
    
    if(input == nil){
        return nil;
    }
    
    int position = [input rangeOfString:SEPERATOR_PRE].location;
    
    if(position == NSNotFound){
        return nil;
    }
    
    int nextPreFlagPos = [input rangeOfString:SEPERATOR_PRE options:NSCaseInsensitiveSearch range:NSMakeRange(position+1, input.length-position-1)].location;
    
    if(nextPreFlagPos == NSNotFound){
        return nil;
    }
    
    NSString *cellPhone = [input substringWithRange:NSMakeRange(position+1, nextPreFlagPos-position-1)];
    
    position = nextPreFlagPos;
    NSString *contente = [input substringFromIndex:position+1];
    
    ShortMessage *shortM = [[[ShortMessage alloc] init]autorelease];
    shortM.phone=cellPhone?cellPhone:@"";
    shortM.content=contente?contente:@"";		
    
    return shortM;
}


/**
 * 将字符串转换成短信对象	
 * @param input
 * @param channel
 * @return
 */
+(ShortMessage*) decodeShortmessage:(NSString *)input channel:(int)channele{
    
    ShortMessage *shortM = [[[ShortMessage alloc] init]autorelease];
    
    if(channele == SMS_CHANNEL_TO){
        shortM = [BusDecoder parserSMSTO:input];
    }else{
        NSMutableDictionary *content =[BusDecoder parser:input];
        
        NSString *cellpone = [content objectForKey:SHORTMESS_CELLPHONE];
        NSString *tcontente = [content objectForKey:SHORTMESS_CONTENT];
        NSString *logId = [content objectForKey:ALL_LOGID];
        
        shortM.phone=cellpone?cellpone:@"";
        shortM.content=tcontente?tcontente:@"";
        shortM.logId=logId;
    }		
    
    return shortM;		
}	

/**
 * 解析smtp格式的电子邮件，进行编码转换
 * @param input
 * @return
 * SMTP:zhangsan@baidu.com:你好:你好啊
 */
+(Email*) parserSMTP:(NSString *)input{
    
    if(input == nil){
        return nil;
    }
    
    int position = [input rangeOfString:SEPERATOR_PRE].location;
    
    if(position == NSNotFound){
        return nil;
    }
    
    int nextPreFlagPos = [input rangeOfString:SEPERATOR_PRE options:NSCaseInsensitiveSearch range:NSMakeRange(position+1, input.length-position-1)].location;

    
    if(nextPreFlagPos == NSNotFound){
        return nil;
    }
    
    NSString *mail = [input substringWithRange:NSMakeRange(position+1, nextPreFlagPos-position-1)];
    
    position = nextPreFlagPos;
    nextPreFlagPos = [input rangeOfString:SEPERATOR_PRE options:NSCaseInsensitiveSearch range:NSMakeRange(position+1, input.length-position-1)].location;
    
    if(nextPreFlagPos == NSNotFound){
        return nil;
    }
    
    NSString *title = [input substringWithRange:NSMakeRange(position+1, nextPreFlagPos-position-1)];
    
    position = nextPreFlagPos;
    NSString *contente = [input substringFromIndex:position+1];
    
    Email *email = [[[Email alloc] init]autorelease];
    
    email.mail=mail?mail:@"";
    email.title=title?title:@"";
    email.content= contente?contente:@"";   
    
    return email;
}
/**
 * 解析smtp格式的电子邮件，进行编码转换
 * @param input
 * @return
 * SMTP:zhangsan@baidu.com:你好:你好啊
 */
+(Email*) parserMAILTO:(NSString *)input{
    
    if(input == nil){
        return nil;
    }
    
    int position = [input rangeOfString:SEPERATOR_PRE].location;
    
    if(position == NSNotFound){
        return nil;
    }
    
    NSString *mail = [input substringFromIndex:position+1];
    
    Email *email = [[[Email alloc] init]autorelease];
    
    email.mail=mail?mail:@"";
    email.title=@"";
    email.content= @"";   
    
    return email;
}

/**
 * 将字符串转换成电子邮件对象	
 * @param input
 * @param channel
 * @return
 */
+(Email*) decodeEmail:(NSString *)input channel:(int) channele{
    Email *email = [[[Email alloc]init]autorelease];    
    if(channele == MAIL_CHANNEL_TO){
        email = [BusDecoder parserSMTP:input];
    }else if(channele == MAIL_CHANNEL_MAILTO){
        email = [BusDecoder parserMAILTO:input];
    }else{
        NSMutableDictionary *content =[BusDecoder parser:input];
        
        NSString *mail = [content objectForKey:EMAIL_MAIL];
        NSString *title = [content objectForKey:EMAIL_TITLE];
        NSString *tcontente = [content objectForKey:EMAIL_CONTENT];
        NSString *logId = [content objectForKey:ALL_LOGID];
        
        email.mail=mail?mail:@"";
        email.title=title?title:@"";
        email.content= tcontente?tcontente:@"";
        email.logId=logId;
    }		
    
    return email;		
}	



/**
 * 识别日程串，解析成对象
 * @param input
 * @return
 */
+(Schedule*) decodeSchedule:(NSString *)input{
    
    Schedule *schedule = [[[Schedule alloc]init]autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *date = [content objectForKey:SCHEDULE_DATE];
    NSString *title = [content objectForKey:SCHEDULE_TITLE];
    NSString *scontente = [content objectForKey:SCHEDULE_CONTENT];
    
    NSString *logId = [content objectForKey:ALL_LOGID];
    
    schedule.date=date?date:@"";
    schedule.title=title?title:@"";
    schedule.content=scontente?scontente:@"";
    schedule.logId=logId;
    
    return schedule;		
}

/**
 * 实现字符编码转换
 * @param input
 * @param fromCode
 * @param toCode
 * @return
 */
+(NSString*)transCode:(NSString *)input{
    if (input == nil)
        return nil;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [input stringByReplacingPercentEscapesUsingEncoding:enc];
}

/**
 * 识别url串，解析成对象
 * @param input
 * @return
 */
+(BookMark*) decodeBookMark:(NSString *)input channel:(int) channele{
    
    BookMark *bookmark = [[[BookMark alloc]init]autorelease];
    
    if(channele == BM_CHANNEL_TO){
        
        NSMutableDictionary *content =[BusDecoder parser:input];
        
        NSString *title = [content objectForKey:@"TITLE"];//需要进行转码
        NSString *tcontente = [content objectForKey:@"URL"];
        
        bookmark.title = title?title:@"";
        bookmark.url = tcontente?tcontente:@"";
        
    }else{
        NSMutableDictionary *content =[BusDecoder parser:input];
        
        NSString *title = [content objectForKey:BOOKMARK_TITLE];
        NSString *tcontente = [content objectForKey:BOOKMARK_URL];
        NSString *logId = [content objectForKey:ALL_LOGID];
        
        bookmark.title=title?title:@"";
        bookmark.url=tcontente?tcontente:@"";
        bookmark.logId=logId;
    }		
    
    return bookmark;		
}

/**
 * 识别url串，解析成对象
 * @param input
 * @return
 */
+(Url*) decodeUrl:(NSString *)input channel:(int) channele{
    
    Url *url = [[[Url alloc]init]autorelease];
    
    if(channele == URL_CHANNEL_HTTP){
        url.content=input;
    }else{
        NSMutableDictionary *content =[BusDecoder parser:input];
        
        NSString *tcontente = [content objectForKey:BOOKMARK_URL];
        NSString *logId = [content objectForKey:ALL_LOGID];
        
        url.content=tcontente?tcontente:@"";
        url.logId=logId;
    }		
    
    return url;		
}


/**
 * 识别微薄串，解析成对象
 * @param input
 * @return
 */
+(Weibo*) decodeWeibo:(NSString *)input{
    
    Weibo *weibo = [[[Weibo alloc]init]autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *title = [content objectForKey:BOOKMARK_TITLE];
    NSString *url = [content objectForKey:BOOKMARK_URL];
    NSString *logId = [content objectForKey:ALL_LOGID];
    
    weibo.title=title?title:@"";
    weibo.url=url?url:@"";
    weibo.logId=logId;
    
    return weibo;		
}

/**
 * 识别地图串，解析成对象
 * @param input
 * @return
 */
+(GMap*) decodeGMap:(NSString *)input{
    
    GMap *gmap = [[[GMap alloc]init]autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *url = [content objectForKey:BOOKMARK_URL];
    NSString *logId = [content objectForKey:ALL_LOGID];
    
    gmap.url=url?url:@"";
    gmap.logId=logId;
    
    return gmap;		
}

/**
 * 识别应用程序串，解析成对象
 * @param input
 * @return
 */
+(AppUrl*) decodeAppUrl:(NSString *)input{
    
    AppUrl *appUrl = [[[AppUrl alloc]init]autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *url = [content objectForKey:BOOKMARK_URL];
    NSString *logId = [content objectForKey:ALL_LOGID];
    NSString *title = [content objectForKey:BOOKMARK_TITLE];
    
    appUrl.url=url?url:@"";
    appUrl.title=title?title:@"";
    appUrl.logId=logId;
    
    return appUrl;		
}

/**
 * 识别文本，解析成对象
 * @param input
 * @return
 */
+(Text*) decodeText:(NSString *)input channel:(int) channele{
    
    Text *text = [[[Text alloc] init] autorelease];
    
    if(channele == DTXT_CHANNEL_DEDAULT){
        text.content = input;
    }else{
		
        NSMutableDictionary *content =[BusDecoder parser:input];
		
        NSString *tcontente = [content objectForKey:TEXT_CONTENT];
        NSString *logId = [content objectForKey:ALL_LOGID];
		
        text.content=tcontente?tcontente:@"";
        text.logId=logId;
    }
    
    return text;		
}

/**
 * 识别加密文本，解析成对象
 * @param input
 * @return
 */
+(EncText*) decodeEncText:(NSString *)input key:(NSString *)key{
    
    EncText *encText = [[[EncText alloc]init] autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *tcontente = [content objectForKey:TEXT_CONTENT];
    NSString *logId = [content objectForKey:ALL_LOGID];
	
    if(key == nil){
        return encText;
    }
    NSString *strMi = @"";
    if (tcontente != nil) {
        strMi = [EncryptTools Base64DecryptString:tcontente];
        if (strMi != nil && ![strMi isEqualToString:@""]) {
            content =[BusDecoder parser:strMi];
            if (![key isEqualToString:[content objectForKey:ENC_KEY]]) {
                return nil;
            }
            strMi = [content objectForKey:ENC_CONTENT];
        }
    }
    //encText.encContent = strMi?strMi:@"";
    encText.content=tcontente?tcontente:@"";
    encText.key=key;
    encText.logId=logId;		
    
    return encText;		
}

/**
 * 识别WIFI，解析成对象
 * @param input
 * @return
 */
+(WiFiText*) decodeWifiText:(NSString *)input{
    
    WiFiText *text = [[[WiFiText alloc]init]autorelease];
    
    NSMutableDictionary *content =[BusDecoder parser:input];
    
    NSString *tcontente = [content objectForKey:WIFI_NAME];
    NSString *password = [content objectForKey:WIFI_PASSWORD];
    NSString *logId = [content objectForKey:ALL_LOGID];
	
    text.name = tcontente?tcontente:@"";
    text.password=password?password:@"";
    text.logId=logId;
    
    return text;		
}
@end
