//
//  EncodeEditViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecorateView.h"
#import "EditImageView.h"
#import "ITTDataRequest.h"
#import "ITTImageView.h"

#import "CodeAttribute.h"
#import "Api+RichMedia.h"

@interface EncodeEditViewController : UIViewController<DecorateViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditImageViewDelegate,DataRequestDelegate>{
    UIImageView *_encodeImageView;
    IBOutlet ITTImageView *_backgoundImage;
    IBOutlet UIView *_backgroundView;
    IBOutlet UIView *_encodeView;
    NSString *_content;
    EditImageType _type;
    UIColor *_curColor;
    UIImage *_curIcon;
    UIImage *_curSkin;
    BOOL _isDefaultSkin;
    DecorateView *_decorateView;
    IBOutlet UIView *_toolView;
    IBOutlet UIButton *_editColorBtn;
    IBOutlet UIButton *_editIconBtn;
    IBOutlet UIButton *_camecaBtn;
    IBOutlet UIButton *_editSkinBtn;
    IBOutlet UIButton *_saveBtn;
    NSString *_logId;
    id _codeObject;
    CodeAttribute *_codeAtt;
    NSString *_showInfo;
}
@property (retain, nonatomic) IBOutlet UIImageView *encodeImageView;
@property (assign, nonatomic) EditImageType type;
@property (nonatomic, retain) NSString *content;

- (IBAction)tapOnSaveBtn:(id)sender;
- (void)loadObject:(id)object;
@end
