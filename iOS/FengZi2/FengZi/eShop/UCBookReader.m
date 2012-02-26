//
//  UCBookReader.m
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCBookReader.h"

@implementation UCBookReader

@synthesize subject, bookContent;
@synthesize content, page;
@synthesize front, next;

#define BOOK_PAGE_WORDS (33 * 9)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageCur = 0;
        pageNum = 1000;
        words = 0;
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

- (void)update_page{
    page.text = [NSString stringWithFormat:@"%d/%d", pageCur, pageNum];
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goFront:(id)sender{
    int length = BOOK_PAGE_WORDS;
    pageCur -= 1;
    if (bookContent.length < pageCur * BOOK_PAGE_WORDS) {
        length = bookContent.length - (pageCur-1) *BOOK_PAGE_WORDS;
    }
    if (pageCur < 1) {
        pageCur = 1;
    }
    if (pageCur == 1 && pageCur < pageNum) {
        // 第一页
        [front setHidden:YES];
        [next setHidden:NO];
    } else if(pageCur == 1 && pageCur == pageNum) {
        // 只有一页
        [front setHidden:YES];
        [next setHidden:YES];
    } else if (pageCur > 1 && pageCur == pageNum) {
        // 最后一页
        [front setHidden:NO];
        [next setHidden:YES];
    } else {
        [front setHidden:NO];
        [next setHidden:NO];
    }
    [self update_page];
    content.text = [bookContent substringWithRange:NSMakeRange((pageCur - 1) * BOOK_PAGE_WORDS, length)];
    if (pageCur < 1) {
        pageCur = 1;
    }
}

- (IBAction)goNext:(id)sender{
    int length = BOOK_PAGE_WORDS;
    pageCur ++;
    if (pageCur >= pageNum) {
        pageCur = pageNum;
    }
    if (bookContent.length < pageCur * BOOK_PAGE_WORDS) {
        // 最后一页
        length = bookContent.length - (pageCur -1) *BOOK_PAGE_WORDS;
    }
    if (pageCur < 1) {
        pageCur = 1;
    }
    if (pageCur == 1 && pageCur < pageNum) {
        // 第一页
        [front setHidden:YES];
        [next setHidden:NO];
    } else if(pageCur == 1 && pageCur == pageNum) {
        // 只有一页
        [front setHidden:YES];
        [next setHidden:YES];
    } else if (pageCur > 1 && pageCur == pageNum) {
        // 最后一页
        [front setHidden:NO];
        [next setHidden:YES];
    } else {
        [front setHidden:NO];
        [next setHidden:NO];
    }
    [self update_page];
    content.text = [bookContent substringWithRange:NSMakeRange((pageCur - 1) * BOOK_PAGE_WORDS, length)];

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
    label.text= subject;
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
    
    pageNum = bookContent.length / BOOK_PAGE_WORDS + 1;
    [front setHidden:YES];
    [next setHidden:YES];
    [self goNext:nil];
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

@end
