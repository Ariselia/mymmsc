//
//  UCStorePerson.m
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCStorePerson.h"
#import "Api+eShop.h"
#import <iOSApi/UIImage+Scale.h>
#import "UCStoreTable.h"

@implementation UCStorePerson

@synthesize person1, person2, person3, person4, person5, person6, person7, person8;

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
    label.text= @"品牌专区";
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

- (void) gotoStore:(id)sender{
    UIButton *btn = sender;
    int pid = btn.tag;
    
    UCStoreTable *nextView = [[UCStoreTable alloc] init];
    nextView.person = pid;
    nextView.person = 0;
    nextView.page = 3;
    nextView.bPerson = YES;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *list = [Api personList];
        int count = list ? list.count : 0;
        count = MIN(count, 8);
        for (int i = 0; i < count; i++) {
            UIImageView *view = nil;
            switch (i) {
                case 0:
                    view = person1;
                    break;
                case 1:
                    view = person2;
                    break;
                case 2:
                    view = person3;
                    break;
                case 3:
                    view = person4;
                    break;
                case 4:
                    view = person5;
                    break;
                case 5:
                    view = person6;
                    break;
                case 6:
                    view = person7;
                    break;
                default:
                    view = person8;
                    break;
            }
            PersonInfo *obj = [list objectAtIndex:i];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = view.frame;
            btn.tag = obj.pid;
            [btn addTarget:self action:@selector(gotoStore:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            
            NSString *tmpUrl = [iOSApi urlDecode:obj.picUrl];
            //[iOSApi showImage:tmpUrl];
            UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]] autorelease];
            [view setImage: [im scaleToSize:view.frame.size]];
        }
    }
}
@end
