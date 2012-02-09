//
//  BaseDataRequest.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ASIBaseDataRequest.h"

@interface SearchMapDataRequest : ASIBaseDataRequest 

@end

@interface MobileInfoDataRequest : ASIBaseDataRequest 

@end

@interface ScanLogDataRequest : ASIBaseDataRequest 

@end

@interface MakeLogDataRequest : ASIBaseDataRequest 

@end

@interface ShareLogDataRequest : ASIBaseDataRequest 

@end
//http://fengxiafei.com/mb/log/authorizeLog.action?t=0&a=eeeeeeeeee
@interface AuthorizeLogDataRequest : ASIBaseDataRequest 

@end
//http://fengxiafei.com/mb/log/weiboShareLog.action?t=0&a=eeeeeeeeee.
@interface WeiboShareLogDataRequest : ASIBaseDataRequest 

@end
@interface LastVersionDataRequest : ASIBaseDataRequest 

@end

@interface FeedBackDataRequest : ASIBaseDataRequest 

@end