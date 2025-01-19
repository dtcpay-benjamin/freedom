//
//  AppDelegate+ADSDK.m
//  EmpowerDemo
//
//  Created by admin on 2021/5/18.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "AppDelegate+ADSDK.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#if __has_include (<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif
@implementation AppDelegate (ADSDK)

- (void)requestIDFAIfNeeded {
    // iOS 14适配，申请IDFA权限
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // do something
        }];
    }
}

- (void)setupADSDK:(void (^)(BOOL success))completionHandler {
    // 初始化穿山甲SDK
#if __has_include (<BUAdSDK/BUAdSDK.h>)
    BUAdSDKConfiguration *config = [BUAdSDKConfiguration configuration];
    config.appID = @"5434885";
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        !completionHandler ?: completionHandler(success);
    }];
#endif
}

@end
