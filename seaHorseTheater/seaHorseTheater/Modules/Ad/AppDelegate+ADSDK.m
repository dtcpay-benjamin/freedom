//
//  AppDelegate+ADSDK.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "AppDelegate+ADSDK.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#if __has_include (<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif
@implementation AppDelegate (ADSDK)

- (void)requestIDFAIfNeeded {
    // iOS14适配，申请IDFA权限
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
    config.appID = @"645560";
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        !completionHandler ?: completionHandler(success);
    }];
#endif
}

@end
