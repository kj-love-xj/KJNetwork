//
//  KJNetworkGroupManager.h
//  KJNetwork_Example
//
//  Created by 黄克瑾 on 2020/7/14.
//  Copyright © 2020 jin. All rights reserved.
//  多个Api一起请求，返回一个结果集

#import <Foundation/Foundation.h>
#import "KJNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KJNetworkGroupRequestHandle)(NSDictionary<NSString *, KJBaseModel *> * kjResult);

__deprecated_msg("请使用KJRequestManager来处理网络请求")
@interface KJNetworkGroupManager : NSObject

/// 多个网络请求同时发送
/// @param request 网络请求组
/// @param complete 请求结果集
+ (void)kjRequest:(NSArray<KJNetworkManager *> *(^)(void))request
         complete:(nullable KJNetworkGroupRequestHandle)complete __deprecated_msg("请使用KJRequestManager来处理网络请求");

@end

NS_ASSUME_NONNULL_END
