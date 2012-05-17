//
//  EFileMain.m
//  FengZi
//
//  Created by a on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EFileMain.h"
#import "EFileMap.h"
#import "FileUtil.h"
#import "Api+Database.h"

@implementation EFileMain
@synthesize myWebView,myImg;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myWebView.delegate=self;
	
	NSString *url = [NSString stringWithFormat:@"%@=%d", @"http://devp.ifengzi.cn:38090/misc/member.action?userid", [Api userId]];
    NSURL* URL = [[NSURL alloc] initWithString:url];
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:URL];
    /*
     NSData *allData=[NSData dataWithContentsOfURL:URL];
     NSInteger n=[allData length];
     */
    [myWebView loadRequest:request];
    [request release];
    
    activity = [[UIActivityIndicatorView alloc] 
                initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    activity.tag = kTagHintView;
    [activity setCenter: self.view.center];
    //[activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
	[activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    [self.view addSubview: activity];
    [activity release];
    
    [URL release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.myImg = nil;
    self.myWebView = nil;
}

- (void)goBack{
    if (myWebView.canGoBack) {
        [myWebView goBack];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)goLocal{
    EFilePortal *theView = [[[EFilePortal alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}


- (void)goMap:(NSString*)param add:(NSString*)param1{
    EFileMap *theView = [[[EFileMap alloc] init] autorelease];
    theView.name = param;
    //theView.add = [Api base64e:param1];
    theView.add = param1;
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[iOSApi toast:@"正在访问，请等待"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *rurl = [[request URL] absoluteString]; 
    // NSLog(@"转往本地蜂夹"); 
    if([rurl hasSuffix:@"goLocal"])  
    {
        [self goLocal];
        return false;
    } 
    //调用地图
    if([rurl hasSuffix:@"goMap"])  
    { 
        NSDictionary *dict = [rurl uriParams];
        // NSLog([NSString stringWithFormat:@"%@", rurl]);
        NSString *sh_name = [dict objectForKey:@"name"];
        NSString *sh_add = [dict objectForKey:@"add"];
        [self goMap:sh_name add:sh_add];
        return false;
        //[self goMap:@"北京"];
    } 
    
    //调用下载
    //电子券下载
    if([rurl hasSuffix:@"goDownCard"])  
    { 
        NSLog(@"dc");
        NSDictionary *dict = [rurl uriParams];
        NSString *cardinfoserialnum=[dict objectForKey:@"cardinfoserialnum"];
        NSString *cardinfousetime=[dict objectForKey:@"cardinfousetime"];
        NSString *cardinfousestate=[dict objectForKey:@"cardinfousestate"];
        NSString *cardlistarealist=[dict objectForKey:@"cardlistarealist"];
        NSString *cardlisttypelist=[dict objectForKey:@"cardlisttypelist"];
        NSString *cardinfoshoplist=[dict objectForKey:@"cardinfoshoplist"];
        
        NSString *cardclassid=[dict objectForKey:@"cardclassid"];        
        NSString *cardclassname=[iOSApi urlDecode:[dict objectForKey:@"cardclassname"]];
        NSString *cardlistid=[dict objectForKey:@"cardlistid"];
        NSString *cardlistname=[iOSApi urlDecode:[dict objectForKey:@"cardlistname"]];
        NSString *cardlistpicurl=[dict objectForKey:@"cardlistpicurl"];
        NSString *cardlistflag=[dict objectForKey:@"cardlistflag"];
        NSString *cardinfocodepicurl=[dict objectForKey:@"cardinfocodepicurl"];
        NSString *cardinfocode=[dict objectForKey:@"cardinfocode"];
        NSString *cardinfoname=[iOSApi urlDecode:[dict objectForKey:@"cardinfoname"]];
        NSString *cardinfocontent=[iOSApi urlDecode:[dict objectForKey:@"cardinfocontent"]];
        NSString *cardinfodiscount=[dict objectForKey:@"cardinfodiscount"];
        NSString *cardinfopicurl=[dict objectForKey:@"cardinfopicurl"];
        NSString *userid=[dict objectForKey:@"userid"];
        //将数据存到数据库
        
        if([[DataBaseOperate shareData] checkCardExists:cardlistid])
        {
            [iOSApi toast:@"该会员卡已经下载过，请勿重复下载"];
        } else {
            UIImage *cardlistImg = [CommonUtils getImageFromUrl:cardlistpicurl];
            UIImage *cardinfocodeImg = [CommonUtils getImageFromUrl:cardinfocodepicurl];
            UIImage *cardinfoImg = [CommonUtils getImageFromUrl:cardinfopicurl];
            
            NSString  *cardlistImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            
            NSString  *cardinfocodeImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            
            NSString  *cardinfoImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            BOOL save1;
            BOOL save2;
            BOOL save3;
            
            save1=[FileUtil writeImage:cardlistImg toFileAtPath:[FileUtil filePathInEncode:cardlistImgUrl]];
            
            save2= [FileUtil writeImage:cardinfocodeImg toFileAtPath:[FileUtil filePathInEncode:cardinfocodeImgUrl]];
            save3=  [FileUtil writeImage:cardinfoImg toFileAtPath:[FileUtil filePathInEncode:cardinfoImgUrl]];
            
            
            /*
             1 cardclassid,2 cardclassname,3 cardlistid,
             4 cardlistname,5 cardlistpicurl,6 cardlistflag,7 cardinfocode,
             8 cardinfocodepicurl,9 cardinfocontent,10 cardinfoname,
             11 cardinfodiscount,12 cardinfopicurl,13 cardinfoserialnum,14 cardinfousetime,
             15 cardinfousestate,16 cardlistarealist,17 cardlisttypelist,18 cardinfoshoplist,19 userid
             */
            
            
            [[DataBaseOperate shareData] insertCard:cardclassid b:cardclassname c:cardlistid d:cardlistname e:cardlistImgUrl f:cardlistflag g:cardinfocode h:cardinfocodeImgUrl i:cardinfocontent j:cardinfoname k:cardinfodiscount l:cardinfoImgUrl m:cardinfoserialnum n:cardinfousetime o:cardinfousestate p:cardlistarealist q:cardlisttypelist r:cardinfoshoplist s:userid];
            
            [iOSApi toast:@"下载完毕"];
        }
        return false;
    } 
    //会员卡下载
    if([rurl hasSuffix:@"goDownMember"])  
    {   
        // NSLog(@"dm");
        NSDictionary *dict = [rurl uriParams];
        /*
         NSString *memberID = [dict objectForKey:@"id"];
         
         
         NSArray *urlComps = [rurl componentsSeparatedByString:@"&"];
         NSString *memberID = [urlComps 
         
         EFileMemberInfo *memberInfo = nil;
         
         memberInfo= [[Api get_member_info:memberID] retain]; 
         //将list数据写到本地，文字和图片
         //[iOSApi showAlert:@"正在下载..."];
         if(memberInfo!=nil)
         {
         
         }
         */
        
        
        NSString *memberclassid=[dict objectForKey:@"memberclassid"];
        
        NSString *memberclassname=[iOSApi urlDecode:[dict objectForKey:@"memberclassname"]];
        NSString *memberlistid=[dict objectForKey:@"memberlistid"];
        NSString *memberlistname=[iOSApi urlDecode:[dict objectForKey:@"memberlistname"]];
        NSString *memberlistpicurl=[dict objectForKey:@"memberlistpicurl"];
        NSString *memberinfocodename=[iOSApi urlDecode:[dict objectForKey:@"memberinfocodename"]];
        NSString *memberinfocodepicurl=[dict objectForKey:@"memberinfocodepicurl"];
        NSString *memberinfocodecontent=[iOSApi urlDecode:[dict objectForKey:@"memberinfocodecontent"]];
        NSString *memberinfocodenum=[dict objectForKey:@"memberinfocodenum"];
        NSString *memberinfopicurl=[dict objectForKey:@"memberinfopicurl"];
        NSString *memberinfocodeserialnum=[dict objectForKey:@"memberinfocodeserialnum"];
        NSString *memberinfocodeusetime=[dict objectForKey:@"memberinfocodeusetime"];
        NSString *userid=[dict objectForKey:@"userid"];
        
        
        if([[DataBaseOperate shareData] checkMemberExists:memberlistid])
        {
            [iOSApi toast:@"该会员卡已经下载过，请勿重复下载"];
        }
        else
        {
            UIImage *memberlistImg = [CommonUtils getImageFromUrl:memberlistpicurl];
            UIImage *memberinfocodeImg = [CommonUtils getImageFromUrl:memberinfocodepicurl];
            UIImage *memberinfoImg = [CommonUtils getImageFromUrl:memberinfopicurl];
            
            
            NSString  *memberlistImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            
            NSString  *memberinfocodeImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            
            NSString  *memberinfoImgUrl= [NSString stringWithFormat:@"%@.png",[CommonUtils createUUID]];
            BOOL save1;
            BOOL save2;
            BOOL save3;
            save1=[FileUtil writeImage:memberlistImg toFileAtPath:[FileUtil filePathInEncode:memberlistImgUrl]];
            
            save2=[FileUtil writeImage:memberinfocodeImg toFileAtPath:[FileUtil filePathInEncode:memberinfocodeImgUrl]];
            
            save3=[FileUtil writeImage:memberinfoImg toFileAtPath:[FileUtil filePathInEncode:memberinfoImgUrl]];
            
            [[DataBaseOperate shareData] insertMember:memberclassid b:memberclassname c:memberlistid d:memberlistname e:memberlistImgUrl f:memberinfocodename g:memberinfocodeImgUrl h:memberinfocodecontent i:memberinfocodenum j:memberinfoImgUrl k:memberinfocodeserialnum l:memberinfocodeusetime m:userid];
            
            [iOSApi toast:@"下载完毕"];
        }
        return false;
    } 
    
    
    /*    
     NSRange go_local=[rurl rangeOfString:@"goLocal"];
     if(go_local.location!=NSNotFound)
     {
     [self goLocal];
     }
     
     NSRange go_map=[rurl rangeOfString:@"goMap"];
     if(go_map.location!=NSNotFound)
     {
     
     [self goMap];
     
     }  
     */
    
    return true;  
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	/*
     NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"]; 
     NSLog(@"title11=%@",title);
     */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.view viewWithTag:kTagActivity];
    [activity startAnimating];

    webView.hidden=YES;
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    webView.hidden=NO;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@""
														message: [error localizedDescription]
													   delegate: nil
											  cancelButtonTitle: @"确定" 
											  otherButtonTitles: nil];
    [alterview show];
    [alterview release];
}
@end
