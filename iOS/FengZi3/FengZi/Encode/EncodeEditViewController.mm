//
//  EncodeEditViewController.m
//  FengZi
//
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeEditViewController.h"
#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>
#import "UIUtil.h"
#import "NotePLogService.h"
#import "BusEncoder.h"
#import "Api+Database.h"
#import "FileUtil.h"
#import "EncryptTools.h"
#import "SHK.h"
#import "ShareView.h"

//#import "RichMedia.h"

@implementation EncodeEditViewController

@synthesize encodeImageView =_encodeImageView;
@synthesize type = _type, content = _content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _content = @"";
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

-(UIImage*)getResultImage{
    UIImage *image;
    if (_isDefaultSkin) {
        image = _encodeImageView.image;
    }else {
        UIGraphicsBeginImageContext(_backgroundView.bounds.size);
        [_backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

-(void)sendMessage:(UIImage*)image withSave:(BOOL)isSave{
    NSString *appAtt = [NSString stringWithFormat:@"eqn=%@&type=%@&stype=%d&loc=%@",[[UIDevice currentDevice] uniqueIdentifier],[DATA_ENV getEncodeCodeType:DATA_ENV.curBusinessType],DATA_ENV.curScanType,DATA_ENV.curLocation];
    appAtt = [EncryptTools Base64EncryptString:appAtt];
    
    [MakeLogDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:_logId,@"c",appAtt,@"a", nil]];
    if (isSave) {
        HistoryObject *historyobject = [[HistoryObject alloc] init];
        historyobject.type = DATA_ENV.curBusinessType;
        historyobject.content = _showInfo;
        historyobject.isEncode = YES;
        historyobject.image= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
        //[FileUtil writeImage:_encodeImageView.image toFileAtPath:[FileUtil filePathInEncode:historyobject.image]];
        [FileUtil writeImage:[_encodeImageView.image toSize:CGSizeMake(API_QRCODE_DIMENSION, API_QRCODE_DIMENSION)] toFileAtPath:[FileUtil filePathInEncode:historyobject.image]];
        [[DataBaseOperate shareData] insertHistory:historyobject];
        [historyobject release];
    }
}

-(void)shareCode{
    [[SHK currentHelper] setRootViewController:self];
    SHKItem *item = [SHKItem text:@"我制做一个超炫的二维码，大家快来扫扫看！\n来自蜂子客户端"];
    item.image = [self getResultImage];
    item.shareType = SHKShareTypeImage;
    item.title = @"我制做一个超炫的二维码，大家快来扫扫看！";
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];
//    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([request isKindOfClass:[MakeLogDataRequest class]]) {
    }
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
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
    label.text= @"生成";
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
    btn.frame = CGRectMake(0, 0, 60, 32);
    [btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"share_tap.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(shareCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    _backgroundView.layer.shadowOffset = CGSizeMake(5, 5);
    _backgroundView.layer.shadowRadius = 6.0;
    _backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundView.layer.shadowOpacity = 0.8;
    
    _isDefaultSkin = YES;
    _camecaBtn.hidden = YES;
//    _backgoundImage.resizeType = ITTImageResizeTypeScaleByMaxSide;
    
    _decorateView = [(DecorateView*)[[[NSBundle mainBundle] loadNibNamed:@"DecorateView" owner:self options:nil] objectAtIndex:0] retain];
    _decorateView.delegate =self;
    _decorateView.alpha = 0;
    _decorateView.frame = CGRectMake(5, 263, 310, 58);
    [self.view addSubview:_decorateView];
}

- (UIImage *)addTwoImageToOne:(UIImage *) bigImg twoImage:(UIImage *) twoImg
{
	UIGraphicsBeginImageContext(bigImg.size);
	[bigImg drawInRect:CGRectMake(0, 0, bigImg.size.width, bigImg.size.height)];
    double rec = bigImg.size.width*bigImg.size.height*0.2;
    double qu = sqrt(rec);
	[twoImg drawInRect:CGRectMake((bigImg.size.width-qu)/2, (bigImg.size.height-qu)/2, qu, qu)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resultImg;
}

- (IBAction)tapOnSaveBtn:(id)sender {
    _saveBtn.enabled = NO;
    UIImage *image = [self getResultImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self sendMessage:image withSave:YES];
}

- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo;{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存图片" message:@"保存到相册成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    _saveBtn.enabled = YES;
}

-(void)generateCode{
    NSArray *arr = [UIUtil changeUIColorToRGB:_curColor];
    int red = [[arr objectAtIndex:0] intValue];
    int green = [[arr objectAtIndex:1] intValue];
    int blue = [[arr objectAtIndex:2] intValue];
    int qrcodeImageDimension = API_QRCODE_DIMENSION;
    //the string can be very long
    NSString* aVeryLongURL = _content;
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    int qr_level = QR_ECLEVEL_L;
    if (DATA_ENV.encodeImageType == EncodeImageTypeIcon) {
        qr_level = QR_ECLEVEL_H;
    }
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:qr_level version:QR_VERSION_AUTO string:aVeryLongURL];
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension colorRed:red colorGreen:green colorBlue:blue];
    if (DATA_ENV.encodeImageType == EncodeImageTypeIcon && _curIcon != nil) {
        _encodeImageView.image = [self addTwoImageToOne:qrcodeImage twoImage:_curIcon];
    }else{
        _encodeImageView.image = qrcodeImage;
    }
}

