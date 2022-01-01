//
//  KJViewController.m
//  KJNetwork
//
//  Created by jin on 06/29/2020.
//  Copyright (c) 2020 jin. All rights reserved.
//

#import "KJViewController.h"
#import "KJNetwork.h"

@interface KJViewController ()


@end

@implementation KJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [KJNetworkGlobalConfigs defaultConfigs].kjHost = @"https://www.51xueshuo.com/";
    [[KJNetworkGlobalConfigs defaultConfigs].kjHeader setValue:@"application/json" forKey:@"Content-Type"];
    [[KJNetworkGlobalConfigs defaultConfigs].kjHeader setValue:@"32aacfe601b642d881702007c6e512a4" forKey:@"Authorization"];
    [KJNetworkGlobalConfigs defaultConfigs].kjBaseModelName = @"KJCustomBaseModel";
    
//    [KJNetworkGroupManager kjRequest:^NSArray<KJNetworkManager *> * _Nonnull{
//        return @[
//            [KJNetworkManager kjRequest:^(KJNetworkManager * _Nonnull manager) {
//                manager.kjURL(@"/home/getResearchReport")
//                .kjMethod(POST)
//                .kjParams(@{@"pageNo": @1, @"pageSize": @10});
//            }],
//            [KJNetworkManager kjRequest:^(KJNetworkManager * _Nonnull manager) {
//                manager.kjURL(@"/home/getLearningVideo")
//                .kjMethod(POST);
//            }]
//        ];
//    } complete:^(NSDictionary<NSString *,KJBaseModel *> * _Nonnull kjResult) {
//
//    }];
    KJRequestManager
        .item(KJRequestItem.kjUrl(@""))
        .item(KJRequestItem.kjUrl(@""))
        .request(^(id resultObject){
            
        });
    
    
//    [[KJRequestManager initWithItems:@[
//        KJRequestItem.kjUrl(@"/home/getResearchReport").kjMethod(POST).kjParameter(@{@"pageNo": @1, @"pageSize": @10}).kjGroupKey(@"1"),
//        KJRequestItem.kjUrl(@"/home/getLearningVideo").kjMethod(POST).kjGroupKey(@"2")
//    ]] request:^(NSDictionary *  _Nonnull resultObject) {
//        NSLog(@"%@", resultObject);
//    }];
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
