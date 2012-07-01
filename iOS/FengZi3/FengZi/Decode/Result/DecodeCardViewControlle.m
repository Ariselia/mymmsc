//
//  DecodeCardViewControlle.m
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "DecodeCardViewControlle.h"
#import <FengZi/BusDecoder.h>
#import "FileUtil.h"
#import "Api+Database.h"
#import <FengZi/Api+Category.h>
#import "CommonUtils.h"
#import <FengZi/PseudoBase64.h>
#import "SHK.h"
#import "ShareView.h"
#import "CONSTS.h"

@implementation DecodeCardViewControlle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil category:(BusCategory *)cate  result:(NSString *)input withImage:(UIImage *)image withType:(HistoryType)type withSaveImage:(UIImage*)sImage{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        _category = [cate retain];
        _content = [input retain];
        _curImage = [image retain];
        _saveImage = [sImage retain];
        _historyType=type;
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
}

-(void)shareCode{
    [[SHK currentHelper] setRootViewController:self];
    SHKItem *item = [SHKItem text:@"快来扫码，即有惊喜！\n来自蜂子客户端"];
    item.image = _curImage;
    item.shareType = SHKShareTypeImage;
    item.title = @"快来扫码，即有惊喜！";
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];
//    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"名片解码";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
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
    // 下面的这个数组的内容, 就是从A开始的连续的值
    NSDictionary *list = [BusDecoder parse0:_content];
    _card = [[BusDecoder decode:list className:@"Card"] retain];
    
    if (_historyType == HistoryTypeFavAndHistory) {
        if (_card.logId) {
            NSString *appAtt = [NSString stringWithFormat:@"eqn=%@&type=%@&stype=%d&loc=%@",[[UIDevice currentDevice] uniqueIdentifier],[DATA_ENV getDecodeType:_category.type],DATA_ENV.curScanType,DATA_ENV.curLocation];
            appAtt = [PseudoBase64 encode:appAtt];
            [ScanLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:_card.logId,@"c",appAtt,@"a", nil]];
        }
        HistoryObject *historyobject = [[HistoryObject alloc] init];
        historyobject.type = [DATA_ENV getCodeType:_category.type];
        historyobject.content = _card.name;
        historyobject.isEncode=NO;
        historyobject.image= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
        [FileUtil writeImage:_saveImage toFileAtPath:[FileUtil filePathInScan:historyobject.image]];
        [[DataBaseOperate shareData] insertHistory:historyobject];
        [historyobject release];
    }
    if (_historyType==HistoryTypeNone || _historyType==HistoryTypeFav) {
        _favBtn.hidden=YES;
    }
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([request isKindOfClass:[ScanLogDataRequest class]]) {
    }
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)selectPhone{
    CFErrorRef error =NULL;
    
    //打开数据库
    ABRecordRef personRef=ABPersonCreate();
    //添加单个项的属性值，如姓、名、生日、职务、公司...
    ABRecordSetValue(personRef, kABPersonFirstNameProperty,(CFStringRef*)_card.name, &error);
    
    //如果lastname为空，则不要使用此句，否则电话薄排序显示会有问题，会将其归入#那类中
    //ABRecordSetValue(person, kABPersonLastNameProperty, CFSTR(""), &error);
    
    //用于存放具有多个值的项
    ABMutableMultiValueRef multi=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //电话号码属于具有多个值的项（除此还有email、地址类）
    if (_card.cellphone) {
        ABMultiValueAddValueAndLabel(multi, (CFStringRef*)_card.cellphone, kABPersonPhoneMobileLabel, NULL);
    }
    if (_card.telephone) {
        ABMultiValueAddValueAndLabel(multi, (CFStringRef*)_card.telephone, kABPersonPhoneMainLabel, NULL);
    }
    if (_card.qq) {
        ABMultiValueAddValueAndLabel(multi, (CFStringRef*)_card.qq, kABPersonInstantMessageServiceQQ, NULL);
    }
    if (_card.fax) {
        ABMultiValueAddValueAndLabel(multi, (CFStringRef*)_card.fax, kABPersonPhoneWorkFAXLabel, NULL);
    }
    ABRecordSetValue(personRef, kABPersonPhoneProperty, multi, &error);    
    
    if (_card.msn) {
        ABMultiValueRef ABmessaging = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *dMessaging = [[NSMutableDictionary alloc] init];
        [dMessaging setObject:_card.msn forKey:(NSString *) kABPersonInstantMessageUsernameKey];
        [dMessaging setObject:@"MSN" forKey:(NSString *)kABPersonInstantMessageServiceKey];
        ABMultiValueAddValueAndLabel(ABmessaging, dMessaging, kABPersonInstantMessageServiceMSN, NULL);
        [dMessaging release];
        ABRecordSetValue(personRef, kABPersonInstantMessageProperty, ABmessaging, &error);
        CFRelease(ABmessaging);
    }
    
    //清空该变量用于存放下一个多值的项
    CFRelease(multi);
    if (_card.email) {
        //email也属于具有多个项的值
        ABMutableMultiValueRef multii = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multii,(CFStringRef*)_card.email, kABWorkLabel, NULL);
        ABRecordSetValue(personRef, kABPersonEmailProperty, multii, &error);
        CFRelease(multii);
    }
    if (_card.department) {
        ABRecordSetValue(personRef, kABPersonDepartmentProperty, (CFStringRef*)_card.department, &error);
    }
    if (_card.corporation) {
        ABRecordSetValue(personRef, kABPersonOrganizationProperty, (CFStringRef*)_card.corporation, &error);
    }
    if (_card.title) {
        ABRecordSetValue(personRef, kABPersonJobTitleProperty, (CFStringRef*)_card.title, &error);
    }
    
    ABMutableMultiValueRef multiia = ABMultiValueCreateMutable(kABDictionaryPropertyType);
    // Set up keys and values for the dictionary.
    CFStringRef keys[2];
    CFStringRef values[2];
    keys[0]      = kABPersonAddressStreetKey;
    keys[1]      = kABPersonAddressZIPKey;
    values[0]    = _card.address?(CFStringRef)_card.address:CFSTR("");
    values[1]    = _card.zipCode?(CFStringRef)_card.zipCode:CFSTR("");
    CFDictionaryRef aDict = CFDictionaryCreate(kCFAllocatorDefault,
                                               (void *)keys,
                                               (void *)values,
                                               2,
                                               &kCFCopyStringDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks
                                               );
    ABMultiValueIdentifier identifier;
    ABMultiValueAddValueAndLabel(multiia, aDict, kABHomeLabel, &identifier);    
    ABRecordSetValue(personRef, kABPersonAddressProperty, multiia, &error);
    CFRelease(aDict);    
    CFRelease(multiia);    

    if (_card.url) {
        ABMutableMultiValueRef multii = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multii,(CFStringRef*)_card.url, kABPersonHomePageLabel, NULL);
        ABRecordSetValue(personRef, kABPersonURLProperty, multii, &error);
        CFRelease(multii);
    }
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        if (_card.weibo) {
            ABMultiValueRef ABmessaging = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
            NSMutableDictionary *dMessaging = [[NSMutableDictionary alloc] init];
            [dMessaging setObject:_card.weibo forKey:(NSString *)kABPersonSocialProfileUsernameKey];
            [dMessaging setObject:@"微博" forKey:(NSString *)kABPersonSocialProfileServiceKey];
            ABMultiValueAddValueAndLabel(ABmessaging, dMessaging, kABPersonSocialProfileURLKey, NULL);
            [dMessaging release];
            ABRecordSetValue(personRef, kABPersonSocialProfileProperty, ABmessaging, &error);
            CFRelease(ABmessaging);
        }
    }
    //添加并保存到地址本中
    ABAddressBookRef addressbookRef=ABAddressBookCreate();
    ABAddressBookAddRecord(addressbookRef, personRef, &error);
    ABAddressBookSave(addressbookRef, &error);
    
   
    CFRelease(personRef);
    CFRelease(addressbookRef); 
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加名片到通讯录成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    IOSAPI_RELEASE(alertView);
    _phoneBtn.enabled = NO;
}


