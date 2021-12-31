//
//  KJRequestManager.m
//  KJNetwork_Example
//
//  Created by jin on 2021/12/28.
//  Copyright © 2021 jin. All rights reserved.
//

#import "KJRequestManager.h"

#import "MJExtension/MJExtension.h"
#import "KJNetworkGlobalConfigs.h"
#import "KJRequestAdapter.h"
#import "KJAnalyticAdapter.h"

@interface KJRequestManager ()

/// 同时发送的请求
@property (nonatomic, strong) NSMutableArray <KJRequestItem *> *groupArr;
/// 关联发送的请求
@property (nonatomic, strong) NSMutableArray <KJRequestItem *> *assArr;
/// 请求的结果集
@property (nonatomic, strong) NSMutableDictionary <NSString *, KJBaseModel *> *multipleResults;

@end

@implementation KJRequestManager

/// 初始化
+ (instancetype)initWithItem:(KJRequestItem *)item {
    return [self initWithItems: item != nil ? @[item] : @[] ];
}

/// 初始化
+ (instancetype)initWithItems:(NSArray <KJRequestItem *> *)items {
    KJRequestManager *manager = [KJRequestManager new];
    for (KJRequestItem *item in items) {
        [manager add: item];
    }
    return manager;
}

/// 添加请求
- (KJRequestManager *)add:(KJRequestItem *)item {
    if (item.interceptHandle != nil) {
        [self.assArr addObject:item];
    } else {
        [self.groupArr addObject:item];
    }
    return self;
}

/// 添加请求
- (KJRequestManager *)add:(KJRequestItem *)item
  intercept:(KJRequestItemInterceptHandle _Nullable)interceptHandle{
    item.interceptHandle = interceptHandle;
    return [self add:item];
}

/// 开始网络请求
- (void)request:(KJRequestHandle)complete {
    __weak typeof(self) weakSelf = self;
    [self groupHandle:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (complete != nil) {
            // 所有的网络请求都已结束，处理外部回调
            if (strongSelf.groupArr.count + strongSelf.assArr.count > 1) {
                complete(strongSelf.multipleResults);
            } else {
                complete(strongSelf.multipleResults.allValues.firstObject);
            }
        }
    }];
}

/// 处理请求组
- (void)groupHandle:(void(^)(void))handle {
    if (self.groupArr.count > 0) {
        // 线程组
        dispatch_group_t group = dispatch_group_create();
        // 线程
        __weak typeof(self) weakSelf = self;
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            __strong typeof(self) strongSelf = weakSelf;
            for (KJRequestItem *item in strongSelf.groupArr) {
                // 入组
                dispatch_group_enter(group);
                // 发送网络请求
                [strongSelf send:item handle:^{
                    // 退组
                    dispatch_group_leave(group);
                }];
            }
        });
        // 所有请求结束后，返回结果集
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self associationHandle:handle];
        });
    } else {
        [self associationHandle:handle];
    }
}

/// 处理关联请求
- (void)associationHandle:(void(^)(void))handle {
    if (self.assArr.count > 0) {
        // 信号量
        dispatch_semaphore_t semaphoreQueue = dispatch_semaphore_create(0);
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __strong typeof(self) strongSelf = weakSelf;
            // 循环所有需要发送的请求
            for (KJRequestItem *item in strongSelf.assArr) {
                // 发送请求
                [strongSelf send:item handle:^{
                    // 让线程继续执行
                    dispatch_semaphore_signal(semaphoreQueue);
                }];
                // 让线程等待
                dispatch_semaphore_wait(semaphoreQueue, DISPATCH_TIME_FOREVER);
            }
            // 所有请求结束后，返回结果集
            dispatch_async(dispatch_get_main_queue(), ^{
                handle();
            });
        });
    } else {
        handle();
    }
}

/// 发送网络请求
- (void)send:(KJRequestItem *)item handle:(void(^)(void))handle {
    // 处理拦截
    if (item.interceptHandle != nil) {
        item.interceptHandle(item, self.multipleResults);
    }
    // 网络请求适配器
    id<KJRequestAdapter> request = [NSClassFromString(item.requestAdapter) new];
    // 开始网络请求
    __weak typeof(self) weakSelf = self;
    [request request:item finish:^(KJRequestItem *item, NSDictionary *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf analytic:item response:response err:error handle:handle];
    }];
}

/// 解析数据
- (void)analytic:(KJRequestItem *)item
        response:(NSDictionary *)response
             err:(NSError *)err
          handle:(void(^)(void))handle {
    // 数据解析适配器
    id<KJAnalyticAdapter> analytic = [NSClassFromString(item.analyticAdapter) new];
    // 开始解析数据
    __weak typeof(self) weakSelf = self;
    [analytic analytic:response item:item err:err finish:^(KJBaseModel *baseModel, KJRequestItem *item) {
        // 保存解析的数据
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.multipleResults setObject:baseModel forKey:item.groupKey];
        // 解析结束，整个过程结束，回调
        handle();
    }];
}


//MARK: - property

- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        _groupArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupArr;
}

- (NSMutableArray *)assArr {
    if (!_assArr) {
        _assArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _assArr;
}

- (NSMutableDictionary *)multipleResults {
    if (!_multipleResults) {
        _multipleResults = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _multipleResults;
}

@end
