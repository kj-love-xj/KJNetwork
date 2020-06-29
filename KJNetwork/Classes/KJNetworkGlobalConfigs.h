//
//  KJNetworkGlobalConfigs.h
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJNetworkStruct.h"

NS_ASSUME_NONNULL_BEGIN


@interface KJNetworkGlobalConfigs : NSObject

+ (instancetype)defaultConfigs;

/// 全局参数配置
@property (nonatomic, strong, readonly) NSMutableDictionary *kjParams;

/// 全局Header配置
@property (nonatomic, strong, readonly) NSMutableDictionary *kjHeader;

/// 设置HOST
@property (nonatomic, copy) NSString *kjHost;

/// 设置请求序列化类型 默认JSON
@property (nonatomic, assign) KJNetworkSerializer kjRequestSerializer;

/// 设置结果序列化类型 默认JSON
@property (nonatomic, assign) KJNetworkSerializer kjResponseSerializer;

/// 设置结果集在返回数据(responseObject)中的Key，如果业务方属性名有不同，需要设置，默认 data
@property (nonatomic, copy) NSString *kjObjectKey;

@end

NS_ASSUME_NONNULL_END
