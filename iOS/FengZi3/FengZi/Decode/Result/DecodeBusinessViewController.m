//
//  DecodeBusinessViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "DecodeBusinessViewController.h"
#import "BusDecoder.h"
#import "Api+Category.h"
#import "FileUtil.h"
#import "Api+Database.h"
#import "Api+Category.h"
#import "CommonUtils.h"
#import "EncryptTools.h"
#import "SHK.h"
#import "SHKMail.h"
#import "ShareView.h"
#import "DecodeCardViewControlle.h"
#import "UCRichMedia.h"
#import "Api+RichMedia.h"
#import "UCKmaViewController.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "Api.h"
#import "UITableViewCellExt.h"

#include <stdlib.h>
#include <stdio.h>
#include <time.h> // for time_t
#include <regex.h>

#define SEPERATOR_PRE @":"
#define SEPERATOR_POST @";"
#define API_CODE_PREFIX @"http://ifengzi.cn/show.cgi?"
#define RICH_URL @"http://f.ifengzi.cn"
@implementation DecodeBusinessViewController
@synthesize returnFlag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil category:(BusCategory *)cate  result:(NSString *)input image:(UIImage*)img withType:(HistoryType)type withSaveImage:(UIImage*)sImage{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        _hideContentIndex = -1;
        _category = [cate retain];
        _content = [input retain];
        _image = [img retain];
        _saveImage = [sImage retain];
        _historyType = type;
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
-(void)goPhoto{
     
    UIImagePickerController * pick  = [[UIImagePickerController alloc]init];

    pick.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentModalViewController:pick animated:NO];
    [pick release];
}
-(void)shareCode{
    [[SHK currentHelper] setRootViewController:self];
    SHKItem *item = [SHKItem text:@"快来扫码，即有惊喜！\n来自蜂子客户端"];
    item.image = _image;
    item.shareType = SHKShareTypeImage;
    item.title = @"快来扫码，即有惊喜！";
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];
//    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}

-(void)sendMessage:(NSString*)logId{
    NSString *appAtt = [NSString stringWithFormat:@"eqn=%@&type=%@&stype=%d&loc=%@",[[UIDevice currentDevice] uniqueIdentifier],[DATA_ENV getDecodeType:_category.type],DATA_ENV.curScanType,DATA_ENV.curLocation];
    appAtt = [EncryptTools Base64EncryptString:appAtt];
    [ScanLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:logId,@"c",appAtt,@"a", nil]];
}

-(void)saveHistory{
    HistoryObject *historyobject = [[HistoryObject alloc] init];
    historyobject.type = [DATA_ENV getCodeType:_category.type];
    historyobject.content = _showInfo;
    historyobject.isEncode=NO;
    historyobject.image= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
    [FileUtil writeImage:_saveImage toFileAtPath:[FileUtil filePathInScan:historyobject.image]];
    [[DataBaseOperate shareData] insertHistory:historyobject];
    [historyobject release];
}
-(void)showAlertView:(NSString*)title{
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:title message:@"/n/n/n"
                                                           delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];  
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,45,252,25)];  
    _passwordField.font = [UIFont systemFontOfSize:21];  
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.secureTextEntry = YES;  
    _passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;  
    [_passwordField becomeFirstResponder];  
    [passwordAlert addSubview:_passwordField];  
    [passwordAlert setTransform:CGAffineTransformMakeTranslation(0,0)];  
    [passwordAlert show];  
    [passwordAlert release];  
    [_passwordField release];  
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
         NSArray *list = [BusDecoder parse0:_content];
         EncText *object = [[BusDecoder decode:list className:@"EncText"] retain];
        //EncText *object = [[BusDecoder decode:list key:_passwordField.text] retain];
        
        if (![object.key isEqualToString:_passwordField.text]) {
            [self showAlertView:@"密码不正确，请重新输入！"];
            return;
        }
        [_titleArray addObject:@"密钥"];
        [_titleArray addObject:@"文本内容"];
        [_contentArray addObject:object.key];
        [_contentArray addObject:object.content];
        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
        _hideContentIndex = 1;
        [_tableView reloadData];
        _showInfo = [object.content retain];
        if (_historyType == HistoryTypeFavAndHistory) {
//            if (object.logId) {
//                [self sendMessage:object.logId];
//            }
            [self saveHistory];
        }
        [object release];
    }
}

-(NSString*)getStringFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return  dateStr;
}

-(NSString*)getString16:(int)type
{  
    type=type+1;
    unsigned char typeUn = (unsigned char)type;
    NSString *type16 = [NSString stringWithFormat:@"%02X", typeUn];
    return type16;
    
}


