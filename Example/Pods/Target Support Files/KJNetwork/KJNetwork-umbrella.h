#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KJBaseModel.h"
#import "KJNetwork.h"
#import "KJNetworkGlobalConfigs.h"
#import "KJNetworkManager.h"
#import "KJNetworkStruct.h"
#import "KJUploadModel.h"

FOUNDATION_EXPORT double KJNetworkVersionNumber;
FOUNDATION_EXPORT const unsigned char KJNetworkVersionString[];

