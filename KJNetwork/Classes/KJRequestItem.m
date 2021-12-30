//
//  KJRequestItem.m
//  KJNetwork_Example
//
//  Created by jin on 2021/12/28.
//  Copyright © 2021 jin. All rights reserved.
//

#import "KJRequestItem.h"
#import "KJNetworkGlobalConfigs.h"

@implementation KJRequestItem


+ (instancetype) initURL:(NSString *)url
                  method:(KJNetworkMethod)method
               parameter:(NSDictionary * _Nullable)parameter
          analyticObject:(NSString * _Nullable)analyticObject {
    return [self initURL:url
                  method:method
               parameter:parameter
 multipleAnalyticObjects: analyticObject != nil ? @{KJNetworkOriginObjectKey:analyticObject} : @{}];
}

+ (instancetype) initURL:(NSString *)url
                  method:(KJNetworkMethod)method
               parameter:(NSDictionary * _Nullable)parameter
 multipleAnalyticObjects:(NSDictionary * _Nullable)multipleAnalyticObjects {
    return [self initURL:url
                  method:method
               parameter:parameter
 multipleAnalyticObjects:multipleAnalyticObjects
                groupKey:url];
}

+ (instancetype) initURL:(NSString *)url
                  method:(KJNetworkMethod)method
               parameter:(NSDictionary * _Nullable)parameter
          analyticObject:(NSString * _Nullable)analyticObject
                groupKey:(NSString * _Nullable)groupKey {
    return [self initURL:url
                  method:method
               parameter:parameter
 multipleAnalyticObjects:analyticObject != nil ? @{KJNetworkOriginObjectKey:analyticObject} : @{}
                groupKey:groupKey];
}

+ (instancetype) initURL:(NSString *)url
                  method:(KJNetworkMethod)method
               parameter:(NSDictionary * _Nullable)parameter
 multipleAnalyticObjects:(NSDictionary * _Nullable)multipleAnalyticObjects
                groupKey:(NSString * _Nullable)groupKey {
    KJRequestItem *item = [KJRequestItem new];
    item.url = url;
    item.method = method;
    item.groupKey = groupKey;
    if (parameter != nil && parameter.count > 0) {
        [item.parameter addEntriesFromDictionary:parameter];
    }
    if (multipleAnalyticObjects != nil && multipleAnalyticObjects.count > 0) {
        [item.multipleAnalyticObjects addEntriesFromDictionary:multipleAnalyticObjects];
    }
    return item;
}

- (instancetype)init {
    if (self = [super init]) {
        self.method = GET;
        self.requestSerializer = [KJNetworkGlobalConfigs defaultConfigs].kjRequestSerializer;
        self.responseSerializer = [KJNetworkGlobalConfigs defaultConfigs].kjResponseSerializer;
        self.acceptableContentTypes = [KJNetworkGlobalConfigs defaultConfigs].kjAcceptableContentTypes;
        self.requestAdapter = [KJNetworkGlobalConfigs defaultConfigs].requestAdapter;
        self.analyticAdapter = [KJNetworkGlobalConfigs defaultConfigs].analyticAdapter;
    }
    return self;
}


- (NSString *)domain {
    if (!_domain) {
        // 给出默认域名
        _domain = [KJNetworkGlobalConfigs defaultConfigs].kjHost;
    }
    return _domain;
}

- (NSString *)dataKey {
    if (!_dataKey) {
        // 给出默认的dataKey
        _dataKey = [KJNetworkGlobalConfigs defaultConfigs].kjObjectKey;
    }
    return _dataKey;
}

- (NSMutableDictionary *)parameter {
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _parameter;
}

- (NSMutableDictionary *)header {
    if (!_header) {
        _header = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _header;
}

- (NSString *)groupKey {
    if (!_groupKey) {
        // 默认为url
        return _url;
    }
    return _groupKey;
}

- (NSMutableDictionary *)multipleAnalyticObjects {
    if (!_multipleAnalyticObjects) {
        _multipleAnalyticObjects = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _multipleAnalyticObjects;
}

- (void)setAnalyticObject:(NSString *)analyticObject {
    _analyticObject = analyticObject;
    [self.multipleAnalyticObjects setObject:self.analyticObject forKey:KJNetworkOriginObjectKey];
}

- (NSMutableArray<KJUploadModel *> *)fileArr {
    if (!_fileArr) {
        _fileArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _fileArr;
}

- (NSString *)baseModelName {
    if (!_baseModelName) {
        return [KJNetworkGlobalConfigs defaultConfigs].kjBaseModelName;
    }
    return _baseModelName;
}

/// 根据method获取对应的NSString
- (NSString *)requestMethod {
    switch (self.method) {
        case POST: return @"GET"; break;
        case PUT: return @"PUT"; break;
        case DELETE: return @"DELETE"; break;
        case HEAD: return @"HEAD"; break;
        case PATCH: return @"PATCH"; break;
        default: return @"GET"; break;
    }
}

@end