-(BOOL)isHaveString:(NSString*)content param:(NSString*)param
{
    NSRange range = [content rangeOfString: param];
    if (range.length > 0) {
    return YES;
    }else {
    return NO;
    }
}


-(void)decodeInput{
    
    _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    _contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    _typeArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *logId=@"";
    
    //首先判断是不是新的编码规则
    //id oRet = nil;
    NSString *input = [iOSApi urlDecode:_content];
    if (input != nil) {
        if ([input hasPrefix:API_CODE_PREFIX]) {
            // 是码开头的, 截取字符串, 去掉前缀
            NSString *str = [input substringFromIndex:[API_CODE_PREFIX length]];
            if ([str hasPrefix:@"id="]) {
                // 富媒体, 或者空码, 转换地址
                NSString *iskma = [str substringFromIndex:3];
                 NSString *url = [NSString stringWithFormat:@"%@/apps/getCode.action?%@",API_APPS_SERVER,str];
                if([iskma rangeOfString:@"-"].length>0)
                {
                
                UCRichMedia *nextView = [[UCRichMedia alloc] init];
                nextView.urlMedia = url;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
                    //return;
                    
                } else {
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSString valueOf:[Api userId]], @"userid",
                                            nil];
                NSDictionary *map = [Api post:url params:params];
               
               
                if (map.count > 0) 
                    {
                    
                    NSString *status =[NSString stringWithFormat:@"%d", [Api getInt:[map objectForKey:@"status"]]];
                       // NSLog(@"%@",status);    
                    if ([status isEqualToString:@"404"]) {
                        //跳到空码赋值
                        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
                        //nextView.bKma = YES; // 标记为空码赋值富媒体
                        nextView.code = iskma;
                        nextView.curImage = [Api generateImageWithInput:input];
                        [self.navigationController pushViewController:nextView animated:YES];
                        [nextView release];
                        //return;
                        
                        }  else  {
                        //进行解码    
                         
                            
                            if([[map objectForKey:@"data"] isKindOfClass:[NSString class]])
                            {
                                
                                //NSLog(@"//普通解码");
                                [_content release];
                                _content=nil;
                                _content =  [[NSString stringWithFormat:@"%@%@", API_CODE_PREFIX,[map objectForKey:@"data"]] retain];
                                [self decodeInput];
                                
                            }
                            else {
                                
                                //NSLog(@"//服媒体");
                                UCRichMedia *nextView = [[UCRichMedia alloc] init];
                                nextView.urlMedia = url;
                                [self.navigationController pushViewController:nextView animated:YES];
                                [nextView release];
                               // return;
                                
                            }
                            
                            
                        }
                        
                    }

                    
                }
                
                // 请求服务器
            } else {
                // 普通码规则, 前两位是十六进制串
                const char *s = [[str substringToIndex:2] UTF8String];
                int type = -1;
                sscanf(s, "%02X", &type);
                if (type > 0) {
                    // 已经取到类型了, 进一步剥离类型, 取的编码串
                    str = [str substringFromIndex:2];
                    // 下面的这个数组的内容, 就是从A开始的连续的值
                    NSArray *list = [BusDecoder parse0:str];

                    if (type == 1) {
                       
                        _titleLabel.text= @"网址解码";
                        Url *object = [[BusDecoder decode:list className:@"Url"]retain];
                        [_titleArray addObject:@"网址"];
                        [_contentArray addObject:object.content];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeUrl]];
                        _showInfo = object.content;
                            logId = object.logId;
                        [object release];
   
                    }
                    else if(type==2)
                    {
                        _titleLabel.text= @"书签解码";
                        BookMark *object =[[BusDecoder decode:list className:@"BookMark"]retain];
                        [_titleArray addObject:@"网址名称"];
                        [_titleArray addObject:@"网址"];
                        [_contentArray addObject:object.title];
                        [_contentArray addObject:object.url];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeUrl]];
                        _showInfo = object.title;
                        logId = object.logId;
                        [object release];
                        
                    }
                    else if(type==3) {
                        AppUrl *object =[[BusDecoder decode:list className:@"AppUrl"]retain];
                        _titleLabel.text= @"应用程序解码";
                        
                        [_titleArray addObject:@"应用名称"];
                        [_titleArray addObject:@"下载地址"];
                        [_contentArray addObject:object.title];
                        [_contentArray addObject:object.url];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeAppUrl]];
                        _showInfo = object.url;
                        logId = object.logId;
                        [object release];
                    }
                    else if(type==4) {
                        _titleLabel.text= @"微博解码";
                        Weibo *object =[[BusDecoder decode:list className:@"Weibo"]retain];

                        [_titleArray addObject:@"博主"];
                        [_titleArray addObject:@"微博地址"];
                        [_contentArray addObject:object.title];
                        [_contentArray addObject:object.url];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeUrl]];
                        _showInfo = object.title;
                        logId = object.logId;
                        [object release];

                    }
                    else if(type==5) {
                        
                        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:_category result:str withImage:_image withType:HistoryTypeFavAndHistory withSaveImage:_saveImage];
                            [self.navigationController pushViewController:cardView animated:YES];
                              RELEASE_SAFELY(cardView);
                        
                    }
                    else if(type==6) {

                        _titleLabel.text= @"电话解码";
                        Phone *object = [[BusDecoder decode:list className:@"Phone"]retain];
                        
                        [_titleArray addObject:@"电话号码"];
                        [_contentArray addObject:object.telephone];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeCardPhone]];
                        _showInfo = object.telephone;
                        logId = object.logId;
                        [object release];

                    }
                    else if(type==7) {
                        _titleLabel.text= @"电子邮件解码";
                        Email *object = [[BusDecoder decode:list className:@"Email"]retain];
                        [_titleArray addObject:@"标题"];
                        [_titleArray addObject:@"E-Mail"];
                        [_titleArray addObject:@"内容"];
                        [_contentArray addObject:object.title];
                        [_contentArray addObject:object.mail];
                        [_contentArray addObject:object.contente];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeEmailText]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeEmailText]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeEmailText]];
                        _hideContentIndex = 2;
                        _showInfo = object.title;
                        logId = object.logId;
                        [object release];

                        
                    }  else if(type==8) {
                        _titleLabel.text= @"文本解码";
                        Text *object =[[BusDecoder decode:list className:@"Text"]retain];
                        [_titleArray addObject:@"文本内容"];
                        [_contentArray addObject:object.content];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
                        _hideContentIndex = 0;
                        _showInfo = object.content;
                        logId = object.logId;
                        [object release];

                        
                        
                    }else if(type==9) {
                        _titleLabel.text= @"加密文本解码";
                        [self showAlertView:@"输入密码"];                        
                    }
                    else if(type==10) {
                        _titleLabel.text= @"短信解码";
                        ShortMessage *object = [[BusDecoder decode:list className:@"Shortmessage"] retain];
                        [_titleArray addObject:@"接收人"];
                        [_titleArray addObject:@"短信内容"];
                        [_contentArray addObject:object.cellphone];
                        [_contentArray addObject:object.contente];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypePhone]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeSms]];
                        _hideContentIndex = 1;
                        _showInfo = object.contente;
                        logId = object.logId;
                        [object release];
                      
                    }
                    else if(type==11) {
                        _titleLabel.text= @"WIFI解码";
                        WiFiText *object =[[BusDecoder decode:list className:@"WifiText"]retain];
                        [_titleArray addObject:@"名称"];
                        [_titleArray addObject:@"密码"];
                        [_contentArray addObject:object.name];
                        [_contentArray addObject:object.password];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeTitle]];
                        _showInfo = object.name;
                        logId = object.logId;
                        [object release];

                        
                    }
                    else if(type==12) {
                        _titleLabel.text= @"地图解码";
                        GMap *object = [[BusDecoder decode:list className:@"GMap"]retain];
                        [_titleArray addObject:@"坐标"];
                        [_contentArray addObject:object.url];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeMap]];
                        NSArray *arr = [object.url componentsSeparatedByString:@"="];
                        if ([arr count]>0) {
                            _showInfo = [[arr objectAtIndex:1] retain];
                            arr = [_showInfo componentsSeparatedByString:@"&"];
                            if (arr) {
                                _showInfo = [[arr objectAtIndex:0] retain];
                            }else{
                                _showInfo = object.url;
                            }
                        }else{
                            _showInfo = object.url;
                        }
                        logId = object.logId;
                        [object release];

                        
                        
                    }else if(type==13)
                    {
                        _titleLabel.text= @"日程解码";
                        Schedule *object = [[BusDecoder decode:list className:@"Schedule"] retain];
                        [_titleArray addObject:@"时间"];
                        [_titleArray addObject:@"标题"];
                        [_titleArray addObject:@"内容"];
                        [_contentArray addObject:object.date];
                        [_contentArray addObject:object.title];
                        [_contentArray addObject:object.content];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
                        [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
                        _hideContentIndex = 2;
                        _showInfo = object.title;
                        logId = object.logId;
                        [object release];

                    }
                   

                }
                
            }
        } else {
            // 不是, 咋办?
            if ([input hasPrefix:@"http://"]) {
                // 网址类型
                Url *object = [[[Url alloc] init] retain];
                [object setContent:input];
                
                _titleLabel.text= @"网址解码";
               
                [_titleArray addObject:@"网址"];
                [_contentArray addObject:object.content];
                [_typeArray addObject:[NSNumber numberWithInt:LinkTypeUrl]];
                _showInfo = object.content;
                logId = object.logId;
                [object release];
                // oRet = u;
            } else {
                // 文本类型
                Text *object = [[[Text alloc] init] retain];
                [object setContent:input];
                //oRet = t;
                _titleLabel.text= @"文本解码";
               
                [_titleArray addObject:@"文本内容"];
                [_contentArray addObject:object.content];
                [_typeArray addObject:[NSNumber numberWithInt:LinkTypeText]];
                _hideContentIndex = 0;
                _showInfo = object.content;
                logId = object.logId;
                [object release];
            }
        }
    }
  
    [_tableView reloadData];
    if (_historyType == HistoryTypeFavAndHistory) {
//       if (logId) {
//            [self sendMessage:logId];
//        }
        [self saveHistory];
    }
}
-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([request isKindOfClass:[ScanLogDataRequest class]]) {
    }
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageView.resizeType = ITTImageResizeTypeScaleByMinSide;
    [_imageView setDefaultImage:_image];
    _tableView.tableHeaderView = _headerView;
    
    //给图片添加阴影
    UIImageView * imgbg = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"decode_codeBG.png"]toSize:CGSizeMake(150+10, 150+10)]];
    imgbg.frame=CGRectMake(CGRectGetMinX(_imageView.frame), CGRectGetMinY(_imageView.frame), _imageView.width+10, _imageView.height+10);
    [_imageView.superview addSubview:imgbg];
    [_imageView.superview sendSubviewToBack:imgbg];
    [imgbg release];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"黑体" size:60];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text= @"解码";
    self.navigationItem.titleView = _titleLabel;
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    
    if (returnFlag == YES) {
        [backbtn setImage:[UIImage imageNamed:@"decode_camera.png"] forState:UIControlStateNormal];
        [backbtn setImage:[UIImage imageNamed:@"decode_camera_tap.png"] forState:UIControlStateHighlighted];
        [backbtn addTarget:self action:@selector(goPhoto) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
        [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }


    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 60, 32);
//    [btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"share_tap.png"] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(shareCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    if (_historyType==HistoryTypeNone || _historyType==HistoryTypeFav) {
        _favBtn.hidden=YES;
    }
    
    [self decodeInput];
}

