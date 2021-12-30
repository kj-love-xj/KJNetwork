//
//  KJNetworkGlobalConfigs.m
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import "KJNetworkGlobalConfigs.h"

@interface KJNetworkGlobalConfigs ()

/// 全局参数配置
@property (nonatomic, strong, readwrite) NSMutableDictionary *kjParams;

/// 全局Header配置
@property (nonatomic, strong, readwrite) NSMutableDictionary *kjHeader;

@end

@implementation KJNetworkGlobalConfigs

static KJNetworkGlobalConfigs *_configs = nil;

+ (instancetype)defaultConfigs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configs = [[KJNetworkGlobalConfigs alloc] init];
        _configs.kjResponseSerializer = JSON;
        _configs.kjRequestSerializer = JSON;
        _configs.kjObjectKey = @"data";
        _configs.kjBaseModelName = @"KJBaseModel";
        _configs.timeout = 60.0;
        _configs.kjAcceptableContentTypes = [[NSSet alloc]initWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html", nil];
        _configs.requestAdapter = @"KJAFNetworkAdapter";
        _configs.analyticAdapter = @"KJMJAnalyticAdapter";
    });
    return _configs;
}


- (NSMutableDictionary *)kjParams {
    if (!_kjParams) {
        _kjParams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _kjParams;
}

- (NSMutableDictionary *)kjHeader {
    if (!_kjHeader) {
        _kjHeader = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _kjHeader;
}


@end
