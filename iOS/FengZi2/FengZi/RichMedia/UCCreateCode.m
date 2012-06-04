//
//  UCCreateCode.m
//  FengZi
//
//  Created by  on 12-1-1.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCCreateCode.h"
#import "Api+RichMedia.h"
#import "EncodeEditViewController.h"


@implementation UCCreateCode

@synthesize subject, content, mtype, bKma, code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        media = [[RichMedia alloc] init];
        subject.text = @"输入标题，少于15字";
        content.text = @"输入点内容吧，少于500字";
        tmpKey = @"123.mp4";
        bKma = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)textFieldDidEnd:(id)sender {
    [sender resignFirstResponder];
    [content resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	switch (textField.returnKeyType) {
		case UIReturnKeyNext:
			[textField resignFirstResponder];
			break;
		case UIReturnKeyGo:
			[textField resignFirstResponder];
			break;
		default:
			break;
	}
	return YES;
}

#pragma mark - View lifecycle

//--------------------< 富媒体 - 插入 - 图片 >--------------------

static int iTimes = -1;

// 插入图片
- (void)fmtAddImage{
    UIImagePickerController *mPicker = [[[UIImagePickerController alloc] init] autorelease];
    mPicker.delegate = self;
    mPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:mPicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)xInfo {
    iTimes = 0;
    UIImage *img = nil;
    
    NSString *mediaType = [xInfo objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        urlFile = nil;
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
        urlFile = [xInfo objectForKey:UIImagePickerControllerMediaURL];
        NSURL *tmpFile = urlFile.filePathURL;
        iOSLog(@"Video tmpFile = %@", tmpFile);
        iOSLog(@"Video File    = %@", tmpFile.relativePath);
        int fileSize = [iOSFile fileSize:tmpFile.relativePath];
        if (fileSize >= IOSAPI_MB(1)) {
            [iOSApi Alert:@"提示" message:@"上传影音文件不能超过1MB。"];
            [picker dismissModalViewControllerAnimated:YES];
            return;
        }
        //NSURL *videoURL = [xInfo objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
        //NSData *webData = [NSData dataWithContentsOfURL:videoURL];
        //产生缩略图
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:urlFile options:nil];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        //generator.maximumSize = CGSizeMake(VideoPickerItemImageWidth, VideoPickerItemImageWidth);
        NSError *error = nil;
        CGImageRef imgRef = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
        if (error != nil) {
            //thumb = [SShortcut imageWithName:@"default"];
        } else {
            img = [UIImage imageWithCGImage:imgRef];
        }
    }
    
	// Dismiss the image picker controller and look at the results
	[picker dismissModalViewControllerAnimated:YES];
	
	CGSize size;
	size.width = 270;
	size.height = 300;
	//UIGraphicsBeginImageContext(size);
    //[img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    UIImage *scaledImage = [img toSize:size];
    fmtBuffer = [UIImagePNGRepresentation(scaledImage) retain];
    iOSImageView2 *iv = [[iOSImageView2 alloc] initWithImage:scaledImage superView:self.view];
    iv.delegate = self;
    [iv release];
}

- (void)startUploadImage{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [iOSApi showAlert:@"正在上传图片"];
    HttpClient *hc = [[HttpClient alloc] initWithURL:API_URL_RICHMEDIA "/dynamic/m_picUpload.action" timeout:10];
    [hc formAddImage:@"content" filename:@"image.png" data:fmtBuffer];
    [hc formAddField:@"token" value:API_INTERFACE_TONKEN];
    NSData *tmpData = [hc post];
    [iOSApi closeAlert];
    if (tmpData == nil) {
        [iOSApi showCompleted:@"服务器正忙，请稍候重新登录。"];
    } else {
        iOSLog(@"Date=%@", [hc header:@"Date"]);
        NSMutableDictionary *ret = nil;
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
        if (info != nil) {
            [info release];
        }
        info = [[MediaInfo alloc] init];
        NSDictionary *data = [info parse:ret];
        if (data.count > 0) {
            [iOSApi showCompleted:@"上传成功!"];
            NSString *value = [data objectForKey:@"key"];
            if (value != nil) {
                info.key = value;
            }
            info.tinyName = [data objectForKey:@"tinyKey"];
            info.type = [Api getInt:[data objectForKey:@"type"]];
        }
    }
    [hc release];
    [iOSApi closeAlert];
    [pool release];
}

