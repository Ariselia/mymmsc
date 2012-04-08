//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "DataEnvironment.h"
#import "DataCacheManager.h"
//#import "ITTNetworkTrafficManager.h"
#import "BusDescKey.h"

@interface DataEnvironment()
- (void)restore;
@end

@implementation DataEnvironment

static DataEnvironment *sharedInst = nil;

@synthesize urlRequestHost = _urlRequestHost;
@synthesize encodeImageType=_encodeImageType;
@synthesize curScanType=_curScanType;
@synthesize curLocation=_curLocation;
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
		
	}else if (self) {
		sharedInst = self;
		[self restore];
		
	}
	return sharedInst;
}

-(void)clearNetworkData{
    [[DataCacheManager sharedManager] clearAllCache];
}


- (UIImage*)getBusinessImage:(BusinessType)type select:(BOOL)isSelected{
    NSString *subffix = @".png";
    if (isSelected) {
        subffix = @"_tap.png";
    }
    NSString *path;
    switch (type) {
        case BusinessTypePhone:
            path = @"address_rainbow";
            break;
        case BusinessTypeAppUrl:
            path = @"app_rainbow";
            break;
        case BusinessTypeCard:
            path = @"card_rainbow";
            break;
        case BusinessTypeEncText:
            path = @"jiami_rainbow";
            break;
        case BusinessTypeGmap:
            path = @"map_rainbow";
            break;
        case BusinessTypeShortMessage:
            path = @"sms_rainbow";
            break;
        case BusinessTypeEmail:
            path = @"mail_rainbow";
            break;
        case BusinessTypeText:
            path = @"text_rainbow";
            break;
        case BusinessTypeWifiText:
            path = @"wifi_rainbow";
            break;
        case BusinessTypeWeibo:
            path = @"weibo_rainbow";
            break;
        case BusinessTypeBookMark:
            path = @"webtag_rainbow";
            break;
        case BusinessTypeUrl:
            path = @"website_rainbow";
            break;
        case BusinessTypeSchedule:
            path = @"schedule_rainbow";
            break;
        case BusinessTypeRichMedia:
            path = @"richmedia_rainbow";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",path,subffix]];
}


- (UIColor*)getColorWithIndex:(int)index{
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
//    char *chars;
//    switch (index) {
//        case 0:// 黑
//            chars = "000000";
//            break;
//        case 1://红
//            chars = "ff0000";
//            break;
//        case 2://橙 
//            chars = "ffa500";
//            break;
//        case 3://黄
//            chars = "ffff00";
//            break;
//        case 4://绿
//            chars = "008000";
//            break;
//        case 5://青
//            chars = "00ffff";
//            break;
//        case 6://蓝
//            chars = "0000ff";
//            break;
//        case 7://紫
//            chars = "800080";
//            break;
//        default:
//            chars = "000000";
//            break;
//    }
//    return strtol(chars,NULL,16);
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

- (NSMutableArray*)getSkinThumbnail{
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

- (UIImage*)getSkinImageWithIndex:(int)index{
    return [UIImage imageNamed:[NSString stringWithFormat:@"skin_%d.png",index]];
}

- (NSString*)getSkinUrlWithIndex:(int)index{
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
- (NSArray*)getIconImage{
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

- (UIImage*)getTableImage:(BusinessType)index{
    switch (index) {
        case BusinessTypeAppUrl:
            return [UIImage imageNamed:@"table_app.png"];
            break;
        case BusinessTypeCard:
            return [UIImage imageNamed:@"table_card.png"];
            break;
        case BusinessTypeBookMark:
            return [UIImage imageNamed:@"table_mark.png"];
            break;
        case BusinessTypeEncText:
            return [UIImage imageNamed:@"table_enc.png"];
            break;
        case BusinessTypeEmail:
            return [UIImage imageNamed:@"table_email.png"];
            break;
        case BusinessTypeGmap:
            return [UIImage imageNamed:@"table_map.png"];
            break;
        case BusinessTypePhone:
            return [UIImage imageNamed:@"table_phone.png"];
            break;
        case BusinessTypeSchedule:
            return [UIImage imageNamed:@"table_schedule.png"];
            break;
        case BusinessTypeShortMessage:
            return [UIImage imageNamed:@"table_sms.png"];
            break;
        case BusinessTypeText:
            return [UIImage imageNamed:@"table_text.png"];
            break;
        case BusinessTypeWifiText:
            return [UIImage imageNamed:@"table_wifi.png"];
            break;
        case BusinessTypeWeibo:
            return [UIImage imageNamed:@"table_weibo.png"];
            break;
        case BusinessTypeUrl:
            return [UIImage imageNamed:@"table_website.png"];
            break;
        case BusinessTypeRichMedia:
            return [UIImage imageNamed:@"table_richmedia.png"];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString*)getDecodeType:(NSString*)type{
    if ([type isEqualToString:CATEGORY_PHONE]) {
        return @"phone";
    }else if([type isEqualToString:CATEGORY_SHORTMESS]){
        return @"shortMessage";
    }else if([type isEqualToString:CATEGORY_EMAIL]){
        return @"email";
    }else if([type isEqualToString:CATEGORY_BOOKMARK]){
       return @"bookMark";
    }else if([type isEqualToString:CATEGORY_SCHEDULE]){
       return @"schedule";
    }else if([type isEqualToString:CATEGORY_TEXT]){
        return @"text";
    }else if([type isEqualToString:CATEGORY_ENCTEXT]){
        return @"encText";
    }else if([type isEqualToString:CATEGORY_WIFI]){
        return @"wifiText";
    }else if([type isEqualToString:CATEGORY_URL]){
        return @"url";
    }else if([type isEqualToString:CATEGORY_WEIBO]){
        return @"weibo";
    }else if([type isEqualToString:CATEGORY_GMAP]){
        return @"gmap";
    }else if([type isEqualToString:CATEGORY_APP]){
        return @"appUrl";
    } else if([type isEqualToString:CATEGORY_CARD]){
        return @"card";
    } else if([type isEqualToString:CATEGORY_MEDIA]) {
        return @"richMedia";
    } else {
        return @"text";
    }
}

- (NSString*)getEncodeCodeType:(BusinessType)type{
    switch (type) {
        case BusinessTypeAppUrl:
            return @"appUrl";
        case BusinessTypeCard:
            return @"card";
        case BusinessTypeBookMark:
            return @"bookMark";
        case BusinessTypeEncText:
            return @"encText";
        case BusinessTypeEmail:
            return @"email";
        case BusinessTypeGmap:
             return @"gmap";
        case BusinessTypePhone:
            return @"phone";
        case BusinessTypeSchedule:
            return @"schedule";
        case BusinessTypeShortMessage:
            return @"shortMessage";
        case BusinessTypeText:
            return @"text";
        case BusinessTypeWifiText:
            return @"wifiText";
        case BusinessTypeWeibo:
            return @"weibo";
        case BusinessTypeUrl:
            return @"url";
        case BusinessTypeRichMedia:
            return @"richMedia";
        default:
            return @"text";
    }
}
- (int)getCodeType:(NSString*)type{
    if ([type isEqualToString:CATEGORY_PHONE]) {
        return BusinessTypePhone;
    }else if([type isEqualToString:CATEGORY_SHORTMESS]){
        return BusinessTypeShortMessage;
    }else if([type isEqualToString:CATEGORY_EMAIL]){
        return BusinessTypeEmail;
    }else if([type isEqualToString:CATEGORY_BOOKMARK]){
        return BusinessTypeBookMark;
    }else if([type isEqualToString:CATEGORY_SCHEDULE]){
        return BusinessTypeSchedule;
    }else if([type isEqualToString:CATEGORY_TEXT]){
        return BusinessTypeText;
    }else if([type isEqualToString:CATEGORY_ENCTEXT]){
        return BusinessTypeEncText;
    }else if([type isEqualToString:CATEGORY_WIFI]){
        return BusinessTypeWifiText;
    }else if([type isEqualToString:CATEGORY_URL]){
        return BusinessTypeUrl;
    }else if([type isEqualToString:CATEGORY_WEIBO]){
        return BusinessTypeWeibo;
    }else if([type isEqualToString:CATEGORY_GMAP]){
        return BusinessTypeGmap;
    }else if([type isEqualToString:CATEGORY_APP]){
        return BusinessTypeAppUrl;
    } else if([type isEqualToString:CATEGORY_CARD]){
        return BusinessTypeCard;
    } else if([type isEqualToString:CATEGORY_MEDIA]) {
        return BusinessTypeRichMedia;
    } else {
        return BusinessTypeText;
    }

}

-(BOOL)getFlashLightStatus{
    return [USER_DEFAULT boolForKey:FlashLightStatus];
}
-(void)setFlashLightStatus:(BOOL)status{
    [USER_DEFAULT setBool:status forKey:FlashLightStatus];
}
-(BOOL)getDecodeMusicStatus{
    return ![USER_DEFAULT boolForKey:DecodeMusicStatus];
}
-(void)setDecodeMusicStatus:(BOOL)status{
    [USER_DEFAULT setBool:!status forKey:DecodeMusicStatus];
}
-(BOOL)getLocationStatus{
    return ![USER_DEFAULT boolForKey:LocationStatus];
}
-(void)setLocationStatus:(BOOL)status{
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