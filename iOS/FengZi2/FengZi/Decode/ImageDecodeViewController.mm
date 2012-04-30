//
//  ImageDecodeViewController.m
//  FengZi
//
//  Created by lt ji on 12-1-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "ImageDecodeViewController.h"
#import <ZXing/QRCodeReader.h>
#import <ZXing/TwoDDecoderResult.h>
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import <QuartzCore/QuartzCore.h>

// 二期加入
#import "UCKmaViewController.h"
#import "UCRichMedia.h"
#import "UCCreateCode.h"

#import "UCUpdateNikename.h"

@implementation ImageDecodeViewController
@synthesize curImage = _curImage;
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
/*
-(void) chooseShowController:(NSString*)input{
    if (input != nil && [input hasPrefix:API_URL_SHOW]) {
        NSDictionary *dict = [Api parseUrl:input];
        NSString *userId = [dict objectForKey:@"id"];
        UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
        nextView.idDest = [userId intValue];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
        return;
    }
    
    BusCategory *category = [BusDecoder classify:input];
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:_curImage withType:HistoryTypeFavAndHistory withSaveImage:_curImage];
        [self.navigationController pushViewController:cardView animated:YES];
        [cardView release];
    } else if([category.type isEqualToString:CATEGORY_MEDIA]) {
        // 富媒体业务
        UCRichMedia *nextView = [[UCRichMedia alloc] init];
        nextView.urlMedia = input;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];  
    } else if([category.type isEqualToString:CATEGORY_KMA]) {
        // 空码, 可以调到空码赋值页面, 默认为富媒体
        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
        //nextView.bKma = YES; // 标记为空码赋值富媒体
        nextView.code = input;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:_curImage withType:HistoryTypeFavAndHistory withSaveImage:_curImage];
        [self.navigationController pushViewController:businessView animated:YES];
        [businessView release];
    }
}
*/

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    _curImage = image;
    [self chooseShowController:twoDResult.text];
    decoder.delegate = nil;
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:DECODE_FAIL delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    return;
}

-(void)createImageWithWeb{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect rect = _frameImageView.frame;
    rect.origin.x += 4;
    rect.origin.y += 4;
    rect.size.width -= 8;
    rect.size.height -= 8;
    CGImageRef newImageRef = CGImageCreateWithImageInRect([resultImg CGImage], rect);
    resultImg = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    Decoder *decoder = [[Decoder alloc] init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    decoder.readers = readers;
    decoder.delegate = self;
    [decoder decodeImage:resultImg];
    [readers release];
    [qrcodeReader release];
    [decoder release];
}

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}
#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[_editImageView superview]];
        
        [_editImageView setCenter:CGPointMake([_editImageView center].x + translation.x, [_editImageView center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[_editImageView superview]];
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _editImageView;
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
    label.text= @"图片解码";
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
    [btn setImage:[UIImage imageNamed:@"decode_code_btn.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"decode_code_btn_tap.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(createImageWithWeb) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    _editImageView.image = _curImage;
    CGSize size = _curImage.size;
    _editImageView.frame = CGRectMake(0, 0, size.width, size.height);
    _editImageView.center = _frameImageView.center;
    _scrollView.contentSize = CGSizeMake(320, 416);
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.view addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)viewDidUnload
{
    [_editImageView release];
    _editImageView = nil;
    [_frameImageView release];
    _frameImageView = nil;
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
    [_scrollView release];
    [_editImageView release];
    [_frameImageView release];
    [super dealloc];
}
@end
