//
//  KJNetworkGlobalConfigs.m
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import "KJNetworkGlobalConfigs.h"


@implementation KJNetworkGlobalConfigs

static KJNetworkGlobalConfigs *_configs = nil;

+ (instancetype)defaultConfigs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configs = [[KJNetworkGlobalConfigs alloc] init];
        _configs.kjResponseSerializer = JSON;
        _configs.kjRequestSerializer = JSON;
        _configs.kjObjectKey = @"data";
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