- (int)getHeight:(NSString*)text
{
	CGSize LabelSize = [text sizeWithFont:[UIFont systemFontOfSize:17] 
						   constrainedToSize:CGSizeMake(280, 40000)
							   lineBreakMode:UILineBreakModeWordWrap];
	return LabelSize.height;
}

#pragma mark - UITableViewDataSource method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height = 44;
//    if (indexPath.row==_hideContentIndex) {
//        height = [self getHeight:[_contentArray objectAtIndex:indexPath.row]];
//        if (height>37) {
//            height = height+8;
//        }else{
//            height = 44;
//        }
//        height+=44;
//    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DecodeCardCell";   
    DecodeBusinessCell *cell = (DecodeBusinessCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [DecodeBusinessCell cellFromNib]; 
        cell.delegate = self;
    }
    
    UIImage * cell_img =[[UIImage imageNamed:@"decode_cell.png"]toSize:CGSizeMake(300, 50)];
    [cell setBackgroundImage:cell_img];
    
    [cell initDataWithTitile:[_titleArray objectAtIndex:indexPath.row] withText:[_contentArray objectAtIndex:indexPath.row] withType:[[_typeArray objectAtIndex:indexPath.row] intValue]];
    if (indexPath.row == _hideContentIndex) {
        cell.contentLabel.numberOfLines=0;
    }
    return cell;
}

