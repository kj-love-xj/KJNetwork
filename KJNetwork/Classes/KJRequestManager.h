//
//  KJRequestManager.h
//  KJNetwork_Example
//
//  Created by jin on 2021/12/28.
//  Copyright © 2021 jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJRequestItem.h"

NS_ASSUME_NONNULL_BEGIN

// resultObject 当多个网络请求时，该类型就是NSDictionary <NSString *, KJBaseModel *> *
// 当只有一个网络请求时，返回KJBaseModel
typedef void(^KJRequestHandle)(id resultObject);


@interface KJRequestManager : NSObject

/// 初始化
+ (instancetype)initWithItem:(KJRequestItem *)item;

/// 初始化
+ (instancetype)initWithItems:(NSArray <KJRequestItem *> *)items;

/// 添加请求
- (void)add:(KJRequestItem *)item;

/// 添加请求
- (void)add:(KJRequestItem *)item
  intercept:(KJRequestItemInterceptHandle _Nullable)interceptHandle;

/// 开始网络请求
- (void)request:(KJRequestHandle _Nullable)complete;

@end

NS_ASSUME_NONNULL_END
