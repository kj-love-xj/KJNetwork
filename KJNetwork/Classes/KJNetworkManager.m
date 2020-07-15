//
//  KJNetworkManager.m
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import "KJNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KJNetworkGlobalConfigs.h"

@interface KJNetworkManager ()

/// HOST
@property (nonatomic, copy) NSString *kj_BaseURL;
/// URL
@property (nonatomic, copy) NSString *kj_URL;
/// 参数
@property (nonatomic, strong) NSMutableDictionary *kj_Params;
/// Header
@property (nonatomic, strong) NSMutableDictionary *kj_Header;
/// 请求序列化
@property (nonatomic, assign) KJNetworkSerializer kj_RequestSerializer;
/// 结果序列化
@property (nonatomic, assign) KJNetworkSerializer kj_ResponseSerializer;
/// 请求类型
@property (nonatomic, assign) KJNetworkMethod kj_Method;
/// 解析
@property (nonatomic, strong) NSMutableDictionary *kj_Analyzer;
/// 文件
@property (nonatomic, strong) NSMutableArray *kj_Data;
/// 回调
@property (nonatomic, copy) KJNetworkRequestHandle completeBlock;
/// 请求对象
@property (nonatomic, strong) NSURLSessionDataTask *task;
/// 需要解析的结果集Key
@property (nonatomic, copy) NSString *kj_ObjectKey;


@end

@implementation KJNetworkManager

#pragma mark - 初始化

/// 发送网络请求
/// @param request 网络请求设置
/// @param handle 请求结束回调
+ (instancetype)kjRequest:(nonnull void(^)(KJNetworkManager *manager))request
                 complete: (nullable KJNetworkRequestHandle)handle {
    KJNetworkManager *manager = [self kjRequest:request];
    [manager sendRequest:handle];
    return manager;
}

/// 初始化网络请求对象，不主动发送请求，需要主动调用sendRequest才会发送请求
/// @param request 设置
+ (instancetype)kjRequest:(nonnull void(^)(KJNetworkManager *manager))request {
    KJNetworkManager *manager = [[KJNetworkManager alloc] init];
    manager.kj_Method = GET; // 默认GET
    manager.kj_ObjectKey = [KJNetworkGlobalConfigs defaultConfigs].kjObjectKey;
    manager.kj_ResponseSerializer = [KJNetworkGlobalConfigs defaultConfigs].kjResponseSerializer;
    manager.kj_RequestSerializer = [KJNetworkGlobalConfigs defaultConfigs].kjRequestSerializer;
    request(manager);
    return manager;
}

/// 发送请求
- (void)sendRequest:(nullable KJNetworkRequestHandle)handle{
    self.completeBlock = handle;
    if (self.kj_Data.count > 0) {
        // 有文件需要上传
        [self uploadRequest];
    } else {
        switch (self.kj_Method) {
            case GET:
                [self getRequest];
                break;
                
            case POST:
                [self postRequest];
                break;
                
            case PUT:
                [self putRequest];
                break;
                
            case DELETE:
                [self deleteRequest];
                break;
                
            default:
                NSLog(@"KJNetworkManager：请新增请求类型");
                break;
        }
    }
}


#pragma mark - request

// 请求超时
static NSTimeInterval const REQUEST_TIMEOUT = 60.0;

