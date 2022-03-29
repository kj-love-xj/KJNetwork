# KJNetwork

[![CI Status](https://img.shields.io/travis/jin/KJNetwork.svg?style=flat)](https://travis-ci.org/jin/KJNetwork)
[![Version](https://img.shields.io/cocoapods/v/KJNetwork.svg?style=flat)](https://cocoapods.org/pods/KJNetwork)
[![License](https://img.shields.io/cocoapods/l/KJNetwork.svg?style=flat)](https://cocoapods.org/pods/KJNetwork)
[![Platform](https://img.shields.io/cocoapods/p/KJNetwork.svg?style=flat)](https://cocoapods.org/pods/KJNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### 多个网络请求的处理

```
NSMutableArray *data = [NSMutableArray array];
    KJRequestManager
    // 文章列表
        .item(KJRequestItem.kjUrl(XSSearchWritingListUrl)
              .kjDomain(FinancialBaseUrl)
              .kjParameter(@{@"pageNo": [NSString stringWithFormat:@"%ld",self.pageNo],@"pageSize":[NSString stringWithFormat:@"%d",PageTotalCount],@"queryType":@0})
              .kjGroupKey(@"writingList")
              .kjMethod(POST)
              .kjMultipleAnalyticObjects(@{@"data":@"XSWritingList"})) // 解析data里面的data数据
    
    // 学者
        .item(KJRequestItem.kjUrl(XSWritingHotAuthorUrl)
              .kjDomain(FinancialBaseUrl)
              .kjMethod(POST)
              .kjGroupKey(@"writingAuthor")
              .kjMultipleAnalyticObjects(@{@"data":@"DKRecommendAuth"})) // 解析datas里面的data数据
    // 最新文章
        .item(KJRequestItem.kjUrl(XSWritingLatestEssayUrl)
              .kjDomain(FinancialBaseUrl)
              .kjMethod(POST)
              .kjParameter(@{@"articleId":@""})
              .kjGroupKey(@"newWriting")
              .kjDataKey(@"data") // 由于全局配置那里设置的是datas，所以这里需要覆盖设置成data
              .kjAnalyticObject(@"XSWritingList"))
    // 最热文章
        .item(KJRequestItem.kjUrl(XSWritingHotEssayUrl)
              .kjDomain(FinancialBaseUrl)
              .kjMethod(POST)
              .kjParameter(@{@"articleId":@""})
              .kjGroupKey(@"hotWriting")
              .kjMultipleAnalyticObjects(@{@"data":@"XSWritingList"}) // 解析data里面的data数据
              .kjDataKey(@"data")) // 由于全局配置那里设置的是datas，所以这里需要覆盖设置成data
    // 请求结果
        .request(^(NSDictionary *kjResult){
            KJBaseModel *kjmodel0 = kjResult[@"writingList"]; //文章列表
            if (kjmodel0.code == 1) {
                XSCustomSectionModel *model3 = [[XSCustomSectionModel alloc]init];
                model3.pname = @"writingList";
                model3.title = @"文章";
                model3.dataArray = kjmodel0.data;
                [data addObject:model3];
            }
            KJBaseModel *kjmodel1 = kjResult[@"writingAuthor"]; //作者
            if (kjmodel1.code == 1 && kjmodel1.data.count > 0) {
                XSCustomSectionModel *model3 = [[XSCustomSectionModel alloc]init];
                model3.pname = @"writingAuthor";
                model3.title = @"热门用户";
                model3.dataArray = kjmodel1.data;
                [data addObject:model3];
            }
            
            KJBaseModel *kjmodel2 = kjResult[@"newWriting"]; //最新文章
            if (kjmodel2.code == 1 && kjmodel2.data.count > 0) {
                XSCustomSectionModel *model3 = [[XSCustomSectionModel alloc]init];
                model3.pname = @"newWriting";
                model3.title = @"最新文章";
                model3.dataArray = kjmodel2.data;
                [data addObject:model3];
            }
            
            KJBaseModel *kjmodel3 = kjResult[@"hotWriting"]; //最热文章
            if (kjmodel3.code == 1 && kjmodel3.data.count > 0) {
                XSCustomSectionModel *model3 = [[XSCustomSectionModel alloc]init];
                model3.pname = @"hotWriting";
                model3.title = @"热门文章";
                model3.dataArray = kjmodel3.data;
                [data addObject:model3];
            }
            self.dataArray = data;
            [self.tableView kj_reloadData:YES];
        });
```

### 单个网络请求的处理

```
KJRequestManager
    // 学者
        .item(KJRequestItem.kjUrl(XSWritingHotAuthorUrl)
              .kjDomain(FinancialBaseUrl)
              .kjMethod(POST)
              .kjParameter(@{@"pageNo":@(self.page),@"pageSize":@(PageTotalCount)})
              .kjGroupKey(@"writingAuthor")
              .kjMultipleAnalyticObjects(@{@"data":@"DKRecommendAuth"})) //
        .request(^(NSDictionary *kjResult){
            KJBaseModel *kjModel = (KJBaseModel*)kjResult; //文章列表
            if (kjModel.code == 1) {
                if (self.page == 1) {
                    [self.authArray removeAllObjects];
                }
                [self.authArray addObjectsFromArray:kjModel.data];
            }
            
            [self.tableView kj_reloadData:kjModel.data.count < PageTotalCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showEmptyViewWithModel:kjModel isDisplay:(self.authArray.count <= 0) || ((DKNetworkModel *)kjModel).showEmpty isAuth:NO];
            });
        });
```


## Requirements

```
@interface KJRequestItem : NSObject

/// 请求的URL，不包含域名
@property (nonatomic, copy) NSString *url;
- (KJRequestStringValueHandle)kjUrl;
- (KJRequestItem *)kjUrl:(NSString *)url;
+ (KJRequestStringValueHandle)kjUrl;       // 可以使用其进行KJRequestItem对象初始化 OC调用方便
+ (KJRequestItem *)kjUrl:(NSString *)url;  // 可以使用其进行KJRequestItem对象初始化 Swift调用方便

/// 域名，默认KJNetworkGlobalConfigs中的kjHost，若有改变，可以设置该值
@property (nonatomic, copy) NSString *domain;
- (KJRequestStringValueHandle)kjDomain;              // 方便OC
- (KJRequestItem *)kjDomain:(NSString *)domain;      // 方便Swift

/// 参数，会合并KJNetworkGlobalConfigs中的kjParams
@property (nonatomic, strong) NSMutableDictionary *parameter;
- (KJRequestDictionaryValueHandle)kjParameter;
- (KJRequestItem *)kjParameter:(NSDictionary *)parameter;

/// 请求头，会合并KJNetworkGlobalConfigs中的kjHeader
@property (nonatomic, strong) NSMutableDictionary *header;
- (KJRequestDictionaryValueHandle)kjHeader;
- (KJRequestItem *)kjHeader:(NSDictionary *)header;

/// 请求方式，默认为GET
@property (nonatomic, assign) KJNetworkMethod method;
- (KJRequestItem * (^)(KJNetworkMethod value))kjMethod;
- (KJRequestItem *)kjMethod:(KJNetworkMethod)method;

/// 解析服务端数据对应的Key，对该Key下的值进行转换设置的Model，默认为KJNetworkGlobalConfigs中的kjObjectKey
@property (nonatomic, copy) NSString *dataKey;
- (KJRequestStringValueHandle)kjDataKey;
- (KJRequestItem *)kjDataKey:(NSString *)dataKey;

/// 如果解析的内容在dataKey的更深的结构层中，可以设置该属性来解决，key：用点语法来获取对应数据，使用箭头(->)来命名(first.datas->first)，value：Model名
@property (nonatomic, strong) NSMutableDictionary *multipleAnalyticObjects;
- (KJRequestDictionaryValueHandle)kjMultipleAnalyticObjects;
- (KJRequestItem *)kjMultipleAnalyticObjects:(NSDictionary *)multipleAnalyticObjects;

/// 如果解析的对象就是dataKey下的数据，则可以直接设置该属性，解析Mode对象的名称
@property (nonatomic, copy) NSString *analyticObject;
- (KJRequestStringValueHandle)kjAnalyticObject;
- (KJRequestItem *)kjAnalyticObject:(NSString *)analyticObject;

/// 如果多个Api同时请求时，需要对解析完后的BaseModel设置Key用于区分，默认是对应的url
@property (nonatomic, copy) NSString *groupKey;
- (KJRequestStringValueHandle)kjGroupKey;
- (KJRequestItem *)kjGroupKey:(NSString *)groupKey;

/// 拦截请求，在请求之前拦截，可以实现关联请求(前面的请求结果是当前请求的参数)
@property (nonatomic, copy) KJRequestItemInterceptHandle interceptHandle;
- (KJRequestItem * (^)(KJRequestItemInterceptHandle value))kjInterceptHandle;
- (KJRequestItem *)kjInterceptHandle:(KJRequestItemInterceptHandle)interceptHandle;

/// 解析的BaseModel，默认为KJNetworkGlobalConfigs中的kjBaseModelName，这个BaseModel必须是继承KJBaseModel
@property (nonatomic, copy) NSString *baseModelName;
- (KJRequestStringValueHandle)kjBaseModelName;
- (KJRequestItem *)kjBaseModelName:(NSString *)baseModelName;

/// 上传文件
@property (nonatomic, strong) NSMutableArray <KJUploadModel *> *fileArr;
- (KJRequestItem * (^)(NSArray<KJUploadModel *> *value))kjFileArr;
- (KJRequestItem *)kjFileArr:(NSArray <KJUploadModel *> *)fileArr;

/// 请求序列化， 默认为KJNetworkGlobalConfigs中的kjRequestSerializer
@property (nonatomic, assign) KJNetworkSerializer requestSerializer;
- (KJRequestItem * (^)(KJNetworkSerializer value))kjRequestSerializer;
- (KJRequestItem *)kjRequestSerializer:(KJNetworkSerializer)requestSerializer;

/// 结果序列化，默认为KJNetworkGlobalConfigs中的kjResponseSerializer
@property (nonatomic, assign) KJNetworkSerializer responseSerializer;
- (KJRequestItem * (^)(KJNetworkSerializer value))kjResponseSerializer;
- (KJRequestItem *)kjResponseSerializer:(KJNetworkSerializer)responseSerializer;

/// 设置可接受的数据类型，默认为KJNetworkGlobalConfigs中的kjAcceptableContentTypes
@property (nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;
- (KJRequestItem * (^)(NSSet <NSString *> *value))kjAcceptableContentTypes;
- (KJRequestItem *)kjAcceptableContentTypes:(NSSet <NSString *> *)acceptableContentTypes;

/// 网络请求适配器，适配器必须实现协议KJRequestAdapter，默认为KJNetworkGlobalConfigs中的requestAdapter
@property (nonatomic, copy) NSString *requestAdapter;
- (KJRequestStringValueHandle)kjRequestAdapter;
- (KJRequestItem *)kjRequestAdapter:(NSString *)requestAdapter;

/// 数据解析适配器，适配器必须实现协议KJAnalyticAdapter，默认为KJNetworkGlobalConfigs中的analyticAdapter
@property (nonatomic, copy) NSString *analyticAdapter;
- (KJRequestStringValueHandle)kjAnalyticAdapter;
- (KJRequestItem *)kjAnalyticAdapter:(NSString *)analyticAdapter;

/// 监听上传进度
@property (nonatomic, copy) KJRequestProgressHandle uploadHandle;
- (KJRequestItem * (^)(KJRequestProgressHandle value))kjUploadHandle;
- (KJRequestItem *)kjUploadHandle:(KJRequestProgressHandle)uploadHandle;

/// 监听下载进度
@property (nonatomic, copy) KJRequestProgressHandle downloadHandle;
- (KJRequestItem * (^)(KJRequestProgressHandle value))kjDownloadHandle;
- (KJRequestItem *)kjDownloadHandle:(KJRequestProgressHandle)downloadHandle;

/// 根据method获取对应的NSString
- (NSString *)requestMethod;

@end

```

## Installation

KJNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KJNetwork'
```

## Author

jin, kegem@foxmail.com

## License

KJNetwork is available under the MIT license. See the LICENSE file for more info.
