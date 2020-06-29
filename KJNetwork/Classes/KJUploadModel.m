//
//  KJUploadModel.m
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import "KJUploadModel.h"

@implementation KJUploadModel

+ (instancetype)fileWithData:(NSData *)data
                    fileName:(NSString *)fileName
                        name:(NSString *)name
                    mimeType:(NSString *)mimeType {
    KJUploadModel *model = [KJUploadModel new];
    model.fileData = data;
    model.fileName = fileName;
    model.fileMimeType = mimeType;
    model.name = name;
    return model;
}

+ (instancetype)fileWithPath:(NSURL *)path
                    fileName:(NSString *)fileName
                        name:(NSString *)name
                    mimeType:(NSString *)mimeType {
    KJUploadModel *model = [KJUploadModel new];
    model.filePath = path;
    model.fileName = fileName;
    model.fileMimeType = mimeType;
    model.name = name;
    return model;
}

@end
