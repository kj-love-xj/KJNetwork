//
//  KJNetworkStruct.h
//  KJNetwork
//
//  Created by 黄克瑾 on 2020/6/29.
//  Copyright © 2020 黄克瑾. All rights reserved.
//

#ifndef KJNetworkStruct_h
#define KJNetworkStruct_h

typedef NS_ENUM(NSInteger){
    GET,
    POST,
    PUT,
    DELETE
} KJNetworkMethod;

typedef NS_ENUM(NSInteger) {
    HTTP,
    JSON
}KJNetworkSerializer;



#endif /* KJNetworkStruct_h */
