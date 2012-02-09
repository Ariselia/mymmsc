

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#include "QR_Encode.h"
#import "DataMatrix.h"

//level L : 最大 7% 的错误能够被纠正；
//level M : 最大 15% 的错误能够被纠正；
//level Q : 最大 25% 的错误能够被纠正；
//level H : 最大 30% 的错误能够被纠正；
const static int QR_ECLEVEL_AUTO =  0;
const static int QR_ECLEVEL_H =     QR_LEVEL_H;
const static int QR_ECLEVEL_M =     QR_LEVEL_M;
const static int QR_ECLEVEL_L =     QR_LEVEL_L;
const static int QR_ECLEVEL_Q =     QR_LEVEL_Q;

const static int QR_VERSION_AUTO =  -1;

const static int BITS_PER_BYTE =    8;
const static int BYTES_PER_PIXEL =  4;

const static unsigned char WHITE =  0xff;

@interface QREncoder : NSObject {
    
}

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString *)string AESPassphrase:(NSString*)AESPassphrase;

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString*)string;

+ (UIImage*)renderDataMatrix:(DataMatrix*)matrix imageDimension:(int)imageDimension;

+ (UIImage*)renderDataMatrix:(DataMatrix*)matrix 
              imageDimension:(int)imageDimension
                    colorRed:(int)red
                  colorGreen:(int)greed
                   colorBlue:(int)blue;
@end
