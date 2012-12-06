//
//  LameMp3RecorderViewController.m
//  LameMp3Recorder
//
//  Created by jian zhang on 12-7-13.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "LameMp3RecorderViewController.h"

#import "lame.h"

@interface LameMp3RecorderViewController (private)

- (void)toMp3:(NSString*)cafFileName;
- (IBAction)toPlayCAF:(NSString*)cafFileName;
- (IBAction)toPlayMp3:(NSString*)mp3FileName;

@end

@implementation LameMp3RecorderViewController

@synthesize _btnRecStop;
@synthesize _tableViewMp3;
@synthesize _tableViewCAF;
@synthesize _txtFileName;
@synthesize _lastRecordFileName;
@synthesize _arrayCAFFiles;
@synthesize _arrayMp3Files;

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isRecording=NO;
        _isConverting=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"LameMp3Recorder";
    
    NSDateFormatter *folderNameFormatter = [[NSDateFormatter alloc] init];
	[folderNameFormatter setDateFormat:@"yyyyMMddhhmmss"];
	NSString *folderName = [folderNameFormatter stringFromDate:[NSDate date]] ;
	[folderNameFormatter release];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory:%@",documentsDirectory);
	NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    NSLog(@"folderPath:%@",folderPath);
    
	_strCAFPath = [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory,@"CAF"];
    _strMp3Path = [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory,@"Mp3"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    [fileManager createDirectoryAtPath:_strCAFPath withIntermediateDirectories:YES attributes:nil error:nil]; 
    [fileManager createDirectoryAtPath:_strMp3Path withIntermediateDirectories:YES attributes:nil error:nil]; 
    
    NSError *error=nil;
    self._arrayCAFFiles =[NSMutableArray arrayWithArray: [fileManager contentsOfDirectoryAtPath:_strCAFPath error:&error]]; 
    self._arrayMp3Files =[NSMutableArray arrayWithArray: [fileManager contentsOfDirectoryAtPath:_strMp3Path error:&error]]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    
    [_btnRecStop release];
    [_tableViewCAF release];
    [_tableViewMp3 release];
    [_txtFileName release];
    
    [_lastRecordFileName release];
    [_arrayCAFFiles release];
    [_arrayMp3Files release];
    [super dealloc];
}

#pragma mark -
- (IBAction)recordOrStop:(id)sender {
    
    _isRecording=!_isRecording;
    
    if (_isRecording) {
        
        [_btnRecStop setTitle:@"停止" forState:UIControlStateNormal];
        
        NSDateFormatter *fileNameFormatter = [[NSDateFormatter alloc] init];
        [fileNameFormatter setDateFormat:@"yyyyMMddhhmmss"];
        NSString *fileName = [fileNameFormatter stringFromDate:[NSDate date]];
        [fileNameFormatter release];
        
        fileName = [fileName stringByAppendingString:@".caf"];
        NSString *cafFilePath = [_strCAFPath stringByAppendingPathComponent:fileName];
        
        NSURL *cafURL = [NSURL fileURLWithPath:cafFilePath];
    
        NSError *error;
        NSLog(@"cafURL:%@" ,cafURL);
        
        NSDictionary *recordFileSettings = [NSDictionary 
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16], 
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2], 
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0], 
                                        AVSampleRateKey,
                                        nil];
                
        @try {
            if (!_avPlayer) {
                _avRecorder = [[AVAudioRecorder alloc] initWithURL:cafURL settings:recordFileSettings error:&error];
            }else {
                if ([_avRecorder isRecording]) {
                    [_avRecorder stop];
                }
                [_avRecorder release];
                _avRecorder=Nil;
                _avRecorder = [[AVAudioRecorder alloc] initWithURL:cafURL settings:recordFileSettings error:&error];
            }
            
            if (_avRecorder) {        
                [_avRecorder prepareToRecord];        
                _avRecorder.meteringEnabled = YES;        
                
                [_avRecorder record];                           
                NSLog(@"_avRecorder recording");
                
                self._lastRecordFileName=fileName;
                
            } 
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        @finally {
            NSLog(@"%@",[error description]);
        }

    }else {
        [_btnRecStop setTitle:@"录制" forState:UIControlStateNormal];
        if (_avRecorder) {
            NSError *error=nil;
            @try {
                [_avRecorder stop];
                [_avRecorder release];
                _avRecorder=Nil;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (_arrayCAFFiles) {
                    [_arrayCAFFiles removeAllObjects];
                }
                [_arrayCAFFiles addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:_strCAFPath error:&error]];
                [_tableViewCAF reloadData];
                
                [self toMp3:self._lastRecordFileName];
           
            }
            @catch (NSException *exception) {
                NSLog(@"%@",[exception description]);

            }
            @finally {
                NSLog(@"%@",[error description]);
            }
        }
    }
}

