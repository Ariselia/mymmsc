//
//  EncodePhoneViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodePhoneViewController.h"
#import "EncodeEditViewController.h"
#import "Phone.h"
#import "AddressBookUtils.h"
@implementation EncodePhoneViewController

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

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)generateCode{
    if ([_phoneText.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }

    if (![CommonUtils validateCellPhone:_phoneText.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    Phone *phone = [[[Phone alloc]init]autorelease];
    phone.telephone = _phoneText.text;
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    [self.navigationController pushViewController:editView animated:YES];
    [editView loadObject:phone];
    [editView release];
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
    label.text= @"电话号码生码";
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
    [btn setImage:[UIImage imageNamed:@"generate_code.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"generate_code_tap.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneText resignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_phoneText resignFirstResponder];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
    NSString *phone = [AddressBookUtils getFirstCellPhoneNum:person];
    _phoneText.text = phone;
    [peoplePicker dismissModalViewControllerAnimated:YES];  
    return NO;  
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker 
{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectPhone:(id)sender {
    if(!_peoplepicker){
        _peoplepicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplepicker.peoplePickerDelegate = self;
    }
    [self presentModalViewController:_peoplepicker animated:YES];
}

- (void)viewDidUnload
{
    [_phoneText release];
    _phoneText = nil;
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
    [_peoplepicker release];
    [_phoneText release];
    [super dealloc];
}
@end
