//
//  EncodeCardViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeCardViewController.h"
#import "EncodeEditViewController.h"
#import "Card.h"
#import "AddressBookUtils.h"
#import "BusDecoder.h"

#define Name_field @"0field"
#define Address_field @"8field"
#define Title_field @"2field"
#define Telephone_field @"4field"
#define Url_field @"5field"
#define Fax_field @"6field"
#define Cellphone_field @"7field"
#define Department_field @"3field"
#define Corporation_field @"1field"
#define Email_field @"9field"
#define ZipCode_field @"10field"
#define QQ_field @"11field"
#define Msn_field @"12field"
#define Weibo_field @"13field"

@implementation EncodeCardViewController

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
    if (![dic objectForKey:Name_field]||[[dic objectForKey:Name_field] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    NSString *text = [dic objectForKey:Url_field];
    if (text && ![text isEqualToString:@""] && ![BusDecoder isUrl:text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"公司网址格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    text = [dic objectForKey:Telephone_field];
    if (text && ![text isEqualToString:@""] && ![CommonUtils validateCellPhone:text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"固定电话话格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    text = [dic objectForKey:Cellphone_field];
    if (text && ![text isEqualToString:@""] && ![CommonUtils validateCellPhone:text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"移动电话格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    text = [dic objectForKey:Email_field];
    if (text && ![text isEqualToString:@""] && ![CommonUtils validateEmail:text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电子邮箱格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    Card *card = [[[Card alloc] init] autorelease];
    card.name = [dic objectForKey:Name_field];
    card.address = [dic objectForKey:Address_field];
    card.title = [dic objectForKey:Title_field];
    card.telephone = [dic objectForKey:Telephone_field];
    card.url = [dic objectForKey:Url_field];
    card.fax = [dic objectForKey:Fax_field];
    card.cellphone = [dic objectForKey:Cellphone_field];
    card.department = [dic objectForKey:Department_field];
    card.corporation = [dic objectForKey:Corporation_field];
    card.email = [dic objectForKey:Email_field];
    card.zipCode = [dic objectForKey:ZipCode_field];
    card.qq = [dic objectForKey:QQ_field];
    card.msn = [dic objectForKey:Msn_field];
    card.weibo = [dic objectForKey:Weibo_field];
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    [self.navigationController pushViewController:editView animated:YES];
    [editView loadObject:card];
    [editView release];
}

//隐藏键盘是屏幕动画
- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = _tableview.frame;
    frame.size.height = 366;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _tableview.frame = frame;
    [UIView commitAnimations];
}

-(void)selectPhone{
    if(!_peoplepicker){
        _peoplepicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplepicker.peoplePickerDelegate = self;
    }
    [self keyboardWillHide:nil];
    [self hideKeyBoard];
    [self presentModalViewController:_peoplepicker animated:YES];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
    [dic removeAllObjects];
    [dic setObject:[AddressBookUtils getFullName:person] forKey:Name_field];
    
    NSString *mail = [[AddressBookUtils getFirstEmail:person] retain];
    [dic setObject:mail forKey:Email_field];
    [mail release];
    
    ABMultiValueRef organs = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonOrganizationProperty);
    if (organs) {
        [dic setObject:(NSString *)organs forKey:Corporation_field];
        CFRelease(organs);
    }
    
    ABMultiValueRef des = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonDepartmentProperty);
    if (des) {
        [dic setObject:(NSString *)des forKey:Department_field];
        CFRelease(des);
    }
    
    ABMultiValueRef titles = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonJobTitleProperty);
    if (titles) {
        [dic setObject:(NSString *)titles forKey:Title_field];
        CFRelease(titles);
    }
    
    
    ABMultiValueRef urls = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonURLProperty);
    if (urls) {
        for(int i = 0 ;i < ABMultiValueGetCount(urls); i++)
        {  
            NSString *organ = (NSString *)ABMultiValueCopyValueAtIndex(urls, i); 
            [dic setObject:organ forKey:Url_field];
            [organ release];
            break;
        }      
        CFRelease(urls);
    }
    
    
    
    ABMultiValueRef addr = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonAddressProperty);
    if (addr) {
        int count = ABMultiValueGetCount(addr);
        for (CFIndex i = 0; i < count; i++) {
            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(addr, i); 
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            if(zip != nil){
                [dic setObject:zip forKey:ZipCode_field];
            }
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            if(street != nil){
                [dic setObject:street forKey:Address_field];
            }
            [personaddress release];
        }
        CFRelease(addr);
    }
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        //social
        ABMultiValueRef social = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
        if (social) {
            for (int s = 0 ; s < ABMultiValueGetCount(social); s++) {
                NSDictionary *socialDict = (NSDictionary *)ABMultiValueCopyValueAtIndex(social, s);
                NSString* service = [socialDict valueForKey:(NSString *)kABPersonSocialProfileServiceKey];
                NSString* username = [socialDict valueForKey:(NSString *)kABPersonSocialProfileUsernameKey];
                if (service&&[service isEqualToString:@"微博"]&&username) {
                    [dic setObject:username forKey:Weibo_field];
                }
                [socialDict release];
            }
            CFRelease(social);
        }
    }
    
    ABMultiValueRef msn = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonInstantMessageProperty);
    if (msn) {
        int count = ABMultiValueGetCount(msn);
        for (CFIndex i = 0; i < count; i++) {
            NSDictionary* personmsn =(NSDictionary*) ABMultiValueCopyValueAtIndex(msn, i); 
            NSString* key = [personmsn valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            if(key != nil && [key isEqualToString:@"MSN"]){
                NSString* msnAccout = [personmsn valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
                if(msnAccout != nil){
                    [dic setObject:msnAccout forKey:Msn_field];
                }
            }
            [personmsn release];
        }
        CFRelease(msn);
    }

    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);    
    if (phones){
        int count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++) {
            NSString *phoneNumber = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *title = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            if ([title isEqualToString:(NSString *)kABPersonInstantMessageServiceQQ]) {
                [dic setObject:phoneNumber forKey:QQ_field];
            }else if ([title isEqualToString:(NSString *)kABPersonPhoneWorkFAXLabel]) {
                [dic setObject:phoneNumber forKey:Fax_field];
            }else if ([title isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                [dic setObject:phoneNumber forKey:Cellphone_field];
            }else if ([title isEqualToString:(NSString *)kABPersonPhoneMainLabel]) {
                [dic setObject:phoneNumber forKey:Telephone_field];
            }
            [phoneNumber release];
            [title release];
        }
        CFRelease(phones);
    }
    
    [peoplePicker dismissModalViewControllerAnimated:YES];  
    [_tableview reloadData];
    return NO;  
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker 
{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"名片生码";
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
    if ([Api kma]) {
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:@"generate_code.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"generate_code_tap.png"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
}
#pragma mark -
#pragma mark keyboardEvent

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

-(void)hideKeyBoard{
    for (int i =0; i<14; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CardTableViewCell *curCell = (CardTableViewCell*)[_tableview cellForRowAtIndexPath:indexPath];
        [curCell.textField resignFirstResponder]; 
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [self keyboardWillHide:nil];
    [self hideKeyBoard];
}

#pragma mark - UITableViewDataSource method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 60;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MessageCellw";    
    CardTableViewCell *cell = (CardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [CardTableViewCell cellFromNib]; 
        cell.indexPath = indexPath;
        cell.delegate=self;
    }    
    cell.textField.returnKeyType = UIReturnKeyNext;
    switch (indexPath.row) {
        case 0:{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(selectPhone) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"add_address.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"add_address_tap.png"] forState:UIControlStateHighlighted];
            [cell addPhoneButton:btn];
            cell.nameField.text = @"姓名";
            break;
        }
        case 1:
            cell.nameField.text = @"公司";
            break;
        case 2:
            cell.nameField.text = @"职位名称";
            break;
        case 3:
            cell.nameField.text = @"公司部门";
            break;
        case 4:
            cell.nameField.text = @"固定电话";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 5:
            cell.nameField.text = @"公司网址";
            cell.textField.keyboardType = UIKeyboardTypeURL;
            break;
        case 6:
            cell.nameField.text = @"公司传真";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 7:
            cell.nameField.text = @"移动电话";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 8:
            cell.nameField.text = @"公司地址";
            break;
        case 9:
            cell.nameField.text = @"电子邮箱";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 10:
            cell.nameField.text = @"邮政编码";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 11:
            cell.nameField.text = @"QQ";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 12:
            cell.nameField.text = @"MSN";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 13:
            cell.nameField.text = @"个人微博";
            cell.textField.keyboardType = UIKeyboardTypeURL;
            cell.textField.returnKeyType = UIReturnKeyDefault;
            break;
        default:
            cell.hidden=YES;
            break;
    }
    NSString *str = [dic objectForKey:[NSString stringWithFormat:@"%dfield",indexPath.row]];
    if (str) {
        cell.textField.text = str;
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyBoard];
}

-(void)editEnd:(NSString *)value key:(NSString *)k{
    [dic setObject:value forKey:k];
}

-(void)editBegin:(NSIndexPath *)indexPath{
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = _tableview.frame;
    frame.size.height = 198;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _tableview.frame = frame;
    [UIView commitAnimations];
    [_tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)nextCellEdit:(NSIndexPath *)indexPath{
    indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    if (indexPath.row <1) {
        [_tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [_tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    CardTableViewCell *curCell = (CardTableViewCell*)[_tableview cellForRowAtIndexPath:indexPath];
    [curCell.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [_tableview release];
    _tableview = nil;
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
    [dic release];
    [_tableview release];
    [super dealloc];
}
@end
