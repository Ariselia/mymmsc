//
//  UserCenter.m
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UserCenter.h"
#import "Api+UserCenter.h"

#import "UCLogin.h"
#import "UCRegister.h"
#import "UCUpdateNikename.h"

#define ALERT_TITLE @"个人中心 提示"

@implementation UserCenter
@synthesize tableView=_tableView, message;
@synthesize photo,numScan,numAccess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)doReg:(id)sender{
    UCRegister *nextView = [[UCRegister alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 转向编辑个人信息
- (IBAction)doEditor:(id)sender{
    if (![Api isOnLine]) {
        [iOSApi Alert:ALERT_TITLE message:@"请登录后，再进行编辑。"];
        return;
    }
    UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

static int iTimes = -1;

// 选择 拍照还是相册
- (void)doPhotoSelect {
    iTimes = 0;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"选择头像获取方式"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"拍照", @"相册", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
	if (iTimes == 0) {
		UIImagePickerController *mPicker = [[UIImagePickerController alloc] init];
		mPicker.delegate = self;
		switch (buttonIndex) {
			case 1:
				mPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				break;
            case 2:
				mPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
				break;
			default:
                return;
                break;
		}
		[self presentModalViewController:mPicker animated:YES];
		iTimes = 1;
	} else if (iTimes == 1) {
		//
	} else if (iTimes == 2) {
        //
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)xInfo {
    iTimes = 0;
    UIImage *img = nil;
    
    NSString *mediaType = [xInfo objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        NSLog(@"found a image");
        UIImage *origImage = (UIImage *)[xInfo objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat origScale = origImage.size.width / origImage.size.height;
        CGSize dstSize = CGSizeMake(0, 0);
        dstSize.height = 480;
        dstSize.width = dstSize.height * origScale;
        UIGraphicsBeginImageContext(dstSize);
        // This is where we resize captured image
        [origImage drawInRect:CGRectMake(0, 0, dstSize.width, dstSize.height)];
        // And add the watermark on top of it
        //[[UIImage imageNamed:@"logo.png"] drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha: 1];
        // Save the results directly to the image view property
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if ([mediaType isEqualToString:@"public.movie"]){
        //
    }
    
	// Dismiss the image picker controller and look at the results
	[picker dismissModalViewControllerAnimated:YES];
	
	CGSize size;
	size.width = 300;
	size.height = 300;
    UIImage *scaledImage = [img thumb:&size];
    photo.image = scaledImage;
    NSData *buffer = [UIImagePNGRepresentation(scaledImage) retain];
    //iOSImageView2 *iv = [[iOSImageView2 alloc] initWithImage:scaledImage superView:self.view];
    //iv.delegate = self;
    //[iv release];
    NSString *filePath = [Api filePath:UC_FILENAME_PHOTO];
    NSLog(@"1: %@", filePath);
    NSFileHandle *fileHandle = [iOSFile create:filePath];
    [fileHandle writeData:buffer];
    [fileHandle closeFile];
    ApiResult *iRet = [[Api uc_photo_post:buffer] retain];
    [iRet release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else
    {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"个人中心";
    self.navigationItem.titleView = label;
    [label release];
    
    if (![Api isOnLine]) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(0, 0, 60, 32);
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateHighlighted];
        [_btnRight addTarget:self action:@selector(doReg:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    } else {
        //
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) onLogin:(id)sender {
    //[iOSApi Alert:@"登录" message:@"请稍候..."];
    //id nextView = [[[cls alloc] initWithNibName:nil bundle:nil] autorelease];
    UCLogin *nextView = [[UCLogin new] autorelease];
    //[nextView retain];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)doLogout:(id)sender {
    [Api setUser:nil];
    [self viewWillAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    if (items != nil) {
        [items removeAllObjects];
    }
    if (![Api isOnLine]) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(0, 0, 60, 32);
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateHighlighted];
        [_btnRight addTarget:self action:@selector(doReg:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    } else {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(0, 0, 60, 32);
        [_btnRight setImage:[UIImage imageNamed:@"uc-logout.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"uc-logout.png"] forState:UIControlStateHighlighted];
        [_btnRight addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
        
        // 加载照片
        if ([Api fileIsExists:UC_FILENAME_PHOTO]) {
            NSString *filePath = [iOSFile path:[Api filePath:UC_FILENAME_PHOTO]];
            UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            photo.image = im;
        }
        CGRect btnframe = photo.frame;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnframe;
        [btn addTarget:self action:@selector(doPhotoSelect) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    if ([items count] == 0) {
        // 预加载项
        iOSAction *action = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
        if ([Api isOnLine]) {
            message.text = [NSString stringWithFormat: @"Hi, %@", [Api nikeName]];
            // 1. 修改密码
            action = [iOSAction initWithName: @"修改密码" class: @"UCUpdatePassword"];
            [action setIcon: @"bb"];
            [items addObject: action];
            
            // 2. 修改密码
            action = [iOSAction initWithName: @"蜂巢留言板" class: @"UCMyComments"];
            [action setIcon: @"usercenter_userinfo_mycoment"];
            [items addObject: action];
            
            // 3. 我的回复
            action = [iOSAction initWithName: @"show出你的二维码" class: @"UCMySpace"];
            [action setIcon: @"usercenter_userinfo_zoneqr"];
            [items addObject: action];
            // 4. 我的空间
            
        } else {
            // 没有登录
            message.text = @"请点击［此处登录］！";
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = message.frame;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        
        action = [iOSAction initWithName: @"我的码" class: @"UCMyCode"];
        [action setIcon: @"cc"];
        //[action setNib: @"MoneyTrans"];
        [items addObject: action];
        //[action release];
        
        action = [iOSAction initWithName: @"我的收藏" class: @"FaviroteViewController"];
        [action setIcon: @"dd"];
        [items addObject: action];
        //[action release];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //return [items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
	return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell.
    int pos = [indexPath row];
    if (pos >= [items count]) {
        //[cell release];
        return nil;
    }
    iOSAction *info = [items objectAtIndex: pos];
    // 设定左边图标
    cell.imageView.image = [[UIImage imageNamed:@"unknown3.png"] scaleToSize:CGSizeMake(kCellIconHeight, kCellIconHeight)];
    if ([info icon] != nil) {
        cell.imageView.image = [[UIImage imageNamed:[info icon]] scaleToSize:CGSizeMake(kCellIconHeight, kCellIconHeight)];
    }
    // 设定标题
    cell.textLabel.text = [info title];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设定右边按钮
    //[cell setBackgroundColor: [UIColor clearColor]];
    //cell.layer.cornerRadius = 20;
    //cell.layer.masksToBounds = YES;
    //cell.contentView.layer.cornerRadius = 0;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSLog(@"module goto...");
    iOSAction *action = [items objectAtIndex:indexPath.row];
    if ([action.action isSame:@"UCMyCode"]) {
        if (![Api isOnLine]) {
            [self gotoLogin];
            return;
        }
    }
    id nextView = [action newInstance];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