-(void)hidePopButton{
    for (int i =0; i<[_titleArray count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DecodeBusinessCell *curCell = (DecodeBusinessCell*)[_tableView cellForRowAtIndexPath:indexPath];
        [curCell removePopButton]; 
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hidePopButton];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hidePopButton];
}

#pragma mark -
#pragma mark SMS

-(void)launchSmsAppOnDevice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持发送短信！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -

#pragma mark Componse sms

-(void)displaySMSComposerSheet{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    if ([_category.type isEqualToString:CATEGORY_SHORTMESS]) {
        picker.body = [_contentArray objectAtIndex:1];
        picker.recipients = [NSArray arrayWithObjects:[_contentArray objectAtIndex:0], nil];
    }else if ([_category.type isEqualToString:CATEGORY_PHONE]) {
        picker.recipients = [NSArray arrayWithObjects:[_contentArray objectAtIndex:0], nil];
    }else if ([_category.type isEqualToString:CATEGORY_SCHEDULE]) {
        picker.body = [_contentArray objectAtIndex:2];
    }else if ([_category.type isEqualToString:CATEGORY_TEXT]) {
        picker.body = [_contentArray objectAtIndex:0];
    }else if ([_category.type isEqualToString:CATEGORY_ENCTEXT]) {
        picker.body = [_contentArray objectAtIndex:1];
    }
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)showSms{
    Class smsClass = NSClassFromString(@"MFMessageComposeViewController");
    if (smsClass != nil) {
        if ([smsClass canSendText]){
            [self displaySMSComposerSheet];
        } else {
            [self launchSmsAppOnDevice];
        }
    } else {
        [self launchSmsAppOnDevice];
    }

}

