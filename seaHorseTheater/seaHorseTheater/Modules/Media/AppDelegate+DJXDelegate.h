//
//  AppDelegate+DJDelegate.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/19/25.
//

#import "AppDelegate.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTConfigID.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName _Nonnull const SHTDJXSDKSetConfigNotification;

@interface AppDelegate(DJXDelegate) <DJXAuthorityConfigDelegate, DJXScrollViewDelegate>
/// 初始化配置
- (void)initSDKConfig;
/// 初始化短剧
- (void)setUpDJXSDK:(DJXStartCompletionBlock)block;
/// 初始化短剧滑滑流
- (UINavigationController *)configPlayletVC;
/// 初始化短剧剧场页
- (UINavigationController *)configPlayletTheater;
@end

NS_ASSUME_NONNULL_END
