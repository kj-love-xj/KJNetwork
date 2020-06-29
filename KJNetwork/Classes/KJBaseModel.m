//
//  KJBaseModel.m
//  KJNetworkRequest
//
//  Created by 黄克瑾 on 2020/6/19.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#import "KJBaseModel.h"
#import <MJExtension/MJExtension.h>

@implementation KJBaseModel

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"data", @"succeed"];
}

- (BOOL)succeed {
    return self.code == 200;
}

@end
