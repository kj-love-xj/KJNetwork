//
//  KJNetworkGroupManager.h
//  KJNetwork_Example
//
//  Created by 黄克瑾 on 2020/7/14.
//  Copyright © 2020 jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KJNetworkGroupRequestHandle)(NSDictionary<NSString *, KJBaseModel *> * kjResult);

@interface KJNetworkGroupManager : NSObject

/// 多个网络请求同时发送
/// @param request 网络请求组
/// @param complete 请求结果集
+ (instancetype)kjRequest:(NSArray<KJNetworkManager *> *(^)())request
                 complete:(nullable KJNetworkGroupRequestHandle)complete;

@end

NS_ASSUME_NONNULL_END
