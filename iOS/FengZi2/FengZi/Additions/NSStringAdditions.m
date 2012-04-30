//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIFontAdditions.h"

//#import "Three20UI.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
										 withLineWidth:(NSInteger)lineWidth{
  CGSize size = [self sizeWithFont:font
								 constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
										 lineBreakMode:UILineBreakModeTailTruncation];
	NSInteger lines = size.height / [font ittLineHeight];
	return lines;
}
- (CGFloat)heightWithFont:(UIFont*)font
						withLineWidth:(NSInteger)lineWidth{
  CGSize size = [self sizeWithFont:font
								 constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
										 lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
	
}

- (NSString *)md5{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}
@end