- (void)startUploadVedio{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [iOSApi showAlert:@"正在上传视频"];
    HttpClient *hc = [[HttpClient alloc] initWithURL:API_URL_RICHMEDIA "/dynamic/m_videoUpload.action" timeout:10];
    iOSLog(@"file=%@", urlFile);
    NSData *data = [NSData dataWithContentsOfURL:urlFile];
    NSString *filename = [urlFile path];
    NSString *fileext = [[filename pathExtension] lowercaseString];
    NSString *fileType = nil;
    if ([fileext isEqualToString:@"gif"]) {
        fileType = @"image/gif";
    } else if([fileext isEqualToString:@"3gp"]) {
        fileType = @"video/3gpp";
    } else {
        fileType = @"video/mp4";
    }
    [hc formAddFile:@"content" filename:filename type:fileType data:data];
    [hc formAddField:@"token" value:API_INTERFACE_TONKEN];
    NSData *tmpData = [hc post];
    if (tmpData == nil) {
        [iOSApi Alert:@"提示" message:@"服务器正忙，请稍候重新上传。"];
    } else {
        iOSLog(@"Date=%@", [hc header:@"Date"]);
        NSMutableDictionary *ret = nil;
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
        if (info != nil) {
            [info release];
        }
        info = [[MediaInfo alloc] init];
        NSDictionary *data = [info parse:ret];
        if (data.count > 0) {
            [iOSApi Alert:@"提示" message:@"上传成功!"];
            NSString *value = [data objectForKey:@"key"];
            if (value != nil) {
                info.key = value;
            }
            info.tinyName = [data objectForKey:@"tinyKey"];
            info.type = [Api getInt:[data objectForKey:@"type"]];
        }
    }
    [hc release];
    [iOSApi closeAlert];
    [pool release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	NSLog(@"选取照片 -> 取消");
	[self dismissModalViewControllerAnimated:YES];
}

//--------------------< 富媒体 - 插入 - 视频 >--------------------
// 插入视频
- (void)fmtAddVideo{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
        int index = [mediaTypes containsObject:@"public.movie"];
        if (index >= 0) {
            picker.mediaTypes = [NSArray arrayWithObject:[mediaTypes objectAtIndex:index]];
            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            picker.allowsEditing = NO;
        }
    }
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fmtAddVideo2{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
         if (group)
         {
             [group setAssetsFilter:[ALAssetsFilter allVideos]];
             [group enumerateAssetsUsingBlock:
              ^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset)
                  {
                      ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                      
                      //产生缩略图
                      AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[defaultRepresentation url] options:nil];
                      AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
                      generator.appliesPreferredTrackTransform = YES;
                      generator.maximumSize = CGSizeMake(VideoPickerItemImageWidth, VideoPickerItemImageWidth);
                      NSError *error = nil;
                      UIImage* thumb = nil;
                      CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
                      if (error != nil) {
                          //thumb = [SShortcut imageWithName:@"default"];
                      } else {
                          thumb = [UIImage imageWithCGImage:img];
                      }
                      
                      NSLog(@"one");
                  }
              }];
             NSLog(@"complete!");
         }
         [pool release];
     }
    failureBlock:^(NSError *error)
     {
         //轮询出错
         //可以先判断是什么错误，比如，用户设置了读取权限等
         //[self notifyPickingError:error];
     }
     ];
    
    [assetLibrary release];
}

//--------------------< 富媒体 - 插入 - Flash >--------------------
- (void)fmtAddFlash{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSLog(@"%@", songTitle);
    }
}

//--------------------< 富媒体 - 插入 - 音频 >--------------------
- (void)setDDListHidden:(BOOL)hidden {
    //int index = [self.seg selectedSegmentIndex];
    //nClickTimes = index;
	//NSInteger height = hidden ? 0 : 90;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[ddTypes.view setFrame:CGRectMake(30, 36, 200, 100)];
    [UIView commitAnimations];
}

