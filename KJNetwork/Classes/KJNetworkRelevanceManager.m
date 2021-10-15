//
//  KJNetworkRelevanceManager.m
//  KJNetwork_Example
//
//  Created by 黄克瑾 on 2020/11/17.
//  Copyright © 2020 jin. All rights reserved.
//

#import "KJNetworkRelevanceManager.h"

@implementation KJNetworkRelevanceManager

/// 多个网络请求关联发送
/// @param request 网络请求组
/// @param parameter 下一个网络请求需要增加的参数
/// @param complete 请求结果集
+ (void)kjRequest:( NSArray<KJNetworkManager *> *(^)(void))request
        parameter:(KJNetworkRelevanceParameterHandle)parameter
         complete:(_Nullable KJNetworkRelevanceRequestHandle)complete {
    NSArray *requestObjectArray = request();
    if (requestObjectArray.count <= 0) {
        NSLog(@"请设置KJNetworkManager对象");
        return;
    }
    // 请求结果集
    NSMutableDictionary<NSString *, KJBaseModel *> *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray<KJBaseModel *> * data = [NSMutableArray arrayWithCapacity:0];
    // 信号量
    dispatch_semaphore_t semaphoreQueue = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 开始发送请求
        for (int i = 0; i < requestObjectArray.count; i ++) {
            KJNetworkManager *network = requestObjectArray[i];
            [network sendRequest:^(KJBaseModel * _Nonnull kjModel) {
                [dict setValue:kjModel forKey:kjModel.groupResponseKey];
                [data addObject:kjModel];
                if (i < requestObjectArray.count - 1) {
                    KJNetworkManager *next = requestObjectArray[i + 1];
                    NSDictionary *params = parameter(dict, data, next);
                    if (params != nil && params.count > 0) {
                        next.kjParams(params);
                    }
                }
                dispatch_semaphore_signal(semaphoreQueue);
            }];
            dispatch_semaphore_wait(semaphoreQueue, DISPATCH_TIME_FOREVER);
        }
        // 所有请求结束后，返回结果集
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete != nil) {
                complete(dict, data);
            }
        });
    });
}



@end
