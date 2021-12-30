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

/// 设置解析的BaseModel，必须是KJBaseModel的子类， 默认KJBaseModel
@property (nonatomic, copy) NSString *kjBaseModelName;

/// 请求超时时长，默认为60s
@property (nonatomic, assign) NSTimeInterval timeout;

/// 设置可接受的内容类型，默认@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html"
@property (nonatomic, copy) NSSet <NSString *> *kjAcceptableContentTypes;

/// 网络请求适配器，适配器必须实现协议KJRequestAdapter，默认KJAFNetworkAdapter
@property (nonatomic, copy) NSString *requestAdapter;

/// 数据解析适配器，适配器必须实现协议KJAnalyticAdapter，默认KJMJAnalyticAdapter
@property (nonatomic, copy) NSString *analyticAdapter;

@end

NS_ASSUME_NONNULL_END
