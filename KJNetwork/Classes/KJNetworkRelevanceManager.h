//
//  KJNetworkRelevanceManager.h
//  KJNetwork_Example
//
//  Created by 黄克瑾 on 2020/11/17.
//  Copyright © 2020 jin. All rights reserved.
//  多个Api关联请求

#import <Foundation/Foundation.h>
#import "KJNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary * _Nullable (^KJNetworkRelevanceParameterHandle)(NSDictionary<NSString *, KJBaseModel *> *kjResult, NSArray<KJBaseModel *> *kjResultArray, KJNetworkManager *nextRequest);

typedef void(^KJNetworkRelevanceRequestHandle)(NSDictionary<NSString *, KJBaseModel *> *kjResult, NSArray<KJBaseModel *> *kjResultArray);

@interface KJNetworkRelevanceManager : NSObject

/// 多个网络请求关联发送
/// @param request 网络请求组
/// @param parameter 下一个网络请求需要增加的参数
/// @param complete 请求结果集
+ (void)kjRequest:( NSArray<KJNetworkManager *> *(^)(void))request
        parameter:(KJNetworkRelevanceParameterHandle)parameter
         complete:(_Nullable KJNetworkRelevanceRequestHandle)complete;

@end

NS_ASSUME_NONNULL_END
