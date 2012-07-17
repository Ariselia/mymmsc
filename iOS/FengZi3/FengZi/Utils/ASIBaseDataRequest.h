//
//  ASIBaseDataRequest.h
//  hupan
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTRequestResult.h"
#import <iOSApi/ASIFormDataRequest.h>
#import "ITTBaseDataRequest.h"

/**
 * NOTE:BaseDataRequest will handle it`s own retain/release lifecycle management, no need to release it manually
 */
@interface ASIBaseDataRequest : ITTBaseDataRequest{
    ASIFormDataRequest* _request;
}

@end
