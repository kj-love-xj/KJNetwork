//
//  KJNetworkAdapter.m
//  KJNetwork_Example
//
//  Created by jin on 2021/12/29.
//  Copyright © 2021 jin. All rights reserved.
//

#import "KJAFNetworkAdapter.h"
#import "AFNetworking/AFNetworking.h"
#import "KJNetworkGlobalConfigs.h"
#import "MJExtension/MJExtension.h"
#import "KJRequestItem.h"

@interface KJAFNetworkAdapter ()

@property (nonatomic, copy) void (^ finish) (KJRequestItem *item, NSDictionary *response, NSError *error);

@end

@implementation KJAFNetworkAdapter

- (void)request:(KJRequestItem *)item
         finish:(void(^)(KJRequestItem *item,
                         NSDictionary *response,
                         NSError *error))finishBlock {
    self.finish = finishBlock;
    // 处理网络请求
    // 域名
    NSString *domain = item.domain;
    // 判断后缀 域名是不是以'/'结尾
    if (![domain hasSuffix:@"/"]) {
        // 给域名后面添加'/'结尾
        domain = [NSString stringWithFormat:@"%@/", domain];
    }
    // 初始化AFHTTPSessionManager，指定BaseURL
    AFHTTPSessionManager *http = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:domain]];
    // request
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if (item.requestSerializer == JSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = [KJNetworkGlobalConfigs defaultConfigs].timeout;
    http.requestSerializer = requestSerializer;
    
    // response
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    if (item.responseSerializer == HTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = item.acceptableContentTypes;
    http.responseSerializer = responseSerializer;
    // url
    NSString *url = item.url;
    // 判断前缀 url是不是以'/'开头
    if ([url hasPrefix:@"/"]) {
        // 需要删除前缀'/'
        url = [url substringFromIndex:1];
    }

    // 开始请求
    if (item.fileArr.count > 0) {
        // 上传文件
        [self upload:url item:item http:http];
    } else {
        // 发送网络请求
        [self send:url item:item http:http];
    }
}

/// 发送网络请求
/// @param url URL
/// @param item RequestItem
/// @param http AFN
- (void)send:(NSString *)url
        item:(KJRequestItem *)item
        http:(AFHTTPSessionManager *)http {
    // 处理参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:[KJNetworkGlobalConfigs defaultConfigs].kjParams];
    [parameter addEntriesFromDictionary:item.parameter];
    // 处理Header
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:[KJNetworkGlobalConfigs defaultConfigs].kjHeader];
    [header addEntriesFromDictionary:item.header];
    
    [[http dataTaskWithHTTPMethod:[item requestMethod]
                           URLString:url
                          parameters:parameter
                             headers:header
                      uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            // 上传进度
            if (item.uploadHandle != nil) {
                item.uploadHandle(item, uploadProgress);
            }
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            // 下载进度
            if (item.downloadHandle != nil) {
                item.downloadHandle(item, downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功的处理
            [self success:task responseObject:responseObject item:item];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 失败的处理
            [self failure:task error:error item:item];
        }] resume];
}

/// 上传文件
/// @param url URL
/// @param item RequestItem
/// @param http AFN
- (void)upload:(NSString *)url
          item:(KJRequestItem *)item
          http:(AFHTTPSessionManager *)http {
    [http POST:url
    parameters:item.parameter
       headers:item.header
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (KJUploadModel *model in item.fileArr) {
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
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (item.uploadHandle != nil) {
            item.uploadHandle(item, uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功的处理
        [self success:task responseObject:responseObject item:item];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败的处理
        [self failure:task error:error item:item];
    }];
}


/// 成功的处理
/// @param task NSURLSessionDataTask
/// @param obj 请求结果
/// @param item RequestItem
- (void)success:(NSURLSessionDataTask *)task
 responseObject:(id)obj
           item:(KJRequestItem *)item {
    if (self.finish != nil) {
        self.finish(item, obj, nil);
    }
#ifdef DEBUG
    NSLog(@"\n\n✅✅✅✅✅--Start\n%@\n-🌹 Response:\n%@\n✅✅✅✅✅--End\n", [self requestDescription:task item:item], [obj mj_JSONString]);
#endif
    [task cancel];
}

/// 失败的处理
/// @param task NSURLSessionDataTask
/// @param err 错误信息
/// @param item RequestItem
- (void)failure:(NSURLSessionDataTask *)task
          error:(NSError *)err
           item:(KJRequestItem *)item {
    if (self.finish != nil) {
        self.finish(item, nil, err);
    }
#ifdef DEBUG
    NSLog(@"\n\n❌❌❌❌❌--Start\n%@\n-🌹 Error:\ncode=%ld,message=%@\n❌❌❌❌❌--End\n", [self requestDescription:task item:item], (long)err.code, err.localizedDescription);
#endif
    [task cancel];
}

- (NSString *)requestDescription:(NSURLSessionDataTask *)task item: (KJRequestItem *)item {
    NSURLRequest *request = task.currentRequest;
    return [NSString stringWithFormat:@"-🌹 Domain:%@\n-🌹 Url:%@\n-🌹 Path:%@\n-🌹 Method:%@\n-🌹 Params:\n[item]:%@\n[global]:%@\n-🌹 Header:\n[all]:%@\n[item]:%@\n[global]:%@", item.domain, item.url, request.URL, request.HTTPMethod, item.parameter.mj_JSONString, [KJNetworkGlobalConfigs defaultConfigs].kjParams.mj_JSONString, request.allHTTPHeaderFields.mj_JSONString, item.header.mj_JSONString, [KJNetworkGlobalConfigs defaultConfigs].kjHeader.mj_JSONString];
    
}

@end
