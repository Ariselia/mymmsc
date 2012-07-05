//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "DataEnvironment.h"
#import "DataCacheManager.h"
#import "BusDescKey.h"

@interface DataEnvironment()
- (void)restore;
@end

@implementation DataEnvironment

static DataEnvironment *sharedInst = nil;

@synthesize urlRequestHost = _urlRequestHost;
@synthesize encodeImageType = _encodeImageType;
@synthesize curScanType = _curScanType;
@synthesize curLocation = _curLocation;
@synthesize curBusinessType = _curBusinessType;
@synthesize hasNetWork = _hasNetWork;

#pragma mark - singleton lifecycle

+ (id)sharedDataEnvironment{
	@synchronized( self ) {
		if ( sharedInst == nil ) {
            [[self alloc] init];
		}
	}
	
	return sharedInst;
}

- (id)init{
    self = [super init];
	if ( sharedInst != nil ) {
		//
	} else if (self) {
		sharedInst = self;
		[self restore];
		
	}
	return sharedInst;
}

- (void)clearNetworkData{
    [[DataCacheManager sharedManager] clearAllCache];
}


- (UIImage *)getBusinessImage:(BusinessType)type select:(BOOL)isSelected{
    NSString *subffix = @".png";
    if (isSelected) {
        subffix = @"_tap.png";
    }
    NSString *path;
    switch (type) {
        case kModelPhone:
            path = @"address_rainbow";
            break;
        case kModelAppUrl:
            path = @"app_rainbow";
            break;
        case kModelCard:
            path = @"card_rainbow";
            break;
        case kModelEncText:
            path = @"jiami_rainbow";
            break;
        case kModelGMap:
            path = @"map_rainbow";
            break;
        case kModelShortMessage:
            path = @"sms_rainbow";
            break;
        case kModelEmail:
            path = @"mail_rainbow";
            break;
        case kModelText:
            path = @"text_rainbow";
            break;
        case kModelWiFiText:
            path = @"wifi_rainbow";
            break;
        case kModelWeibo:
            path = @"weibo_rainbow";
            break;
        case kModelBookMark:
            path = @"webtag_rainbow";
            break;
        case kModelUrl:
            path = @"website_rainbow";
            break;
        case kModelSchedule:
            path = @"schedule_rainbow";
            break;
        case kModelRichMedia:
            path = @"richmedia_rainbow";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",path,subffix]];
}


- (UIColor *)getColorWithIndex:(int)index{
    switch (index) {
        case 0:// 黑
            return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        case 1://红
            return [UIColor colorWithRed:255.0/255 green:0 blue:0 alpha:1];
        case 2://橙 
            return [UIColor colorWithRed:255.0/255 green:144.0/255 blue:0 alpha:1];
        case 3://黄
            return [UIColor colorWithRed:255.0/255 green:255.0/255 blue:0 alpha:1];
        case 4://绿
            return [UIColor colorWithRed:0 green:255.0/255 blue:0 alpha:1];
        case 5://青
            return [UIColor colorWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:1];
        case 6://蓝
            return [UIColor colorWithRed:0 green:0 blue:255.0/255 alpha:1];
        case 7://紫
            return [UIColor colorWithRed:255.0/255 green:0 blue:255.0/255 alpha:1];
        default:
            return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
}

- (int)getHexColorWithIndex:(int)index{
    int color;
    switch (index) {
        case 0:// 黑
            color = 657930;
            break;
        case 1://红
            color = 15597568;
            break;
        case 2://橙 
            color = 16744192;
            break;
        case 3://黄
            color = 10506797;
            break;
        case 4://绿
            color = 25600;
            break;
        case 5://青
            color = 128;
            break;
        case 6://蓝
            color = 238;
            break;
        case 7://紫
            color = 9699539;
            break;
        default:
            color = 657930;
            break;
    }
    return color;
}

- (NSMutableArray *)getSkinThumbnail{
    NSMutableArray *arr = [NSMutableArray array];
    UIImage *imgage = [UIImage imageNamed:@"thumbnail_0.png"];
    int i = 0;
    while (imgage) {
        [arr addObject:imgage];
        i++;
        imgage = [UIImage imageNamed:[NSString stringWithFormat:@"thumbnail_%d.png",i]];
    }
    return arr;
}

- (UIImage *)getSkinImageWithIndex:(int)index{
    return [UIImage imageNamed:[NSString stringWithFormat:@"skin_%d.png",index]];
}

- (NSString *)getSkinUrlWithIndex:(int)index{
    switch (index) {
        case 0:
            return @"";
        case 1:
            return @"杯子";
        case 2:
            return @"粉红心";
        case 3:
            return @"风景";
        case 4:
            return @"河马";
        case 5:
            return @"花";
        case 6:
            return @"卡通粉红";
        case 7:
            return @"卡通风景";
        case 8:
            return @"卡通怪物";
        case 9:
            return @"跑车";
        case 10:
            return @"铅笔";
        case 11:
            return @"心";
        case 12:
            return @"星星";
        default:
            return @"";
    }
}

- (NSArray *)getIconImage{
    NSMutableArray *arr = [NSMutableArray array];
    UIImage *imgage = [UIImage imageNamed:@"icon_0.png"];
    int i = 0;
    while (imgage) {
        [arr addObject:imgage];
        i++;
        imgage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",i]];
    }
    return arr;
}

- (UIImage *)getTableImage:(BusinessType)index{
    switch (index % 16) {
        case kModelUrl:
            return [UIImage imageNamed:@"table_website.png"];
            break;
        case kModelBookMark:
            return [UIImage imageNamed:@"table_mark.png"];
            break;
        case kModelAppUrl:
            return [UIImage imageNamed:@"table_app.png"];
            break;
        case kModelWeibo:
            return [UIImage imageNamed:@"table_weibo.png"];
            break;
        case kModelCard:
            return [UIImage imageNamed:@"table_card.png"];
            break;
        case kModelPhone:
            return [UIImage imageNamed:@"table_phone.png"];
            break;
        case kModelText:
            return [UIImage imageNamed:@"table_text.png"];
            break;
        case kModelEncText:
            return [UIImage imageNamed:@"table_enc.png"];
            break;
        case kModelEmail:
            return [UIImage imageNamed:@"table_email.png"];
            break;
        case kModelGMap:
            return [UIImage imageNamed:@"table_map.png"];
            break;
        case kModelShortMessage:
            return [UIImage imageNamed:@"table_sms.png"];
            break;
        case kModelWiFiText:
            return [UIImage imageNamed:@"table_wifi.png"];
            break;
        case kModelSchedule:
            return [UIImage imageNamed:@"table_schedule.png"];
            break;
        case kModelRichMedia:
            return [UIImage imageNamed:@"table_richmedia.png"];
            break;
        case kModelKma:
            return [UIImage imageNamed:@"table_kma.png"];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)getDecodeType:(NSString*)type{
    if ([type isEqualToString:CATEGORY_PHONE]) {
        return @"phone";
    } else if([type isEqualToString:CATEGORY_SHORTMESS]) {
        return @"shortMessage";
    } else if([type isEqualToString:CATEGORY_EMAIL]) {
        return @"email";
    } else if([type isEqualToString:CATEGORY_BOOKMARK]) {
       return @"bookMark";
    } else if([type isEqualToString:CATEGORY_SCHEDULE]) {
       return @"schedule";
    } else if([type isEqualToString:CATEGORY_TEXT]) {
        return @"text";
    } else if([type isEqualToString:CATEGORY_ENCTEXT]) {
        return @"encText";
    } else if([type isEqualToString:CATEGORY_WIFI]) {
        return @"wifiText";
    } else if([type isEqualToString:CATEGORY_URL]) {
        return @"url";
    } else if([type isEqualToString:CATEGORY_WEIBO]) {
        return @"weibo";
    } else if([type isEqualToString:CATEGORY_GMAP]) {
        return @"gmap";
    } else if([type isEqualToString:CATEGORY_APP]) {
        return @"appUrl";
    } else if([type isEqualToString:CATEGORY_CARD]) {
        return @"card";
    } else if([type isEqualToString:CATEGORY_MEDIA]) {
        return @"richMedia";
    } else {
        return @"text";
    }
}

- (NSString *)getEncodeCodeType:(BusinessType)type{
    switch (type) {
        case kModelAppUrl:
            return @"appUrl";
        case kModelCard:
            return @"card";
        case kModelBookMark:
            return @"bookMark";
        case kModelEncText:
            return @"encText";
        case kModelEmail:
            return @"email";
        case kModelGMap:
             return @"gmap";
        case kModelPhone:
            return @"phone";
        case kModelSchedule:
            return @"schedule";
        case kModelShortMessage:
            return @"shortMessage";
        case kModelText:
            return @"text";
        case kModelWiFiText:
            return @"wifiText";
        case kModelWeibo:
            return @"weibo";
        case kModelUrl:
            return @"url";
        case kModelRichMedia:
            return @"richMedia";
        default:
            return @"text";
    }
}
- (int)getCodeType:(NSString *)type{
    if ([type isEqualToString:CATEGORY_PHONE]) {
        return kModelPhone;
    }else if([type isEqualToString:CATEGORY_SHORTMESS]){
        return kModelShortMessage;
    }else if([type isEqualToString:CATEGORY_EMAIL]){
        return kModelEmail;
    }else if([type isEqualToString:CATEGORY_BOOKMARK]){
        return kModelBookMark;
    }else if([type isEqualToString:CATEGORY_SCHEDULE]){
        return kModelSchedule;
    }else if([type isEqualToString:CATEGORY_TEXT]){
        return kModelText;
    }else if([type isEqualToString:CATEGORY_ENCTEXT]){
        return kModelEncText;
    }else if([type isEqualToString:CATEGORY_WIFI]){
        return kModelWiFiText;
    }else if([type isEqualToString:CATEGORY_URL]){
        return kModelUrl;
    }else if([type isEqualToString:CATEGORY_WEIBO]){
        return kModelWeibo;
    }else if([type isEqualToString:CATEGORY_GMAP]){
        return kModelGMap;
    }else if([type isEqualToString:CATEGORY_APP]){
        return kModelAppUrl;
    } else if([type isEqualToString:CATEGORY_CARD]){
        return kModelCard;
    } else if([type isEqualToString:CATEGORY_MEDIA]) {
        return kModelRichMedia;
    } else {
        //return kModelText;
         return kModelRichMedia;
    }

}

- (BOOL)getFlashLightStatus{
    return [USER_DEFAULT boolForKey:FlashLightStatus];
}

- (void)setFlashLightStatus:(BOOL)status{
    [USER_DEFAULT setBool:status forKey:FlashLightStatus];
}

- (BOOL)getDecodeMusicStatus{
    return ![USER_DEFAULT boolForKey:DecodeMusicStatus];
}

- (void)setDecodeMusicStatus:(BOOL)status{
    [USER_DEFAULT setBool:!status forKey:DecodeMusicStatus];
}

- (BOOL)getLocationStatus{
    return ![USER_DEFAULT boolForKey:LocationStatus];
}

- (void)setLocationStatus:(BOOL)status{
    [USER_DEFAULT setBool:!status forKey:LocationStatus];
}

- (NSUInteger)retainCount{
	return NSUIntegerMax;
}

- (oneway void)release{
}

- (id)retain{
	return sharedInst;
}

- (id)autorelease{
	return sharedInst;
}

- (void)restore{
    _urlRequestHost = [REQUEST_DOMAIN retain];
    _curLocation = @"";
}

- (void)dealloc{
    RELEASE_SAFELY(_urlRequestHost);
	[super dealloc];
}

@end