#pragma mark -

- (void)toMp3:(NSString*)cafFileName
{
    NSString *cafFilePath =[_strCAFPath stringByAppendingPathComponent:cafFileName];
    
    NSDateFormatter *fileNameFormat=[[NSDateFormatter alloc] init];
    [fileNameFormat setDateFormat:@"yyyyMMddhhmmss"];
    NSString *mp3FileName = [fileNameFormat stringFromDate:[NSDate date]];
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [_strMp3Path stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");//被转换的文件
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSError *error=nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (_arrayMp3Files) {
            [_arrayMp3Files removeAllObjects];
        }
        [_arrayMp3Files addObjectsFromArray: [fileManager contentsOfDirectoryAtPath:_strMp3Path error:&error]]; 
        [_tableViewMp3 reloadData];
    }
}

- (IBAction)toPlay:(id)sender
{
    if ([self._txtFileName.text length]<1) {
        return;
    }
    
    if ([[_txtFileName.text substringFromIndex:[_txtFileName.text length]-3] isEqualToString:@"caf"]) {
        [self toPlayCAF:_txtFileName.text];
    }else {
        [self toPlayMp3:_txtFileName.text];
    }
}

- (IBAction)toPlayMp3:(NSString*)mp3FileName{
    
    NSString *mp3FilePath =[_strMp3Path stringByAppendingPathComponent:mp3FileName];    
    NSURL *mp3URL = [NSURL fileURLWithPath:mp3FilePath];
    NSLog(@"mp3URL:%@",mp3URL);
    
    NSError *error=Nil;
    
    if (!_avPlayer) {
        _avPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
    }else {
        if ([_avPlayer isPlaying]) {
            [_avPlayer stop];
        }
        
        [_avPlayer release];
        _avPlayer=nil;
        _avPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
    }

    
    _avPlayer.volume = 1.0;
    _avPlayer.numberOfLoops= 0;
    if(_avPlayer== nil)
        NSLog(@"%@", [error description]);
    else
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [_avPlayer play];

    } 
}

- (IBAction)toPlayCAF:(NSString*)cafFileName{
    
    NSString *cafFilePath =[_strCAFPath stringByAppendingPathComponent:cafFileName];    
    NSURL *cafURL = [NSURL fileURLWithPath:cafFilePath];
    NSLog(@"cafURL:%@",cafURL);
    
    NSError *error=nil;
    if (!_avPlayer) {
         _avPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:cafURL error:&error];
    }else {
        if ([_avPlayer isPlaying]) {
            [_avPlayer stop];
        }
        
        [_avPlayer release];
        _avPlayer=nil;
        _avPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:cafURL error:&error];
    }
    _avPlayer.volume = 1.0;
    _avPlayer.numberOfLoops= 0;
    if(_avPlayer== nil)
        NSLog(@"%@", [error description]);
    else
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [_avPlayer play];
    }    
}



#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self._tableViewMp3)
      	return [_arrayMp3Files count];
    else if(tableView == self._tableViewCAF) {
       	return [_arrayCAFFiles count];    
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;       
    if(tableView == self._tableViewCAF)
    {
        static NSString *cellName = @"CAFList";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName ] ;
        if (cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        cell.textLabel.text = [NSString  stringWithFormat:@"%@",[_arrayCAFFiles objectAtIndex:row]];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSData *data = [fileManger contentsAtPath:[_strCAFPath stringByAppendingPathComponent:cell.textLabel.text]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d K",[data length]/1024];        
        return cell;
    }
    else if(tableView == self._tableViewMp3) 
    {
        static NSString *cellName = @"Mp3List";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName ] ;
        if (cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        cell.textLabel.text = [NSString  stringWithFormat:@"%@",[_arrayMp3Files objectAtIndex:row]];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSData *data = [fileManger contentsAtPath:[_strMp3Path stringByAppendingPathComponent:cell.textLabel.text]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%dK",[data length]/1024]; 
        return cell;
        
    }else
    {
        return nil;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableViewMp3) {
        NSInteger row = indexPath.row;  
        NSString *mp3Name = [[NSString alloc] initWithFormat: [_arrayMp3Files objectAtIndex:row] ];
        [self._txtFileName setText:mp3Name];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [mp3Name release];
    }else  if (tableView==_tableViewCAF){
        NSInteger row = indexPath.row;  
        NSString *cafName = [[NSString alloc] initWithFormat: [_arrayCAFFiles objectAtIndex:row] ];
        [self._txtFileName setText:cafName];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [cafName release];
    }
}


@end