/// 设置 AFHTTPSessionManager
- (AFHTTPSessionManager *)httpManager {
    AFHTTPSessionManager *http = [AFHTTPSessionManager manager];
    
    // request
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if (self.kj_RequestSerializer == JSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    http.requestSerializer = requestSerializer;
    
    // response
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    if (self.kj_ResponseSerializer == HTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    NSSet *set = [[NSSet alloc]initWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html", nil];
    responseSerializer.acceptableContentTypes = set;
    http.responseSerializer = responseSerializer;
    
    return http;
}

/// GET
- (void)getRequest {
    self.task = [[self httpManager] GET:[self.kj_BaseURL stringByAppendingPathComponent:self.kj_URL]
                             parameters:self.kj_Params
                                headers:self.kj_Header
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task,
                                          id  _Nullable responseObject) {
        [self handleRequestSucceed:responseObject];
    }
                                failure:^(NSURLSessionDataTask * _Nullable task,
                                          NSError * _Nonnull error) {
        [self handleRequestFailure:error];
    }];
}

/// POST
- (void)postRequest {
    self.task = [[self httpManager] POST:[self.kj_BaseURL stringByAppendingPathComponent:self.kj_URL]
                              parameters:self.kj_Params
                                 headers:self.kj_Header
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task,
                                           id  _Nullable responseObject) {
        [self handleRequestSucceed:responseObject];
    }
                                 failure:^(NSURLSessionDataTask * _Nullable task,
                                           NSError * _Nonnull error) {
        [self handleRequestFailure:error];
    }];
}

/// PUT
- (void)putRequest {
    self.task = [[self httpManager] PUT:[self.kj_BaseURL stringByAppendingPathComponent:self.kj_URL]
                             parameters:self.kj_Params
                                headers:self.kj_Header
                                success:^(NSURLSessionDataTask * _Nonnull task,
                                          id  _Nullable responseObject) {
        [self handleRequestSucceed:responseObject];
    }
                                failure:^(NSURLSessionDataTask * _Nullable task,
                                          NSError * _Nonnull error) {
        [self handleRequestFailure:error];
    }];
}

/// DELETE
- (void)deleteRequest {
    self.task = [[self httpManager] DELETE:[self.kj_BaseURL stringByAppendingPathComponent:self.kj_URL]
                                parameters:self.kj_Params
                                   headers:self.kj_Header
                                   success:^(NSURLSessionDataTask * _Nonnull task,
                                             id  _Nullable responseObject) {
        [self handleRequestSucceed:responseObject];
    }
                                   failure:^(NSURLSessionDataTask * _Nullable task,
                                             NSError * _Nonnull error) {
        [self handleRequestFailure:error];
    }];
}

/// UPLOAD
- (void)uploadRequest {
    self.task = [[self httpManager] POST:[self.kj_BaseURL stringByAppendingPathComponent:self.kj_URL]
                              parameters:self.kj_Params
                                 headers:self.kj_Header
               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (KJUploadModel *model in self.kj_Data) {
            if (model.filePath != nil) {
                if (model.fileName == nil || model.fileMimeType == nil) {
                    [formData appendPartWithFileURL:model.filePath
                                               name:model.name
                                              error:nil];
                } else {
                    [formData appendPartWithFileURL:model.filePath
                                               name:model.name
                                           fileName:model.fileName
                                           mimeType:model.fileMimeType
                                              error:nil];
                }
                continue;
            }
            
            if (model.fileData != nil) {
                if (model.fileName == nil || model.fileMimeType == nil) {
                    [formData appendPartWithFormData:model.fileData
                                                name:model.name];
                } else {
                    [formData appendPartWithFileData:model.fileData
                                                name:model.name
                                            fileName:model.fileName
                                            mimeType:model.fileMimeType];
                }
                continue;
            }
            
            NSLog(@"KJNetworkManager：无效文件，请设置 filePath 或 fileData");
        }
    }
                                progress:self.kjUploadProgressBlock
                                 success:^(NSURLSessionDataTask * _Nonnull task,
                                           id  _Nullable responseObject) {
        [self handleRequestSucceed:responseObject];
    }
                                 failure:^(NSURLSessionDataTask * _Nullable task,
                                           NSError * _Nonnull error) {
        [self handleRequestFailure:error];
    }];
}

/// 失败的处理
- (void)handleRequestFailure:(NSError *)error {
    KJBaseModel *baseModel = [[KJBaseModel alloc] init];
    baseModel.code = error.code;
    baseModel.message = error.localizedDescription;
    baseModel.requestUrl = self.kj_URL;
    baseModel.data = @[];
    self.completeBlock(baseModel);
}

