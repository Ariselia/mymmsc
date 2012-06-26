//
//  UCMyCode.m
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCMyCode.h"
#import "Api+UserCenter.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "UCKmaViewController.h"
#import "UCKmaViewController.h"
#import "EncodeAppUrlViewController.h"
#import "EncodeBookMarkViewController.h"
#import "EncodeCardViewController.h"
#import "EncodeEmailViewController.h"
#import "EncodeEncTextViewController.h"
#import "EncodeMapViewController.h"
#import "EncodePhoneViewController.h"
#import "EncodeSmsViewController.h"
#import "EncodeScheduleViewController.h"
#import "EncodeTextViewController.h"
#import "EncodeUrlViewController.h"
#import "EncodeWifiViewController.h"
#import "EncodeWeiboViewController.h"

#import "DecodeCardViewControlle.h"
#import "DecodeViewController.h"
#import "BusDecoder.h"
#import "DecodeBusinessViewController.h"

#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>
#import "UCCell.h"
#import "UITableViewCellExt.h"
// WangFeng: 增加富媒体生码类
#import "UCCreateCode.h"
#import "UCRichMedia.h"
#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 25.0
#import "CONSTS.h"

#import "UCMediaPage.h"
#import "UCRichMedia.h"
#import "RMComments.h"


@implementation UCMyCode

@synthesize uiview;
@synthesize tableView=_tableView;

static int iTimes = -1;
static int iRow = -1;
static int xTimes = -1;
#define kCODE_NONE (0)
#define kCODE_KMA  (9)

-(void)gotoEditController:(BusinessType)type{
    DATA_ENV.curBusinessType = type;
    UIViewController *viewController;
    switch (type) {
        case BusinessTypeAppUrl:
            viewController = [[EncodeAppUrlViewController alloc] initWithNibName:@"EncodeAppUrlViewController" bundle:nil];
            break;
        case BusinessTypeGmap:
            viewController = [[EncodeMapViewController alloc] initWithNibName:@"EncodeMapViewController" bundle:nil];
            break;
        case BusinessTypeShortMessage:
            viewController = [[EncodeSmsViewController alloc] initWithNibName:@"EncodeSmsViewController" bundle:nil];
            break;
        case BusinessTypeCard:
            viewController = [[EncodeCardViewController alloc] initWithNibName:@"EncodeCardViewController" bundle:nil];
            break;
        case BusinessTypeEmail:
            viewController = [[EncodeEmailViewController alloc] initWithNibName:@"EncodeEmailViewController" bundle:nil];
            break;
        case BusinessTypeText:
            viewController = [[EncodeTextViewController alloc] initWithNibName:@"EncodeTextViewController" bundle:nil];
            break;
        case BusinessTypeWifiText:
            viewController = [[EncodeWifiViewController alloc] initWithNibName:@"EncodeWifiViewController" bundle:nil];
            break;
        case BusinessTypeEncText:
            viewController = [[EncodeEncTextViewController alloc] initWithNibName:@"EncodeEncTextViewController" bundle:nil];
            break;
        case BusinessTypeWeibo:
            viewController = [[EncodeWeiboViewController alloc] initWithNibName:@"EncodeWeiboViewController" bundle:nil];
            break;
        case BusinessTypeBookMark:
            viewController = [[EncodeBookMarkViewController alloc] initWithNibName:@"EncodeBookMarkViewController" bundle:nil];
            break;
        case BusinessTypePhone:
            viewController = [[EncodePhoneViewController alloc] initWithNibName:@"EncodePhoneViewController" bundle:nil];
            break;
        case BusinessTypeUrl:
            viewController = [[EncodeUrlViewController alloc] initWithNibName:@"EncodeUrlViewController" bundle:nil];
            break;
        case BusinessTypeSchedule:
            viewController = [[EncodeScheduleViewController alloc] initWithNibName:@"EncodeScheduleViewController" bundle:nil];
            break;
        case BusinessTypeRichMedia: // WangFeng: 增加生码类
            viewController = [[UCCreateCode alloc] initWithNibName:@"UCCreateCode" bundle:nil];
            break;
        default:
            viewController = [[EncodeCardViewController alloc] initWithNibName:@"EncodeCardViewController" bundle:nil];
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark Generate images with given fill color
// Convert the image's fill color to the passed in color
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

#pragma mark Button touch up inside action
- (IBAction) touchUpInsideAction:(UIButton*)button
{
    //NSIndexPath* indexPath = [self.tableView indexPathForCell:sideSwipeCell];
    
    NSUInteger index = [buttons indexOfObject:button];
    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
    [[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"%@ on cell %d", [buttonInfo objectForKey:@"title"], 1]
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:@"OK", nil] autorelease] show];
    [sideSwipeView removeFromSuperview];
    iRow = -1;
    //[self removeSideSwipeView:YES];
    [self.tableView reloadData];
}

