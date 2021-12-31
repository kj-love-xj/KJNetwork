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

- (KJRequestStringValueHandle)kjDomain {
    return ^id (NSString *value) {
        return [self kjDomain:value];
    };
}

- (KJRequestItem *)kjDomain:(NSString *)domain {
    self.domain = domain;
    return self;
}

- (KJRequestStringValueHandle)kjUrl {
    return ^id (NSString * value) {
        return [self kjUrl:value];
    };
}

- (KJRequestItem *)kjUrl:(NSString *)url {
    self.url = url;
    return self;
}

+ (KJRequestStringValueHandle)kjUrl {
    return ^id (NSString * value) {
        return [self kjUrl:value];
    };
}

+ (KJRequestItem *)kjUrl:(NSString *)url {
    KJRequestItem *item = [[KJRequestItem alloc] init];
    item.url = url;
    return item;
}

- (KJRequestDictionaryValueHandle)kjParameter {
    return ^id (NSDictionary *value) {
        return [self kjParameter: value];
    };
}

- (KJRequestItem *)kjParameter:(NSDictionary *)parameter {
    if (parameter.count > 0) {
        [self.parameter addEntriesFromDictionary:parameter];
    }
    return self;
}

- (KJRequestDictionaryValueHandle)kjHeader {
    return ^id (NSDictionary *value) {
        return [self kjHeader:value];
    };
}

- (KJRequestItem *)kjHeader:(NSDictionary *)header {
    if (header.count > 0) {
        [self.header addEntriesFromDictionary:header];
    }
    return self;
}

- (KJRequestItem * (^)(KJNetworkMethod value))kjMethod {
    return ^id (KJNetworkMethod value) {
        return [self kjMethod:value];
    };
}

- (KJRequestItem *)kjMethod:(KJNetworkMethod)method {
    self.method = method;
    return self;
}

- (KJRequestStringValueHandle)kjDataKey {
    return ^id (NSString *value) {
        return [self kjDataKey:value];
    };
}

- (KJRequestItem *)kjDataKey:(NSString *)dataKey {
    self.dataKey = dataKey;
    return self;
}

- (KJRequestDictionaryValueHandle)kjMultipleAnalyticObjects {
    return ^id (NSDictionary *value) {
        return [self kjMultipleAnalyticObjects:value];
    };
}

- (KJRequestItem *)kjMultipleAnalyticObjects:(NSDictionary *)multipleAnalyticObjects {
    if (multipleAnalyticObjects.count > 0) {
        [self.multipleAnalyticObjects addEntriesFromDictionary:multipleAnalyticObjects];
    }
    return self;
}

- (KJRequestStringValueHandle)kjAnalyticObject {
    return ^id (NSString *value) {
        return [self kjAnalyticObject:value];
    };
}

- (KJRequestItem *)kjAnalyticObject:(NSString *)analyticObject {
    self.analyticObject = analyticObject;
    return self;
}

- (KJRequestStringValueHandle)kjGroupKey {
    return ^id (NSString *value) {
        return [self kjGroupKey:value];
    };
}

- (KJRequestItem *)kjGroupKey:(NSString *)groupKey {
    self.groupKey = groupKey;
    return self;
}

- (KJRequestItem * (^)(KJRequestItemInterceptHandle value))kjInterceptHandle {
    return ^id (KJRequestItemInterceptHandle value) {
        return [self kjInterceptHandle:value];
    };
}

- (KJRequestItem *)kjInterceptHandle:(KJRequestItemInterceptHandle)interceptHandle {
    self.interceptHandle = interceptHandle;
    return self;
}

- (KJRequestStringValueHandle)kjBaseModelName {
    return ^id (NSString *value) {
        return [self kjBaseModelName:value];
    };
}

- (KJRequestItem *)kjBaseModelName:(NSString *)baseModelName {
    self.baseModelName = baseModelName;
    return self;
}

- (KJRequestItem * (^)(NSArray<KJUploadModel *> *value))kjFileArr {
    return ^id (NSArray<KJUploadModel *> *value) {
        return [self kjFileArr:value];
    };
}

- (KJRequestItem *)kjFileArr:(NSArray <KJUploadModel *> *)fileArr {
    if (fileArr.count > 0) {
        [self.fileArr addObjectsFromArray:fileArr];
    }
    return self;
}

- (KJRequestItem * (^)(KJNetworkSerializer value))kjRequestSerializer {
    return ^id (KJNetworkSerializer value) {
        return [self kjRequestSerializer:value];
    };
}

- (KJRequestItem *)kjRequestSerializer:(KJNetworkSerializer)requestSerializer {
    self.requestSerializer = requestSerializer;
    return self;
}

- (KJRequestItem * (^)(KJNetworkSerializer value))kjResponseSerializer {
    return ^id (KJNetworkSerializer value) {
        return [self kjResponseSerializer: value];
    };
}

- (KJRequestItem *)kjResponseSerializer:(KJNetworkSerializer)responseSerializer {
    self.responseSerializer = responseSerializer;
    return self;
}

- (KJRequestItem * (^)(NSSet <NSString *> *value))kjAcceptableContentTypes {
    return ^id (NSSet <NSString *> *value) {
        return [self kjAcceptableContentTypes: value];
    };
}

- (KJRequestItem *)kjAcceptableContentTypes:(NSSet <NSString *> *)acceptableContentTypes {
    self.acceptableContentTypes = acceptableContentTypes;
    return self;
}

- (KJRequestStringValueHandle)kjRequestAdapter {
    return ^id (NSString *value) {
        return [self kjRequestAdapter: value];
    };
}

- (KJRequestItem *)kjRequestAdapter:(NSString *)requestAdapter {
    self.requestAdapter = requestAdapter;
    return self;
}

- (KJRequestStringValueHandle)kjAnalyticAdapter {
    return ^id (NSString *value) {
        return [self kjAnalyticAdapter: value];
    };
}

- (KJRequestItem *)kjAnalyticAdapter:(NSString *)analyticAdapter {
    self.analyticAdapter = analyticAdapter;
    return self;
}

- (KJRequestItem * (^)(KJRequestProgressHandle value))kjUploadHandle {
    return ^id (KJRequestProgressHandle value) {
        return [self kjUploadHandle: value];
    };
}

- (KJRequestItem *)kjUploadHandle:(KJRequestProgressHandle)uploadHandle {
    self.uploadHandle = uploadHandle;
    return self;
}

- (KJRequestItem * (^)(KJRequestProgressHandle value))kjDownloadHandle {
    return ^id (KJRequestProgressHandle value) {
        return [self kjDownloadHandle: value];
    };
}

- (KJRequestItem *)kjDownloadHandle:(KJRequestProgressHandle)downloadHandle {
    self.downloadHandle = downloadHandle;
    return self;
}


@end