-(void)addFavirote{
    FaviroteObject *object = [[FaviroteObject alloc] init];
    object.type = kModelCard;
    object.content = _card.name;
    object.image= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
    [FileUtil writeImage:_saveImage toFileAtPath:[FileUtil filePathInFavirote:object.image]];
    if( [[DataBaseOperate shareData] checkFaviroteExists:object.content type:kModelCard])
    {
        [object release];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收藏过！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        
    }
    else {
        [[DataBaseOperate shareData] insertFavirote:object];
        [object release];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加收藏成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
    }
    
    
    
    _favBtn.enabled = NO;
    [_favBtn setImage:[UIImage imageNamed:@"faviroted.png"] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 60;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DecodeCardCell";    
    DecodeCardCell *cell = (DecodeCardCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [DecodeCardCell cellFromNib]; 
        cell.delegate=self;
    }    
    switch (indexPath.row) {
        case 0:{
            _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_phoneBtn addTarget:self action:@selector(selectPhone) forControlEvents:UIControlEventTouchUpInside];
            [_phoneBtn setImage:[UIImage imageNamed:@"add_address.png"] forState:UIControlStateNormal];
            [_phoneBtn setImage:[UIImage imageNamed:@"add_address_tap.png"] forState:UIControlStateHighlighted];
            
            _favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_favBtn addTarget:self action:@selector(addFavirote) forControlEvents:UIControlEventTouchUpInside];
            [_favBtn setImage:[UIImage imageNamed:@"favirote.png"] forState:UIControlStateNormal];
            [_favBtn setImage:[UIImage imageNamed:@"favirote_tap.png"] forState:UIControlStateHighlighted];
            
            [cell addPhoneButton:_phoneBtn withFavirote:_favBtn];
            [cell initDataWithTitile: @"姓名" withName:_card.name withType:LinkTypeNone];
            break;
        }
        case 1:
            [cell initDataWithTitile:@"公司" withName:_card.corporation  withType:LinkTypeCompany];
            break;
        case 2:
            [cell initDataWithTitile:@"职位名称" withName:_card.title withType:LinkTypeNone];
            break;
        case 3:
            [cell initDataWithTitile: @"公司部门" withName:_card.department withType:LinkTypeNone];
            break;
        case 4:
            [cell initDataWithTitile: @"固定电话" withName:_card.telephone withType:LinkTypePhone];
            break;
        case 5:
            [cell initDataWithTitile: @"公司网址" withName:_card.url withType:LinkTypeUrl];
            break;
        case 6:
            [cell initDataWithTitile: @"公司传真" withName:_card.fax withType:LinkTypePhone];
            break;
        case 7:
            [cell initDataWithTitile: @"移动电话" withName:_card.cellphone withType:LinkTypeCardPhone];
            break;
        case 8:
            [cell initDataWithTitile: @"公司地址" withName:_card.address withType:LinkTypeMap];
            break;
        case 9:
            [cell initDataWithTitile: @"电子邮箱" withName:_card.email withType:LinkTypeEmail];
            break;
        case 10:
            [cell initDataWithTitile: @"邮政编码" withName:_card.zipCode withType:LinkTypeNone];
            break;
        case 11:
            [cell initDataWithTitile: @"QQ" withName:_card.qq withType:LinkTypeNone];
            break;
        case 12:
            [cell initDataWithTitile: @"MSN" withName:_card.msn withType:LinkTypeNone];
            break;
        case 13:
            [cell initDataWithTitile: @"个人微博" withName:_card.weibo withType:LinkTypeWeibo];
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)hidePopButton{
    for (int i =0; i<14; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DecodeCardCell *curCell = (DecodeCardCell*)[_tableView cellForRowAtIndexPath:indexPath];
        [curCell removePopButton]; 
    }
}

-(void)finishShare:(NSNotification*)notification{    
    NSString *info= [NSString stringWithFormat:@"eqn=%@&version=%@",[[UIDevice currentDevice] uniqueIdentifier],[iOSApi version]];
    info = [PseudoBase64 encode:info];
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
    info = [PseudoBase64 encode:info];
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
    [_tableView release];
    _tableView = nil;
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
    [_saveImage release];
    [_curImage release];
    [_content release];
    [_category release];
    [_card release];
    [_tableView release];
    [super dealloc];
}
@end
