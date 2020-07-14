//
//  KJNetworkGroupManager.m
//  KJNetwork_Example
//
//  Created by 黄克瑾 on 2020/7/14.
//  Copyright © 2020 jin. All rights reserved.
//

#import "KJNetworkGroupManager.h"

@implementation KJNetworkGroupManager

/// 多个网络请求同时发送
/// @param request 网络请求组
/// @param complete 请求结果集
+ (instancetype)kjRequest:(NSArray<KJNetworkManager *> *(^)())request
                 complete:(nullable KJNetworkGroupRequestHandle)complete {
    KJNetworkGroupManager *manager = [KJNetworkGroupManager new];
    NSArray *requestObjectArray = request();
    if (requestObjectArray.count <= 0) {
        NSLog(@"请设置KJNetworkManager对象");
        return manager;
    }
    // 请求结果集
    NSMutableDictionary<NSString *, KJBaseModel *> *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    // 线程组
    dispatch_group_t group = dispatch_group_create();
    // 开始发送请求
    for (KJNetworkManager *network in requestObjectArray) {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [network sendRequest:^(KJBaseModel * _Nonnull kjModel) {
                [dict setValue:kjModel forKey:kjModel.requestUrl];
                dispatch_group_leave(group);
            }];
        });
    }
    // 所有请求结束后，返回结果集
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (complete != nil) {
            complete(dict);
        }
    });
    return manager;
}

@end
