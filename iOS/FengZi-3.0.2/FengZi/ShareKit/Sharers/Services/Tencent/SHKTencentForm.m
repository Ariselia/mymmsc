//
//  SHKTencentForm.m
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import "SHKTencentForm.h"
#import "SHK.h"
#import "SHKTencent.h"

@implementation SHKTencentForm

@synthesize delegate;
@synthesize textView;
@synthesize counter;
@synthesize hasAttachment;

- (void)dealloc {
	[delegate release];
	[textView release];
	[counter release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							  target:self
																							  action:@selector(cancel)];
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送到腾讯微博"
																				  style:UIBarButtonItemStyleDone
																				 target:self
																				 action:@selector(save)];
    }
    return self;
}



- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
	textView.delegate = self;
	textView.font = [UIFont systemFontOfSize:15];
	textView.contentInset = UIEdgeInsetsMake(5,5,0,0);
	textView.backgroundColor = [UIColor whiteColor];	
	textView.autoresizesSubviews = YES;
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:textView];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
	
	[self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];	
	
	// Remove observers
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)notification
{	
	CGRect keyboardFrame;
	CGFloat keyboardHeight;
	
	
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];		
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        keyboardHeight = keyboardFrame.size.height;
    }
    else{
        keyboardHeight = keyboardFrame.size.width;
    }
    
    
	
	// Find the bottom of the screen (accounting for keyboard overlay)
	// This is pretty much only for pagesheet's on the iPad
	UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
	BOOL inLandscape = orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight;
	BOOL upsideDown = orient == UIInterfaceOrientationPortraitUpsideDown || orient == UIInterfaceOrientationLandscapeRight;
	
	CGPoint topOfViewPoint = [self.view convertPoint:CGPointZero toView:nil];
	CGFloat topOfView = inLandscape ? topOfViewPoint.x : topOfViewPoint.y;
	
	CGFloat screenHeight = inLandscape ? [[UIScreen mainScreen] applicationFrame].size.width : [[UIScreen mainScreen] applicationFrame].size.height;
	
	CGFloat distFromBottom = screenHeight - ((upsideDown ? screenHeight - topOfView : topOfView ) + self.view.bounds.size.height) + ([UIApplication sharedApplication].statusBarHidden || upsideDown ? 0 : 20);							
	CGFloat maxViewHeight = self.view.bounds.size.height - keyboardHeight + distFromBottom;
	
	textView.frame = CGRectMake(0,0,self.view.bounds.size.width,maxViewHeight);
	[self layoutCounter];
}

#pragma mark -

- (void)updateCounter{
	if (counter == nil){
		self.counter = [[UILabel alloc] initWithFrame:CGRectZero];
		counter.backgroundColor = [UIColor clearColor];
		counter.opaque = NO;
		counter.font = [UIFont boldSystemFontOfSize:14];
		counter.textAlignment = UITextAlignmentRight;
		
		counter.autoresizesSubviews = YES;
		counter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		
		[self.view addSubview:counter];
		[self layoutCounter];
		[counter release];
	}
	
	int count = 140 - textView.text.length;
	counter.text = [NSString stringWithFormat:@"%i", count];
	counter.textColor = count >= 0 ? [UIColor blackColor] : [UIColor redColor];
}

- (void)layoutCounter{
	counter.frame = CGRectMake(textView.bounds.size.width-150-15,
							   textView.bounds.size.height-15-9,
							   150,
							   15);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
	[self updateCounter];
}

- (void)textViewDidChange:(UITextView *)textView{
	[self updateCounter];	
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	[self updateCounter];
}

#pragma mark -

- (void)cancel{	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

- (void)save{	
	if (textView.text.length > 140){
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"内容太长")
									 message:SHKLocalizedString(@"腾讯微博最长只能发140字")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"关闭")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}else if (textView.text.length == 0){
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"内容为空")
									 message:SHKLocalizedString(@"内容不能为空。")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"关闭")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	[(SHKTencent *)delegate sendForm:self];
	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}
@end
