//
//  KJNetworkManager.h
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KJBaseModel.h"
#import "KJUploadModel.h"
#import <UIKit/UIKit.h>
#import "KJNetworkStruct.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^KJNetworkRequestHandle)(KJBaseModel *kjModel);

@interface KJNetworkManager : NSObject

/// 发送网络请求
/// @param request 网络请求设置
/// @param handle 请求结束回调
+ (instancetype)kjRequest:(nonnull void(^)(KJNetworkManager *manager))request
                 complete: (nullable KJNetworkRequestHandle)handle;

/// 初始化网络请求对象，不主动发送请求，需要主动调用sendRequest才会发送请求
/// @param request 设置
+ (instancetype)kjRequest:(nonnull void(^)(KJNetworkManager *manager))request;

/// 发送请求
- (void)sendRequest:(nullable KJNetworkRequestHandle)handle;


/// HOST 如果不设置该属性，会从全局属性里获取
- (KJNetworkManager * (^)(NSString *value))kjBaseURL;
/// URL
- (KJNetworkManager * (^)(NSString *value))kjURL;
/// 请求类型 默认GET
- (KJNetworkManager * (^)(KJNetworkMethod value))kjMethod;
/// 参数
- (KJNetworkManager * (^)(NSDictionary *value))kjParams;
/// Header
- (KJNetworkManager * (^)(NSDictionary *value))kjHeader;
/// 请求序列化 默认JSON
- (KJNetworkManager * (^)(KJNetworkSerializer value))kjRequestSerializer;
/// 结果序列化 默认JSON
- (KJNetworkManager * (^)(KJNetworkSerializer value))kjResponseSerializer;

/// 解析结果对象 用于解析成多个不同对象
- (KJNetworkManager * (^)(NSDictionary *value))kjMoreAnalyzer;
/// 解析结果对象 用于解析成一种对象
- (KJNetworkManager * (^)(NSString *value))kjAnalyzer;
/// 设置结果集在返回数据(responseObject)中的Key，如果业务方属性名有不同，需要设置，默认 data
- (KJNetworkManager * (^)(NSString *value))kjObjectKey;

/// 多个文件
- (KJNetworkManager * (^)(NSArray<KJUploadModel *> *value))kjMoreFile;
/// 单个文件
- (KJNetworkManager * (^)(KJUploadModel *value))kjOneFile;
/// 文件上传的进度
@property (nonatomic, copy) void (^ kjUploadProgressBlock)(NSProgress *kjProgress);



/**  这里说明一下kjMoreAnalyzer的用法
 
是一个字典
 
 比如服务器返下来的数据是：
 {
     "code": 200,        // 错误码
     "message": "成功",      // 错误信息
     "data": {
         "composition_material": {       // 素材入口信息
             "is_vip": 1,        // 是否属于VIP内容
             "pic_url": "http://img.zhugexuetang.com/Fnsp1SDPnkJxpO_LN1OD04X7QsxF",      // 图片
             "title": "写作素材",        // 类型
             "description": "会员专享单元写作素材"       // 名称
         },
         "article": {        // 美文信息
             "count": "2",       // 美文总数
             "page": "1",        // 当前页码
             "page_size": 5,     // 当前页应该请求数据的数量
             "list": [
                 {
                     "id": "2",      // 美文id
                     "type": "2",        // 美文类型 1-美文，2-朗读
                     "name": "愈2",      // 美文标题
                     "is_vip": "1",      // 是否属于VIP内容
                     "pic_url": "",      // 图片
                     "publish_datetime": "2020-06-08",       // 发布时间
                     "date_label": "6月8日",     // 时间标签，开发中发现该属性没用
                     "like_count": 5,        // 点赞数
                     "like_status": 2        // 点赞状态，0-无状态，未登陆情况，1-已点赞，2-未点赞（取消点赞）
                 }
             ]
         }
     }
 }
 
 当然啦，这个属性也只是针对data里的数据，也就是：
 "data": {
     "composition_material": {       // 素材入口信息
         "is_vip": 1,        // 是否属于VIP内容
         "pic_url": "http://img.zhugexuetang.com/Fnsp1SDPnkJxpO_LN1OD04X7QsxF",      // 图片
         "title": "写作素材",        // 类型
         "description": "会员专享单元写作素材"       // 名称
     },
     "article": {        // 美文信息
         "count": "2",       // 美文总数
         "page": "1",        // 当前页码
         "page_size": 5,     // 当前页应该请求数据的数量
         "list": [
             {
                 "id": "2",      // 美文id
                 "type": "2",        // 美文类型 1-美文，2-朗读
                 "name": "愈2",      // 美文标题
                 "is_vip": "1",      // 是否属于VIP内容
                 "pic_url": "",      // 图片
                 "publish_datetime": "2020-06-08",       // 发布时间
                 "date_label": "6月8日",     // 时间标签，开发中发现该属性没用
                 "like_count": 5,        // 点赞数
                 "like_status": 2        // 点赞状态，0-无状态，未登陆情况，1-已点赞，2-未点赞（取消点赞）
             }
         ]
     }
 }
 
 我想把这里面的数据解析成3个Model，我这样设置kjMoreAnalyzer
 
 manager.kjMoreAnalyzer(
    @{
        @"composition_material->material":  @"KJMaterialModel",
        @"article->number": @"KJNumberModel",   // 这里只需要除了list之外的所有数据
        @"article.list->article": @"KJArticleModel"     // 这里是解析data.article.list里的所有数据
    }
 )
 
 这样设置后，解析出来的结果就是
 baseModel.data = @[
    @{
        @"material": KJMaterialModel,
        @"number": KJNumberModel,
        @"article": @[KJArticleModel,KJArticleModel,KJArticleModel,KJArticleModel.........]
    }
 ]
 
 当然啦，也有返下来的数据对移动端来说没什么用，不需要解析出来，就直接不设置这个key即可
 
 */

@end

NS_ASSUME_NONNULL_END