- (void) setupSideSwipeView
{
    UIImage *imageTop = [UIImage imageNamed:@"TabBarNipple.png"];
    UIImageView *tmp = [[UIImageView alloc] initWithImage:imageTop];
    CGRect tmpFrame = CGRectMake(320/2 - imageTop.size.width / 2, 0 - imageTop.size.height, imageTop.size.width, imageTop.size.height);
    tmp.frame = tmpFrame;
    [sideSwipeView addSubview: tmp];
    [tmp release];
    // Add the background pattern
    sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* shadowImageView = [[[UIImageView alloc] initWithFrame:sideSwipeView.frame] autorelease];
    shadowImageView.alpha = 0.6;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [sideSwipeView addSubview:shadowImageView];
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = BUTTON_LEFT_MARGIN;
    for (NSDictionary* buttonInfo in buttonData)
    {
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonImage.size.width, buttonImage.size.height);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [self imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        [button setImage:grayImage forState:UIControlStateNormal];
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [buttons addObject:button];
        
        // Add the button to the side swipe view
        [sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonImage.size.width + BUTTON_SPACING;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isInit =NO;
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

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
    // Setup the title and image for each button within the side swipe view
        buttonData = [[NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Reply", @"title", @"reply.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Retweet", @"title", @"retweet-outline-button-item.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Favorite", @"title", @"star-hollow.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Profile", @"title", @"person.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Links", @"title", @"paperclip.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Action", @"title", @"action.png", @"image", nil],
                       nil] retain];
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.rowHeight)];
    [self setupSideSwipeView];
     
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *list = [Api codeMyList:0 size:100];
        [list retain];
        [items addObjectsFromArray:list];
        [list release];
        [self.tableView reloadData];
        //当前没有你的专属码
    }
     */
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //去掉table的横线
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"我的码";
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
    
    // 设定UITableViewCell格式
    _borderStyle = UITextBorderStyleNone;
    font = [UIFont systemFontOfSize:13.0];
   /*
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    */
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (isInit == NO) {
        
  
     [iOSApi showAlert:@"正在获取用户信息..."];
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *list = [Api codeMyList:0 size:100];
        [list retain];
        [items addObjectsFromArray:list];
        [list release];
        [self.tableView reloadData];
        //当前没有你的专属码
        
    }
    [iOSApi closeAlert];
        isInit = YES;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    
    int nCount = [items count];
    /*
    if (nCount < 1) {
        nCount = 1;
    }
     */
    return nCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 70;
    if (iRow == indexPath.row) {
        //h += 50;
    }
	return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.backgroundColor = [UIColor clearColor];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UCCell *cell = [[UCCell alloc]init];
    if (cell == nil) {
        
        cell = [[[UCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    UIImage *image = [[UIImage imageNamed:@"uc-cell.png"] toSize: CGSizeMake(320, 70)];
    //   UIImage *himage = [UIImage imageNamed:@"uc-cell-h.png"];
    [cell setBackgroundImage:image];    // Configure the cell.
    int pos = [indexPath row];
    /*
    if (pos >= [items count]) {
        //[cell release];
        //return nil;
    }
     */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 设定标题
    /*
    if (iRow == indexPath.row) {
        cell.textLabel.numberOfLines=5;
    }
   
    if ([items count] < 1) {
       // cell.textLabel.text = @"当前没有你的专属码";
    } else {
       */
        CodeInfo *obj = [items objectAtIndex: pos];
    //cell.imageView.image = [[DATA_ENV getTableImage:(BusinessType)(obj.type - 1)]toSize:CGSizeMake(50, 48)];
    
      cell.imageView.image = [DATA_ENV getTableImage:(BusinessType)(obj.type - 1)];
    
    
        cell.textLabel.font = font;
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@%@", [obj title], [obj createTime], iRow == indexPath.row ? @"\n\n\n\n\n" : @""];
        /*
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         */
    //}
    
    [cell setBackgroundColor: [UIColor clearColor]];
    //[cell.contentView addSubview:[obj object]];
    return cell;
}

// 选中进入
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImage *himage =[[UIImage imageNamed:@"uc-cell-h.png"] toSize: CGSizeMake(320, 70)];    
    [cell setBackgroundImage:himage];
    
    [uiview setHidden:NO];
    //添加3个按钮的图层。
    //320-223= 138
    //CGRect frame = CGRectMake(97, cell.frame.origin.y+8, 223, 52);
    CGRect frame = CGRectMake(97, 8, 223, 52);
    
    [uiview setFrame:frame];
    [uiview setBackgroundColor:[UIColor clearColor]]; 
    //[self.view addSubview:uiview];
    [cell.contentView addSubview:uiview];
    iTimes = 0;
    if ([items count] < 1) {
        return;
    }

    xInput = [items objectAtIndex:indexPath.row];
    
     /* 
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:nil
						  message:nil
						  delegate:self
						  cancelButtonTitle:@"查看"
						  otherButtonTitles:@"重置", nil];
    [alert show];
	[alert release];
     */
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    //BusCategory *category = [BusDecoder classify:input];
    xTimes = kCODE_NONE;
	if (iTimes == 0) {
		switch (buttonIndex) {
			case 1:
			{
                // 重置
                // 空码, 可以调到空码赋值页面, 默认为富媒体
                NSDictionary *dict = [xInput.url uriParams];
                NSString *xcode = [dict objectForKey:@"id"];
                [Api kmaSetId:xcode];
                iOSLog(@"uuid=[%@]", xcode);

                UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
                nextView.forceEdit = YES; // 强制赋值
                nextView.code = xcode;
                nextView.curImage = [Api generateImageWithInput:xInput.url];
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
			}
				break;
			default: 
            {
                [self chooseShowController:xInput.url isSave:NO];
            }
				break;
		}
	} else if (iTimes == 1) {
        //
	}
}
//继承scrollview，完成下拉隐藏按钮；
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"start to drag");
    xInput = nil;
    [uiview setHidden:YES];
}