- (void)getCodeString{
    _logId = [[NotePLogService encodeEnc:_codeAtt] retain];
    switch (DATA_ENV.curBusinessType) {
        case BusinessTypeUrl:{
            Url *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.content;
            //_content = [[BusEncoder encodeUrl:obj] retain];
            _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];

            break;
        }
        case BusinessTypeCard:{
            Card *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.name;
           // _content = [[BusEncoder encodeCard:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeGmap:{
            GMap *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = [[[obj.url componentsSeparatedByString:@"="] objectAtIndex:1] retain];
            _showInfo = [[[_showInfo componentsSeparatedByString:@"&"] objectAtIndex:0] retain];
           // _content = [[BusEncoder encodeGMap:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }case BusinessTypeText:{
            Text *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.content;
            
            
            //_content = [[BusEncoder encodeText:obj] retain];
            //_content = [[BusEncoder encode:obj type:BusinessTypeText]retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeEmail:{
            Email *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
            //_content = [[BusEncoder encodeEmail:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypePhone:{
            Phone *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.telephone;
            //_content = [[BusEncoder encodePhone:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeWeibo:{
            Weibo *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
          //  _content = [[BusEncoder encodeWeibo:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeAppUrl:{
            AppUrl *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
           // _content = [[BusEncoder encodeAppUrl:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeEncText:{
            EncText *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.content;
           // _content = [[BusEncoder encodeEncText:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeBookMark:{
            BookMark *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
            _content = [[BusEncoder encodeBookMark:obj] retain];
            break;
        }
        case BusinessTypeSchedule:{
            Schedule *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
           // _content = [[BusEncoder encodeSchedule:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeWifiText:{
            WiFiText *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.name;
           // _content = [[BusEncoder encodeWifiText:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeShortMessage:{
            ShortMessage *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.contente;
         //   _content = [[BusEncoder encodeShortmessage:obj]retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        case BusinessTypeRichMedia:{
            RichMedia *obj = _codeObject;
            obj.logId = _logId;
            _showInfo = obj.title;
           // _content = [[BusEncoder encodeRichMedia:obj] retain];
              _content = [[BusEncoder encode:obj type:DATA_ENV.curBusinessType]retain];
            break;
        }
        default:
            break;
    }
}

- (void)loadObject:(id)object{
    _codeObject = [object retain];
    _codeAtt = [[CodeAttribute alloc]init];
    _codeAtt.type = [DATA_ENV getEncodeCodeType:DATA_ENV.curBusinessType];
    _codeAtt.color= [DATA_ENV getHexColorWithIndex:0];
    _curColor = [[DATA_ENV getColorWithIndex:0] retain];
    if (DATA_ENV.encodeImageType == EncodeImageTypeCommon) {
        _editIconBtn.hidden = YES;
    }else{
        _codeAtt.hasLogo = 1;
    }
    [self getCodeString];
    [self generateCode];
}

-(void)colorSelect:(UIColor *)color withIndex:(int)index{
    _curColor = [color retain];
    _codeAtt.color= [DATA_ENV getHexColorWithIndex:index];
    [self getCodeString];
    [self generateCode];
}

-(void)iconSelected:(UIImage *)icon{
    _curIcon = [icon retain];
    [self getCodeString];
    [self generateCode];
//    [self sendMessage:nil withSave:YES];
}

-(void)imageSelected:(int)index{
    _curSkin = [[DATA_ENV getSkinImageWithIndex:index] retain];
    [_backgoundImage setDefaultImage: _curSkin];
    _isDefaultSkin = index==0;
    if (_isDefaultSkin) {
        _codeAtt.hasBackGroud = 0;
        _codeAtt.backGroudUrl = @"";
    } else {
        _codeAtt.hasBackGroud = 1;
        _codeAtt.backGroudUrl = [DATA_ENV getSkinUrlWithIndex:index];
    }
    [self getCodeString];
    [self generateCode];
//    [self sendMessage:nil withSave:YES];
}

- (IBAction)albumSelect:(id)sender {
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (IBAction)selectIconButton:(UIButton*)sender {
    if (_type == EditImageTypeIcon) {
        if (_decorateView.alpha<0.5) {
            _decorateView.alpha = 1;
            sender.selected = YES;
            _camecaBtn.hidden=NO;
        }else{
            _decorateView.alpha = 0;
            sender.selected = NO;
            _camecaBtn.hidden=YES;
        }
        return;
    }
    _decorateView.alpha = 1;
    for (id btn in _toolView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            ((UIButton*)btn).selected=NO;
        }
    }
    _camecaBtn.hidden = NO;
    [_decorateView initDataWithType:EditImageTypeIcon];
    sender.selected = YES;
    _type = EditImageTypeIcon;
}