-(void)showMail{
    SHKItem *item = [SHKItem text:@""];
    item.shareType = SHKShareTypeText;
    if ([_category.type isEqualToString:CATEGORY_EMAIL]) {
        item.title = [_contentArray objectAtIndex:0];
        item.toRecipients = [NSArray arrayWithObjects:[_contentArray objectAtIndex:1], nil];
        item.text = [_contentArray objectAtIndex:2];
    }else if ([_category.type isEqualToString:CATEGORY_SCHEDULE]) {
        item.title = [_contentArray objectAtIndex:1];
        item.text = [_contentArray objectAtIndex:2];
    }else if ([_category.type isEqualToString:CATEGORY_TEXT]) {
        item.text = [_contentArray objectAtIndex:0];
    }else if ([_category.type isEqualToString:CATEGORY_ENCTEXT]) {
        item.text = [_contentArray objectAtIndex:1];
    }
    [SHKMail shareItem:item];
}
#pragma mark Componse sms
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)addFavirote:(id)sender {
    FaviroteObject *object = [[FaviroteObject alloc] init];
    object.type = [DATA_ENV getCodeType:_category.type];
    object.content = _showInfo;
    object.image= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
    [FileUtil writeImage:_saveImage toFileAtPath:[FileUtil filePathInFavirote:object.image]];
    [[DataBaseOperate shareData] insertFavirote:object];
    [object release];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加收藏成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    _favBtn.enabled = NO;
    [_favBtn setImage:[UIImage imageNamed:@"faviroted.png"] forState:UIControlStateNormal];
}

-(void)finishShare:(NSNotification*)notification{
    NSString *info= [NSString stringWithFormat:@"eqn=%@&version=%@",[[UIDevice currentDevice] uniqueIdentifier],[iOSApi version]];
    info = [EncryptTools Base64EncryptString:info];
    NSString *type = [notification.userInfo objectForKey:@"type"];
    if ([type isEqualToString:@"sina"]) {
        [WeiboShareLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"t",info,@"a", nil]];
    } else if ([type isEqualToString:@"tencent"]) {
        [WeiboShareLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"t",info,@"a", nil]];
    } else if ([type isEqualToString:@"mail"]) {
        [ShareLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"t",info,@"a", nil]];
    }
}

-(void)finishShareAuth:(NSNotification*)notification{
    NSString *info= [NSString stringWithFormat:@"eqn=%@&version=%@",[[UIDevice currentDevice] uniqueIdentifier],[iOSApi version]];
    info = [EncryptTools Base64EncryptString:info];
    NSString *type = [notification.userInfo objectForKey:@"type"];
    if ([type isEqualToString:@"sina"]) {
        [AuthorizeLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"t",info,@"a", nil]];
    } else if ([type isEqualToString:@"tencent"]) {
        [AuthorizeLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"t",info,@"a", nil]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishShare:) name:SHARE_FINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishShareAuth:) name:SHARE_AUTH_FINISH object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHARE_FINISH object:nil];
}

- (void)viewDidUnload
{
    _imageView = nil;
    _tableView = nil;
    _headerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_image release];
    [_saveImage release];
    [_content release];
    [_titleArray release];
    [_contentArray release];
    [_typeArray release];
    [_titleLabel release];
    [_category release];
    [_imageView release];
    [_tableView release];
    [_favBtn release];
    [_headerView release];
    [super dealloc];
}
@end
