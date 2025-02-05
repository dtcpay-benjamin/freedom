//
//  AppDelegate+ADSDK.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "AppDelegate+ADSDK.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <objc/runtime.h>


@implementation AppDelegate (ADSDK)

static char kShtSplashAdKey;

- (void)setShtSplashAd:(BUSplashAd *)shtSplashAd {
    objc_setAssociatedObject(self, &kShtSplashAdKey, shtSplashAd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BUSplashAd *)shtSplashAd {
    return objc_getAssociatedObject(self, &kShtSplashAdKey);
}

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
    BUAdSDKConfiguration *config = [BUAdSDKConfiguration configuration];
    config.appID = @"5603361";
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"穿山甲SDK初始化失败: %@", error);
        } else {
            NSLog(@"穿山甲SDK初始化成功");
            !completionHandler ?: completionHandler(success);
        }
    }];
}

@end
