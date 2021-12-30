//
//  KJRequestAdapter.h
//  KJNetwork
//
//  Created by jin on 2021/12/29.
//  Copyright © 2021 jin. All rights reserved.
//

#ifndef KJRequestAdapter_h
#define KJRequestAdapter_h

@class KJRequestItem;

@protocol KJRequestAdapter <NSObject>

- (void)request:(KJRequestItem *)item
         finish:(void(^)(KJRequestItem *item,
                         NSDictionary *response,
                         NSError *error))finishBlock;

@end

#endif /* KJRequestAdapter_h */
