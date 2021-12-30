//
//  KJMJAnalyticAdapter.m
//  KJNetwork_Example
//
//  Created by jin on 2021/12/29.
//  Copyright © 2021 jin. All rights reserved.
//

#import "KJMJAnalyticAdapter.h"
#import "MJExtension/MJExtension.h"
#import "KJRequestItem.h"
#import "KJBaseModel.h"

@implementation KJMJAnalyticAdapter

- (void)analytic:(NSDictionary *)responseObject
            item:(KJRequestItem *)item
             err:(NSError *)error
          finish:(void(^)(KJBaseModel *baseModel, KJRequestItem *item))finishBlock {
    if (finishBlock == nil) {
        return;
    }
    if (error != nil) {
        // 请求失败的处理
        KJBaseModel *baseModel = [[NSClassFromString(item.baseModelName) alloc] init];
        baseModel.message = error.localizedDescription;
        baseModel.code = error.code;
        baseModel.data = @[];
        finishBlock(baseModel, item);
    } else {
        // 请求成功的处理
        KJBaseModel *baseModel = [NSClassFromString(item.baseModelName) mj_objectWithKeyValues:responseObject];
        baseModel.data = @[];
        // data数据
        id responseData = responseObject[item.dataKey];
        // 判断数据类型
        BOOL isArray = [responseData isKindOfClass:NSArray.class] && [(NSArray *)responseData count] > 0;
        BOOL isDictionary = [responseData isKindOfClass:NSDictionary.class] && [(NSDictionary *)responseData count] > 0;
        // 符合的数据类型进行解析
        if ((isArray || isDictionary) && item.multipleAnalyticObjects.count > 0) {
            // 解析后的数据
            NSMutableDictionary *analyticResult = [NSMutableDictionary dictionaryWithCapacity:0];
            // 获取需要查询到数据类型
            NSArray *multipleAnalyticKyes = item.multipleAnalyticObjects.allKeys;
            // 循环解析
            for(NSString *key in multipleAnalyticKyes) {
                // 获取重命名和对应的key
                NSArray * analyticKye = [key componentsSeparatedByString:@"->"];
                // 找到对应的数据
                id obj = [self find:responseData keys:[analyticKye.firstObject componentsSeparatedByString:@"."]];
                // 解析成设置的Model
                if ([obj isKindOfClass:NSArray.class]) {
                    NSArray *modelArr = [NSClassFromString(item.multipleAnalyticObjects[key]) mj_objectArrayWithKeyValuesArray:obj];
                    if (modelArr.count > 0) {
                        [analyticResult setObject:modelArr forKey:analyticKye.lastObject];
                    }
                } else if ([obj isKindOfClass:NSDictionary.class]) {
                    id model = [NSClassFromString(item.multipleAnalyticObjects[key]) mj_objectWithKeyValues:obj];
                    if (model != nil) {
                        [analyticResult setObject:model forKey:analyticKye.lastObject];
                    }
                }
            }
            // 处理解析完后的数据
            if (analyticResult.count > 0) {
                if (analyticResult.count == 0) {
                    id object = analyticResult.allValues.firstObject;
                    if ([object isKindOfClass:NSArray.class]) {
                        baseModel.data = (NSArray *)object;
                    } else {
                        baseModel.data = @[object];
                    }
                } else {
                    baseModel.data = @[analyticResult];
                }
            }
        } else {
            if (responseData != nil) {
                // 没办法解析的数据，直接放入data中
                if (isArray) {
                    baseModel.data = responseData;
                } else {
                    baseModel.data = @[responseData];
                }
            }
        }
        finishBlock(baseModel, item);
    }
}

- (id)find:(id)data keys:(NSArray <NSString *> *)keys {
    if (keys.count <= 0 || (keys.count == 1 && [keys.firstObject isEqualToString:KJNetworkOriginObjectKey])) {
        return data;
    }
    BOOL isArray = [data isKindOfClass:NSArray.class] && [(NSArray *)data count] > 0;
    BOOL isDictionary = [data isKindOfClass:NSDictionary.class] && [(NSDictionary *)data count] > 0;
    if (isArray || isDictionary) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:keys];
        id obj;
        if (isArray) {
            NSInteger index = [keys.firstObject integerValue];
            if (index >= 0 && index <= ((NSArray *)data).count) {
                obj =  ((NSArray *)data)[index];
            }
        } else {
            obj = data[keys.firstObject];
        }
        
        if (obj != nil) {
            [arr removeObjectAtIndex:0];
            return [self find:obj keys:arr];
        }
    }
    return data;
}

@end
