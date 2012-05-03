//
//  EBuyEvaluatePage.m
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEvaluatePage.h"
#import "Api+Ebuy.h"

@interface EBuyEvaluatePage ()

@end

@implementation EBuyEvaluatePage
@synthesize productId, orderId;
@synthesize xType, xContent, xState, xStar;

#define kTAG_BASE (10000)
#define kTAG_STAR (kTAG_BASE + 1)
static int text_maxlength = 140;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"发表评价";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    _star = [[iOSStar alloc] initWithFrame:CGRectMake(90.0f, 10.0f, 150.0f, 21.0f)];
    _star.show_star = 20 * 0;
    _star.font_size = 17;
    _star.isSelect = YES;
    _star.empty_color = [UIColor grayColor];
    _star.full_color = [UIColor redColor];
    _star.tag = kTAG_STAR;
    [self.view addSubview:_star];
    _star.delegate = self;
    [_star release];
    
    xState.text = [NSString stringWithFormat:@"剩余文字 %d.", text_maxlength - xContent.text.length];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void)setStarClass:(int)n {
    UIView *view = [self.view viewWithTag:kTAG_STAR];
    if (view != nil) {
        [view removeFromSuperview];
    }
    iOSStar *star2 = [[iOSStar alloc] initWithFrame:CGRectMake(60.0f, 23.0f, 150.0f, 21.0f)];
    star2.show_star = 20 * n;
    star2.font_size = 17;
    star2.empty_color = [UIColor whiteColor];
    star2.full_color = [UIColor orangeColor];
    star2.tag = kTAG_STAR;
    [self.view addSubview:star2];
    [star2 release];
}
*/

#pragma mark -
#pragma mark iOSStarDelegate

- (void)star:(iOSStar *)star onChange:(int)value{
    if (value < 0) {
        value = 0;
    }
    grade = (value + 19) / 20;
    
    xStar.text = [NSString stringWithFormat:@"(%d)", value];
}


static int iTimes = -1;

// 选择 拍照还是相册
- (IBAction)selectPic:(id)sender{
    iTimes = 0;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"选择图片来源"
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
        UIImage *origImage = (UIImage *)[xInfo objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat origScale = origImage.size.width / origImage.size.height;
        CGSize dstSize = CGSizeMake(0, 0);
        dstSize.height = 480;
        dstSize.width = dstSize.height * origScale;
        UIGraphicsBeginImageContext(dstSize);
        // This is where we resize captured image
        [origImage drawInRect:CGRectMake(0, 0, dstSize.width, dstSize.height)];
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
    size = [img fixSize:size];
    UIImage *scaledImage = [img toSize:size];
    //photo.image = scaledImage;
    NSData *buffer = [UIImagePNGRepresentation(scaledImage) retain];
    picUrl = [Api ebuy_commentpic_upload:buffer];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect frame = self.view.frame;
    frame.origin.y = -130;
    self.view.frame = frame;
    [UIView commitAnimations];
    
    return YES;
}

// 文本框变动的时候
- (void)textViewDidChange:(UITextView *)textView{
    //
}

/*
- (void)textViewDidBeginEditing:(UITextView *)textView {  
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] autorelease];
    self.navigationItem.rightBarButtonItem = done;
}*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL bRet = NO;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        [UIView commitAnimations];
    } else {
        NSString *str = textView.text;
        int length = str.length + text.length - range.length;
        if (length <= text_maxlength) {
            xState.text = [NSString stringWithFormat:@"剩余文字 %d.", text_maxlength - length];
            bRet = YES;
        } else {
            [iOSApi toast:[NSString stringWithFormat:@"文字最长%d", text_maxlength]];
        }
    }
    return bRet;    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //self.navigationItem.rightBarButtonItem = nil;
}

/*
- (void)leaveEditMode {
    [self.xContent resignFirstResponder];  
}
*/
// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    //
}

// 提交评论
- (IBAction)doSubmit:(id)sender{
    NSString *oId = orderId;
    NSString *msg = xContent.text;
    int love = xType.selectedSegmentIndex + 1;
    [iOSApi showAlert:@"提交评论中..."];
    ApiResult *iRet = [[Api ebuy_comment_add:productId content:msg grade:grade picUrl:picUrl love:love orderId:oId] retain];
    [iOSApi showCompleted:iRet.message];
    [iOSApi closeAlert];
    [iRet release];
}

@end
