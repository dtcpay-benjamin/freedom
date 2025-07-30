//
//  SHTAppRateTool.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/30.
//

#import "SHTAppRateTool.h"
#import <StoreKit/StoreKit.h>

@implementation SHTAppRateTool

/// ⚠️ 请替换成你自己 App 的 ID
static NSString * const kAppStoreAppID = @"1234567890";

+ (void)requestSystemReview {
    if (@available(iOS 10.3, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SKStoreReviewController requestReview];
        });
    }
}

+ (void)jumpToAppStoreReviewPage {
    NSString *reviewURL = [NSString stringWithFormat:
        @"https://itunes.apple.com/app/id%@?action=write-review", kAppStoreAppID];
    NSURL *url = [NSURL URLWithString:reviewURL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

/// 自动判断：系统评分 → 失败则跳转
+ (void)requestReviewWithFallback {
    if (@available(iOS 10.3, *)) {
        [self requestSystemReview];
        // ⚠️ 系统不保证一定弹出，所以可以选择延迟后再跳转（可选）
        // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //     [self jumpToAppStoreReviewPage];
        // });
    } else {
        [self jumpToAppStoreReviewPage];
    }
}

/// 分享App
+ (void)shareAppAction:(UIViewController *)superVC {
    NSString *appURLString = [NSString stringWithFormat:
                              @"https://apps.apple.com/app/id%@", kAppStoreAppID]; // 替换为你的 App ID
    NSURL *appURL = [NSURL URLWithString:appURLString];
    NSString *title = @"推荐你使用这款 App！";
    NSArray *itemsToShare = @[title, appURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    // 适配 iPad（防止 crash）
    activityVC.popoverPresentationController.sourceView = superVC.view;
    [superVC presentViewController:activityVC animated:YES completion:nil];
}

@end