#pragma mark -
#pragma mark Btn DoSoming
//阅读，重置，评论；

-(NSString *)urlParams:(NSString *)url
{
    NSArray *urlParams = [url componentsSeparatedByString:@"?"];
    return [urlParams objectAtIndex:1];
}
-(IBAction)resetCode:(id)sender
{
    // 重置
    // 空码, 可以调到空码赋值页面, 默认为富媒体
//    NSDictionary *dict = [xInput.url uriParams];

    NSString *xcode = [self urlParams:xInput.url];
    xcode = [xcode replace:@"id=" withString:@""];
    NSLog(@"------%@",xcode);
    [Api setKma:YES];
    [Api kmaSetId:xcode];
    iOSLog(@"uuid=[%@]", xcode);
    
    UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
    nextView.forceEdit = YES; // 强制赋值
    nextView.code = xcode;
    nextView.curImage = [Api generateImageWithInput:xInput.url];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}

-(IBAction)readCode:(id)sender
{
    iOSLog(@"....%@",xInput.url);
    [self chooseShowController:xInput.url isSave:NO];
}

-(IBAction)plCode:(id)sender
{
    NSLog(@"暂无法评论");
//    [self doDiscuss];
    
    NSString *xcode = [self urlParams:xInput.url];

    NSString *codeid = [[xcode componentsSeparatedByString:@"="] objectAtIndex:1];
    RMComments *nextView = [RMComments new];
    nextView.param = codeid;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}


@end
