//
//  AppDelegate+DJXDelegate.h
//  EmpowerDemo
//
//  Created by admin on 2021/5/18.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "AppDelegate.h"
#import "LCSConfigID.h"
#import <UserNotifications/UserNotifications.h>

#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>
#endif

#if __has_include (<PangrowthMiniStory/MNManager.h>)
#import <PangrowthMiniStory/MNStoryManager.h>
#import <PangrowthMiniStory/MNManager.h>
#endif

#if __has_include (<LCDSDK/LCDSDK.h>)
#import <LCDSDK/LCDSDK.h>
#endif

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName _Nonnull const kLCSDJXSDKSetConfigNotification;

#if __has_include (<PangrowthDJX/DJXSDK.h>) && __has_include (<PangrowthMiniStory/MNManager.h>)
@interface AppDelegate (DJXDelegate) <UNUserNotificationCenterDelegate, DJXAuthorityConfigDelegate, DJXScrollViewDelegate, MNStoryReaderDelegate>

/// 初始化配置
- (void)initSDKConfig;
/// 初始化更多页
- (UINavigationController *)configAllVideoVC;

/// 初始化小视频
- (void)setUpLCDSDK:(LCDStartCompletionBlock)block;
/// 初始化小视频首页
- (LCDDrawVideoViewController *)configVideoVC;

/// 初始化短剧
- (void)setUpDJXSDK:(DJXStartCompletionBlock)block;
/// 初始化短剧滑滑流
- (UINavigationController *)configPlayletVC;
/// 初始化短剧剧场页
- (UINavigationController *)configPlayletTheater;

/// 初始化短故事
- (void)setUpDGSSDK:(MNStartCompletionBlock)block;
/// 初始化短故事聚合页
- (UINavigationController *)configMiniStoryVC;

#elif __has_include (<PangrowthDJX/DJXSDK.h>)
@interface AppDelegate (DJXDelegate) <UNUserNotificationCenterDelegate, DJXAuthorityConfigDelegate, DJXScrollViewDelegate>

/// 初始化配置
- (void)initSDKConfig;
/// 初始化更多页
- (UINavigationController *)configAllVideoVC;

/// 初始化小视频
- (void)setUpLCDSDK:(LCDStartCompletionBlock)block;
/// 初始化小视频首页
- (LCDDrawVideoViewController *)configVideoVC;

/// 初始化短剧
- (void)setUpDJXSDK:(DJXStartCompletionBlock)block;
/// 初始化短剧滑滑流
- (UINavigationController *)configPlayletVC;
/// 初始化短剧剧场页
- (UINavigationController *)configPlayletTheater;

#elif __has_include (<PangrowthMiniStory/MNManager.h>)
@interface AppDelegate (DJXDelegate) <UNUserNotificationCenterDelegate, MNStoryReaderDelegate>

/// 初始化配置
- (void)initSDKConfig;
/// 初始化更多页
- (UINavigationController *)configAllVideoVC;

/// 初始化小视频
- (void)setUpLCDSDK:(LCDStartCompletionBlock)block;
/// 初始化小视频首页
- (LCDDrawVideoViewController *)configVideoVC;

/// 初始化短故事
- (void)setUpDGSSDK:(MNStartCompletionBlock)block;
/// 初始化短故事聚合页
- (UINavigationController *)configMiniStoryVC;

#else
@interface AppDelegate (DJXDelegate) <UNUserNotificationCenterDelegate>

/// 初始化配置
- (void)initSDKConfig;
/// 初始化更多页
- (UINavigationController *)configAllVideoVC;

/// 初始化小视频
- (void)setUpLCDSDK:(LCDStartCompletionBlock)block;
/// 初始化小视频首页
- (LCDDrawVideoViewController *)configVideoVC;

#endif

@end

NS_ASSUME_NONNULL_END