static NSMutableArray *mp3List = nil;
static NSMutableArray *urlList = nil;

- (void)fmtAddAudio{
    if (mp3List != nil) {
        [mp3List release];
    }
    mp3List = [[NSMutableArray alloc] initWithCapacity:0];
    urlList = [[NSMutableArray alloc] initWithCapacity:0];
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSLog(@"%@", songTitle);
        [mp3List addObject:songTitle];
        NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
        [urlList addObject:url];
    }
    if (mp3List.count < 1) {
        [iOSApi Alert:@"iPod音乐库中没有音乐" message:nil];
        return;
    }
    ddTypes = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
	ddTypes.delegate = self;
    [ddTypes._resultList removeAllObjects];
    [ddTypes._resultList addObjectsFromArray: mp3List];
	[self.view addSubview:ddTypes.view];
    [ddTypes.view setFrame:CGRectMake(0, 0, 0, 0)];
    [ddTypes updateData: mp3List];
    [self setDDListHidden:NO];
}

#pragma mark -
#pragma mark DropDownList protocol

- (void)passValue:(NSString *)value{
    //
}

- (void)uploadAudio:(NSData *)data {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [iOSApi showAlert:@"正在上传背景音乐"];
    HttpClient *hc = [[HttpClient alloc] initWithURL:API_URL_RICHMEDIA "/dynamic/m_soundUpload.action" timeout:10];
    
    [hc formAddFile:@"content" filename:@"item.mp3" type:@"audio/mpeg" data:data];
    [hc formAddField:@"token" value:API_INTERFACE_TONKEN];
    NSData *tmpData = [hc post];
    if (tmpData == nil) {
        [iOSApi Alert:@"提示" message:@"服务器正忙，请稍候重新登录。"];
    } else {
        iOSLog(@"Date=%@", [hc header:@"Date"]);
        NSMutableDictionary *ret = nil;
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
        if (info != nil) {
            [info release];
        }
        info = [[MediaInfo alloc] init];
        NSDictionary *data = [info parse:ret];
        if (data.count > 0) {
            [iOSApi Alert:@"提示" message:@"背景音乐上传成功!"];
            NSString *value = [data objectForKey:@"key"];
            if (value != nil) {
                info.key = value;
                bgMuisc = value;
            }
            info.tinyName = [data objectForKey:@"tinyKey"];
            info.type = [Api getInt:[data objectForKey:@"type"]];
        }
    }
    [hc release];
    [iOSApi closeAlert];
    [pool release];
}

- (void)dropDown:(DropDownList *)dropDown index:(int)index {
    //itype.text = value;
    [self setDDListHidden:YES];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *url = [urlList objectAtIndex:index];
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    NSLog(@"%@",url);
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetPassthrough];
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    exporter.outputFileType = @"com.apple.m4a-audio";
    //exporter.fileLengthLimit = 1024 * 1024;
    NSString *exportFile = [documentsDirectory stringByAppendingPathComponent: @"item.mp3"];
    NSError *error1;
    if([[NSFileManager defaultManager] fileExistsAtPath:exportFile]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportFile error:&error1];
    }
    NSURL* exportURL = [[NSURL fileURLWithPath:exportFile] retain];
    exporter.outputURL = exportURL; 
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSData *data1 = [NSData dataWithContentsOfFile: [documentsDirectory stringByAppendingPathComponent: @"item.mp3"]];
        [NSThread detachNewThreadSelector:@selector(uploadAudio:) toTarget:self withObject:data1];
        //NSLog(@"%@",infoDict);
        //mAppDelegate.uploadType = @"Audio";
        int exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed: {
                // log error to text view
                NSError *exportError = exporter.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                //      errorView.text = exportError ? [exportError description] : @"Unknown failure";
                
                //errorView.hidden = NO;
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog (@"AVAssetExportSessionStatusCompleted");
                break;
            }
            case AVAssetExportSessionStatusUnknown: {
                NSLog (@"AVAssetExportSessionStatusUnknown");
                break;
            }
            case AVAssetExportSessionStatusExporting: {
                NSLog (@"AVAssetExportSessionStatusExporting");
                break;
            }
            case AVAssetExportSessionStatusCancelled: {
                NSLog (@"AVAssetExportSessionStatusCancelled");
                break;
            }
            case AVAssetExportSessionStatusWaiting: {
                NSLog (@"AVAssetExportSessionStatusWaiting");
                break;
            }
            default: 
            {
                NSLog (@"didn't get export status");
                break;
            }
        }        
    }];
    [pool release];
}