/// 成功的回调
- (void)handleRequestSucceed:(id)responseObject {
    // 当外部不需要这些数据来做业务处理，那么这里就可以不做解析流程
    if (self.completeBlock == nil) { return; }
    // 下面开始处理服务端返下来的结果
    KJBaseModel *baseModel = [KJBaseModel mj_objectWithKeyValues:responseObject];
    baseModel.responseObject = responseObject;
    baseModel.requestUrl = self.kj_URL;
    id data = responseObject[self.kj_ObjectKey];
    BOOL isArray = [data isKindOfClass:NSArray.class] && [(NSArray *)data count] > 0;
    BOOL isDictionary = [data isKindOfClass:NSDictionary.class] && [(NSDictionary *)data count] > 0;
    // 解析
    if (data != nil && (isArray || isDictionary)) {
        if (self.kj_Analyzer.count > 0) {
            NSArray *keys = self.kj_Analyzer.allKeys;
            if (isDictionary) {
                NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
                for (NSString *key in keys) {
                    // 把解析完后的key名 和 需要解析的数据在data中的位置name 区分开，分隔符是"->"
                    NSArray *names = [key componentsSeparatedByString:@"->"];
                    NSString *laterName = names.lastObject;
                    // 找到对应的数据
                    id origin = [self findData:data names:[names.firstObject componentsSeparatedByString:@"."]];
                    // 解析成对应的类型
                    id parsing_data = [self data:origin className:self.kj_Analyzer[key]];
                    if (parsing_data != nil) {
                        [result setObject:parsing_data forKey:laterName];
                    }
                }
                if (result.count == 1) {
                    // 当解析完后就只有一个数据，那么，baseModel中的data就是这个数据
                    id object = result.allValues.firstObject;
                    if ([object isKindOfClass:NSArray.class]) {
                        baseModel.data = (NSArray *)object;
                    } else {
                        baseModel.data = @[object];
                    }
                } else {
                    baseModel.data = @[result];
                }
            } else  {
                // 在这种情况下，理论上只有一个解析对象
                NSString *name = self.kj_Analyzer[keys.firstObject];
                id object = [self data:data className:name];
                if ([object isKindOfClass:NSArray.class]) {
                    baseModel.data = (NSArray *)object;
                } else {
                    baseModel.data = @[object];
                }
            }
        } else {
            if ([data isKindOfClass:NSArray.class]) {
                baseModel.data = (NSArray *)data;
            } else {
                baseModel.data = @[data];
            }
        }
    } else {
        baseModel.data = @[];
    }
    // 回调
    self.completeBlock(baseModel);
    
#ifdef DEBUG
    // 移除全局参数
    if ([KJNetworkGlobalConfigs defaultConfigs].kjParams.count > 0) {
        [self.kj_Params removeObjectsForKeys:[KJNetworkGlobalConfigs defaultConfigs].kjParams.allKeys];
    }
    // 移除全局Header
    if ([KJNetworkGlobalConfigs defaultConfigs].kjHeader.count > 0) {
        [self.kj_Header removeObjectsForKeys:[KJNetworkGlobalConfigs defaultConfigs].kjHeader.allKeys];
    }
    // 打印
    NSLog(@"\n\nSTART\n\n----------\n\nHOST:%@\nURL:%@\nparams:%@\nglobal(params):%@\nglobal(header):%@\nresponse:%@\n\n----------\n\nEND\n",
          self.kj_BaseURL,
          self.kj_URL,
          self.kj_Params.mj_JSONString,
          [KJNetworkGlobalConfigs defaultConfigs].kjParams.mj_JSONString,
          [KJNetworkGlobalConfigs defaultConfigs].kjHeader.mj_JSONString,
          ((NSDictionary *)responseObject).mj_JSONString);
#endif
}

/// 把数据解析成指定的类
/// @param data 数据
/// @param className 类名
- (id)data:(id)data className:(NSString *)className {
    Class object = NSClassFromString(className);
    if (object != nil) {
        if ([data isKindOfClass:NSDictionary.class]) {
            return [object mj_objectWithKeyValues:data];
        } else if ([data isKindOfClass:NSArray.class]) {
            return [object mj_objectArrayWithKeyValuesArray:data];
        }
    }
    return data;
}

/// 根据外部设置的在data内的路径找到相对应的数据
/// @param data 网络请求下来的data中的数据
/// @param names 外部指定的key路径
- (nullable id)findData:(NSDictionary *)data names:(NSArray<NSString *> *)names {
    if (names.count == 1 && [names.firstObject isEqualToString:@"KJORIGINDATA"]) {
        return data;
    }
    NSDictionary * origin = [NSDictionary dictionaryWithDictionary:data];
    if ([data isKindOfClass:NSDictionary.class]) {
        for (int i = 0; i < names.count; i ++) {
            NSDictionary *next = origin[names[i]];
            if (i == names.count - 1) {
                return next;
            } else {
                origin = next;
            }
        }
    }
    return nil;
}


