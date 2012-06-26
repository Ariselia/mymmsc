//
//  UIFontAdditions.m
//  AiQiChe
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIFontAdditions.h"


@implementation UIFont (ITTAdditions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ittLineHeight {
    return (self.ascender - self.descender) + 1;
}

@end
