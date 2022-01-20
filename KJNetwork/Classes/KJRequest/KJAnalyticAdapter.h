//
//  KJAnalyticAdapter.h
//  KJNetwork
//
//  Created by jin on 2021/12/29.
//  Copyright © 2021 jin. All rights reserved.
//

#ifndef KJAnalyticAdapter_h
#define KJAnalyticAdapter_h

@class KJRequestItem;
@class KJBaseModel;

@protocol KJAnalyticAdapter <NSObject>

- (void)analytic:(NSDictionary *)responseObject
            item:(KJRequestItem *)item
             err:(NSError *)error
          finish:(void(^)(KJBaseModel *baseModel, KJRequestItem *item))finishBlock;

@end


#endif /* KJAnalyticAdapter_h */
