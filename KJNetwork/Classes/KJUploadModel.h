//
//  KJUploadModel.h
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJUploadModel : NSObject

/// 文件数据
@property (nonatomic, copy) NSData *fileData;
/// 文件路径(本地路径)
@property (nonatomic, copy) NSURL *filePath;
/// 文件名称 如果不设置内部会自动生成
@property (nonatomic, copy, nullable) NSString *fileName;
/// 数据关联的名称
@property (nonatomic, copy) NSString *name;
/// 文件类型  具体类型和查看 - (http://www.iana.org/assignments/media-types/media-types.xhtml)
@property (nonatomic, copy, nullable) NSString *fileMimeType;

+ (instancetype)fileWithData:(NSData *)data
                    fileName:(NSString * _Nullable)fileName
                        name:(NSString *)name
                    mimeType:(NSString * _Nullable)mimeType;

+ (instancetype)fileWithPath:(NSURL *)path
                    fileName:(NSString * _Nullable)fileName
                        name:(NSString *)name
                    mimeType:(NSString * _Nullable)mimeType;


@end

NS_ASSUME_NONNULL_END