- (IBAction)selectColorButton:(UIButton*)sender {
    if (_type == EditImageTypeColor) {
        if (_decorateView.alpha<0.5) {
            _decorateView.alpha = 1;
            sender.selected = YES;
        }else{
            _decorateView.alpha = 0;
            sender.selected = NO;
        }
        return;
    }
    _decorateView.alpha = 1;
    for (id btn in _toolView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            ((UIButton*)btn).selected=NO;
        }
    }
    _camecaBtn.hidden = YES;
    [_decorateView initDataWithType:EditImageTypeColor];
    sender.selected = YES;
    _type = EditImageTypeColor;
}

- (IBAction)selectSkinButton:(UIButton*)sender {
    if (_type == EditImageTypeSkin) {
        if (_decorateView.alpha<0.5) {
            _decorateView.alpha = 1;
            sender.selected = YES;
            _camecaBtn.hidden=NO;
        }else{
            _decorateView.alpha = 0;
            sender.selected = NO;
            _camecaBtn.hidden=YES;
        }
        return;
    }
    _decorateView.alpha = 1;
    for (id btn in _toolView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            ((UIButton*)btn).selected=NO;
        }
    }
    _camecaBtn.hidden = NO;
    [_decorateView initDataWithType:EditImageTypeSkin];
    sender.selected = YES;
    _type = EditImageTypeSkin;
}

-(void)setElementHidden:(BOOL)hidden{
    CGRect rect = _backgroundView.frame;
    if (hidden) {
        rect.origin.y = 0;
    }else{
        rect.origin.y = -44;
    }
    _backgroundView.frame = rect;
    self.navigationController.navigationBarHidden = hidden;
    [_encodeView setHidden:hidden];
    if (_decorateView) {
        [_decorateView setHidden:hidden];
    }
    [_toolView setHidden:hidden];
    if (_type == EditImageTypeIcon||_type==EditImageTypeSkin) {
        if (hidden) {
            _camecaBtn.hidden = YES;
        }else{
            _camecaBtn.hidden = _decorateView.alpha<0.5;
        }
    }
}
- (IBAction)EditImageClick:(id)sender {
    [self setElementHidden:YES];
    EditImageView *editView = [(EditImageView*)[[[NSBundle mainBundle] loadNibNamed:@"EditImageView" owner:self options:nil] objectAtIndex:0] retain];
    editView.frame = CGRectMake(0, 0, 320, 480);
    editView.delegate = self;
    [editView setImageWithFrame:_encodeImageView.image frame:_encodeView.frame];
    [self.view addSubview:editView];
    [self.view bringSubviewToFront:editView];
    [editView release];
}

-(void)doneEdit:(UIImage *)image frame:(CGRect)rect{
    _encodeView.frame = rect;
    _encodeImageView.image = image;
    [self setElementHidden:NO];
    _codeAtt.height = rect.size.height;
    _codeAtt.width = rect.size.width;
    [self getCodeString];
    [self generateCode];
}

-(void)cancelEdit{
    [self setElementHidden:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    NSString *path = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_type == EditImageTypeIcon) {
        _curIcon = [image retain];
    }else{
        _curSkin = [image retain];
        [_backgoundImage setDefaultImage: _curSkin];
        _codeAtt.hasBackGroud = 1;
        _codeAtt.backGroudUrl = [path lastPathComponent];
    }
    [self getCodeString];
    [self generateCode];
//    [self sendMessage:nil withSave:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)finishShare:(NSNotification*)notification{
    [self tapOnSaveBtn:nil];
    
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
    [_encodeView release];
    _encodeView = nil;
    [_toolView release];
    _toolView = nil;
    [_editColorBtn release];
    _editColorBtn = nil;
    [_editIconBtn release];
    _editIconBtn = nil;
    [_camecaBtn release];
    _camecaBtn = nil;
    [_backgoundImage release];
    _backgoundImage = nil;
    [_editSkinBtn release];
    _editSkinBtn = nil;
    [_backgroundView release];
    _backgroundView = nil;
    [_saveBtn release];
    _saveBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)dealloc{
    if (_logId) {
        [_logId release];
    }
    if (_curIcon) {
        [_curIcon release];
    }
    if (_curColor) {
        [_curColor release];
    }
    if (_curSkin) {
        [_curSkin release];
    }
    [_content release];
    [_codeObject release];
    [_codeAtt release];
    if (_decorateView) {
        _decorateView.delegate=nil;
        [_decorateView release];
    }
    [_encodeImageView release];
    [_encodeView release];
    [_toolView release];
    [_editColorBtn release];
    [_editIconBtn release];
    [_camecaBtn release];
    [_backgoundImage release];
    [_editSkinBtn release];
    [_backgroundView release];
    [_saveBtn release];
    [super dealloc];
}
@end
