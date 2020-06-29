//
//  KJBaseModel.h
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 如果特殊情况 可以用继承来扩展
 */

@interface KJBaseModel : NSObject

/// 错误码
@property (nonatomic, assign) NSInteger code;
/// 错误信息
@property (nonatomic, copy) NSString *message;
/// 解析后的数据
@property (nonatomic, strong) NSArray *data;
/// 服务端返回的原数据
@property (nonatomic, strong) id responseObject;
/// 是否请求成功，如果这里的实现不够，可以继承后重写get方法
@property (nonatomic, assign, readonly) BOOL succeed;

@end

NS_ASSUME_NONNULL_END