// 插入
- (IBAction)doFmtAdd:(id)sender {
    switch ([mtype selectedSegmentIndex]) {
        case 0: // 图片
            type = 1;
            [self fmtAddImage];
            break;
        case 1: // 视频
            type = 3;
            [self fmtAddVideo];
            break;
        default:
            break;
    }
}

// 插入音频
- (IBAction)doFmtAddAudio:(id)sender {
    [self fmtAddAudio];
}

- (void)imageViewWillClose:(iOSImageView2 *)imageView {
    if (type == 1) {
        //[NSThread detachNewThreadSelector:@selector(startUploadImage) toTarget:self withObject:nil];
        [self startUploadImage];
    } else {
        //[NSThread detachNewThreadSelector:@selector(startUploadVedio) toTarget:self withObject:nil];
        [self startUploadVedio];
    }
}

// 生码
- (void)generateCode{
    /*
    if (info == nil) {
        [iOSApi Alert:@"提示" message:@"生码前，请先选择媒体文件。"];
        return;
    }
     */
    // 想服务器上传 json串
    NSString *title = [subject.text trim];
    NSString *desc = [content.text trim];
    NSString *nameAudio = @"";//@"20120107_2fd6a72e-6b5e-431f-9b8d-a797c489a66e.mp3";
    NSString *nameVideo = @"";
    if(info != nil && info.key != nil) {
        nameVideo = info.key;
    }
    NSString *nameTiny = @"";
    if (info != nil && info.tinyName != nil) {
        nameTiny = info.tinyName;
    }
    int nType = [mtype selectedSegmentIndex];
    if (nType < 0) {
        nType = 0;
    }
    [iOSApi showAlert:@"上传富媒体模板中"];
    NSString *xCode = @"";
    if ([Api kma]) {
        xCode = [Api kmaId];
    }
    ModelInfo *xRet= [[Api uploadModel:title content:desc sound:nameAudio vedio:nameVideo type:nType tiny:nameTiny uuid:xCode] retain];
    [iOSApi closeAlert];
    if (xRet.status != 0) {
        [iOSApi Alert:@"提示" message:xRet.message];
        return;
    } else {
        // 把JSON转为数组
        [iOSApi showCompleted:@"上传成功"];
        [iOSApi closeAlert];
    }
    
    media.title = [subject.text trim];
    media.content = [content.text trim];
    media.url = xRet.url;
    media.type = nType;
    
    EncodeEditViewController *editView =[[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil] autorelease];
    if (![Api kma]) {
        [self.navigationController pushViewController:editView animated:YES];
        [editView loadObject:media];
    } else {
        [editView viewDidLoad];
        [editView loadObject:media];
        //NSString *ss = editView.content;
        //[Api uploadKma:ss];
        //[editView tapOnSaveBtn:nil];
    }
    //[editView release];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    label.text= bKma ? @"制作专属码" : @"个性化内容生码";
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
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    if ([Api kma]) {
        [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    } else {
        [_btnRight setImage:[UIImage imageNamed:@"generate_code.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"generate_code_tap.png"] forState:UIControlStateHighlighted];
    }
    [_btnRight addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    /*
    if (bKma) {
        subject.text = @"";
        subject.placeholder = @"我是空码，输入属于自己的名字";
        content.text = @"";
        
        NSDictionary *dict = [Api parseUrl:code];
        code = [dict objectForKey:@"id"];
        [iOSApi Alert:@"空码赋值" message:[NSString stringWithFormat:@"id=%@", code]];
    } else {
        subject.text = @"输入标题，少于15字";
        content.text = @"输入点内容吧，少于500字";
    }
    */
    // 键盘事件代理
    //content.delegate = self;
    content.editable = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