#pragma mark - confi

/// HOST 如果不设置该属性，会从全局属性里获取
- (KJNetworkManager * (^)(NSString *value))kjBaseURL {
    return ^id(NSString *baseURL) {
        self.kj_BaseURL = baseURL;
        return self;
    };
}

/// URL
- (KJNetworkManager * (^)(NSString *value))kjURL {
    return ^id(NSString *URL){
        self.kj_URL = URL;
        return self;
    };
}

/// 请求类型
- (KJNetworkManager * (^)(KJNetworkMethod value))kjMethod {
    return ^id(KJNetworkMethod method) {
        self.kj_Method = method;
        return self;
    };
}

/// 参数
- (KJNetworkManager * (^)(NSDictionary *value))kjParams {
    return ^id(NSDictionary *params){
        [self.kj_Params addEntriesFromDictionary:params];
        return self;
    };
}

/// Header
- (KJNetworkManager * (^)(NSDictionary *value))kjHeader {
    return ^id(NSDictionary *header) {
        [self.kj_Header addEntriesFromDictionary:header];
        return self;
    };
}

/// 请求序列化
- (KJNetworkManager * (^)(KJNetworkSerializer value))kjRequestSerializer {
    return ^id(KJNetworkSerializer serializer){
        self.kj_RequestSerializer = serializer;
        return self;
    };
}

/// 结果序列化 默认JSON
- (KJNetworkManager * (^)(KJNetworkSerializer value))kjResponseSerializer {
    return ^id(KJNetworkSerializer serializer){
        self.kj_ResponseSerializer = serializer;
        return self;
    };
}

/// 解析结果对象 用于解析成多个对象
- (KJNetworkManager * (^)(NSDictionary *value))kjMoreAnalyzer {
    return ^id(NSDictionary *analyzer) {
        [self.kj_Analyzer addEntriesFromDictionary:analyzer];
        return self;
    };
}

/// 解析结果对象
- (KJNetworkManager * (^)(NSString *value))kjAnalyzer {
    return ^id(NSString *analyzer) {
        [self.kj_Analyzer setValue:analyzer forKey:@"KJORIGINDATA"];
        return self;
    };
}

/// 设置结果集在返回数据(responseObject)中的Key，如果业务方属性名有不同，需要设置，默认 data
- (KJNetworkManager * (^)(NSString *value))kjObjectKey {
    return ^id(NSString *key) {
        self.kj_ObjectKey = key;
        return self;
    };
}

/// 多个文件
- (KJNetworkManager * (^)(NSArray<KJUploadModel *> *value))kjMoreFile {
    return ^id(NSArray<KJUploadModel *> *file) {
        [self.kj_Data addObjectsFromArray:file];
        return self;
    };
}

/// 单个文件
- (KJNetworkManager * (^)(KJUploadModel *value))kjOneFile {
    return ^id(KJUploadModel *file) {
        [self.kj_Data addObject:file];
        return self;
    };
}


#pragma mark - lazzy

- (NSMutableDictionary *)kj_Params {
    if (!_kj_Params) {
        _kj_Params = [NSMutableDictionary dictionaryWithDictionary:[KJNetworkGlobalConfigs defaultConfigs].kjParams];
    }
    return _kj_Params;
}

- (NSMutableDictionary *)kj_Header {
    if (!_kj_Header) {
        _kj_Header = [NSMutableDictionary dictionaryWithDictionary:[KJNetworkGlobalConfigs defaultConfigs].kjHeader];
    }
    return _kj_Header;
}

- (NSString *)kj_BaseURL {
    if (!_kj_BaseURL) {
        _kj_BaseURL = [KJNetworkGlobalConfigs defaultConfigs].kjHost;
    }
    return _kj_BaseURL;
}

- (NSMutableDictionary *)kj_Analyzer {
    if (!_kj_Analyzer) {
        _kj_Analyzer = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _kj_Analyzer;
}

- (NSMutableArray *)kj_Data {
    if (!_kj_Data) {
        _kj_Data = [NSMutableArray arrayWithCapacity:0];
    }
    return _kj_Data;
}

@end
