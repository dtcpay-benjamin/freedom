//
//  AppDelegate+DJXDelegate.m
//  EmpowerDemo
//
//  Created by admin on 2021/5/18.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "AppDelegate+DJXDelegate.h"
#import "LCSMainViewController.h"
#import "MBProgressHUD+Toast.h"
#if __has_include (<PangrowthMiniStory/MNManager.h>)
#import <PangrowthMiniStory/MNSMainViewController.h>
#import <PangrowthMiniStory/MNStoryConfig+Reader.h>
#import <PangrowthMiniStory/MNManager.h>
#import <PangrowthMiniStory/MNConfig.h>
#import "MNStoryReaderAdUtil.h"
#import "MNStoryBottomAdView.h"
#import "MNStoryMiddleAdViewController.h"
#endif

NSNotificationName _Nonnull const kLCSDJXSDKSetConfigNotification = @"kLCSDJXSDKSetConfigNotification";

static NSString * JSONConfigPath(void) {
    return [[NSBundle mainBundle] pathForResource:@"SDK_Setting_5434885" ofType:@"json"];
}

@implementation AppDelegate (DJXDelegate)

- (void)initSDKConfig {
#if __has_include (<PangrowthDJX/DJXSDK.h>)
    DJXConfig *config = [DJXConfig new];
    config.authorityDelegate = self;
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:kLCSDJXSDKSetConfigNotification object:nil userInfo:@{@"config": config}]];
    [DJXManager initializeWithConfigPath:JSONConfigPath() config:config];
#elif __has_include (<PangrowthMiniStory/MNManager.h>)
    MNConfig *config = [MNConfig new];
    config.logLevel = DJXSDKLogLevelDebug;
    [MNManager initializeWithConfigPath:JSONConfigPath() config:config];
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:kLCSDJXSDKSetConfigNotification object:nil userInfo:@{@"config": config}]];
#endif
}

#if __has_include (<PangrowthDJX/DJXSDK.h>)
- (void)setUpDJXSDK:(DJXStartCompletionBlock)block {
    [DJXManager startWithCompleteHandler:^(BOOL isSuccess, NSDictionary * _Nonnull userInfo) {
        if (isSuccess) {
            NSLog(@"初始化注册成功！");
        } else {
            NSLog(@"%@", userInfo[@"msg"]);
        }
        if (block) {
            block(isSuccess, userInfo);
        }
    }];
}

- (UINavigationController *)configPlayletVC {
    UIViewController *vc = [UIViewController new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBar.hidden = YES;
    navi.tabBarItem.title = @"短剧";
    navi.tabBarItem.image = [UIImage imageNamed:@"video"];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vc.view.width, vc.view.height - LCS_tabBarHeight)];
    tmpView.backgroundColor = UIColor.whiteColor;
    [vc.view addSubview:tmpView];
    
    DJXDrawVideoViewController *smallVideoVC = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 5;
        playletConfig.unlockEpisodesCountUsingAD = 2;
        
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
        config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight - LCS_tabBarHeight);
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
    }];
    
    [vc addChildViewController:smallVideoVC];
    [tmpView addSubview:smallVideoVC.view];
    tmpView.layer.masksToBounds = YES;
    
    return navi;
}

- (UINavigationController *)configPlayletTheater {
    DJXPlayletAggregatePageViewController *vc = [[DJXPlayletAggregatePageViewController alloc] initWithConfigBuilder:^(DJXPlayletAggregatePageVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
        playletConfig.freeEpisodesCount = 10;
        playletConfig.unlockEpisodesCountUsingAD = 5;
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        config.playletConfig = playletConfig;
        config.isShowNavigationItemTitle = YES;
        config.isShowNavigationItemBackButton = NO;
    }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.title = @"剧场";
    navigationController.tabBarItem.image = [UIImage imageNamed:@"theater"];
    return navigationController;
}

#endif

#if __has_include (<PangrowthMiniStory/MNManager.h>)
- (void)setUpDGSSDK:(MNStartCompletionBlock)block {
    MNConfig *config = [MNConfig new];
    config.authorityDelegate = self;
#if DEBUG
    config.logLevel = DJXSDKLogLevelDebug;
#endif
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:kLCSDJXSDKSetConfigNotification object:nil userInfo:@{@"config": config}]];
    
    [MNManager initializeWithConfigPath:JSONConfigPath() config:config];
    [MNManager startWithCompleteHandler:^(BOOL isSuccess, NSDictionary * _Nonnull userInfo) {
        if (isSuccess) {
            NSLog(@"初始化注册成功！");
        } else {
            NSLog(@"%@", userInfo[@"msg"]);
        }
        if (block) {
            block(isSuccess, userInfo);
        }
    }];
}

- (UINavigationController *)configMiniStoryVC {
    MNStoryReaderOpenParams *params = [[MNStoryReaderOpenParams alloc] init];
    params.customRewardAD = NO;
    params.addCustomRewardPoint = NO;
    params.showCustomBottomBannerAD = YES;
    params.showCustomMiddleAD = YES;
    params.pageIntervalForMiddleAD = 4;
    params.customRewardEntryView = NO;
    
    params.delegate = self;
    MNSMainViewController *vc = [[MNSMainViewController alloc] initWithReadConfig:params];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = @"短故事";
    nav.tabBarItem.image = [UIImage imageNamed:@"theater"];
    return nav;
}

- (Class<MNStoryReaderBannerAdViewProtocol>)mns_bottomBannerADClass {
    return [MNStoryBottomAdView class];
}

- (Class<MNStoryReaderNewAdViewControllerProtocol>)mns_middleADClass {
    return [MNStoryMiddleAdViewController class];
}

- (BOOL)mns_shouldShowEntryView:(MNStorySessionContext *)sessionContext {
    if (sessionContext.pageIndex == 0 && sessionContext.isTextPage) {
        return YES;
    }
    return NO;
}

- (UIView<MNStoryRewardADEntryViewProtocol> *)mns_rewardEntryView:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
    return nil;
}

- (void)mns_onUnlockFlowStart:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_showCustomAD:(MNStorySessionContext *)sessionContext onADWillShow:(void (^)(NSString * cpm))onADWillShow onADRewardDidVerified:(void (^)(MNStoryRewardADResult * _Nonnull))onADRewardDidVerified {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_onUnlockFlowEnd:(MNStorySessionContext *)sessionContext success:(BOOL)success error:(NSError *)error {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_startReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_turnPage:(MNStorySessionContext *)sessionContext from:(NSInteger)fromPage to:(NSInteger)toPage {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_stopReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}

- (void)mns_finishReading:(MNStorySessionContext *)sessionContext {
    NSLog(@"#短故事# %s", __FUNCTION__);
}
#endif

#if __has_include (<LCDSDK/LCDSDK.h>)
- (void)setUpLCDSDK:(LCDStartCompletionBlock)block {
    LCDConfig *config = [LCDConfig new];
#if DEBUG
    config.logLevel = LCDSDKLogLevelDebug;
#endif
    
    [LCDManager initializeWithConfigPath:JSONConfigPath() config:config];
    [LCDManager startWithCompleteHandler:^(LCDINITStatus initStatus, NSDictionary *userInfo) {
        if (initStatus == LCDINITStatus_success) {
            NSLog(@"初始化注册成功！");
        } else {
            NSLog(@"%@", userInfo[@"msg"]);
        }
        if (block) {
            block(initStatus, userInfo);
        }
    }];
}

- (LCDDrawVideoViewController *)configVideoVC {
    LCDDrawVideoViewController *videoVc = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
        config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight - LCS_tabBarHeight);
        config.drawVCTabOptions = LCDDrawVideoVCTabOptions_recommand | LCDDrawVideoWatcherRole_User;
    }];
    videoVc.tabBarItem.title = @"小视频";
    videoVc.tabBarItem.image = [UIImage imageNamed:@"video"];

    return videoVc;
}
#endif

#pragma mark 测试页

- (BOOL)isOnlyICPNumber {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"com.pangrowth.onlyRecord"] boolValue];
}

- (BOOL)turnOnTeenMode {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"com.pangrowth.teenager"] boolValue];
}

- (BOOL)allowAccessIDFA {
    return NO;
}

/// 初始化更多页
- (UINavigationController *)configAllVideoVC {
    LCSMainViewController *allVideoVc = [[LCSMainViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:allVideoVc];
    navigationVC.title = @"更多";
    navigationVC.tabBarItem.image = [UIImage imageNamed:@"collection"];
    return navigationVC;
}

#if __has_include (<PangrowthDJX/DJXSDK.h>)
- (void)clickEnterView:(DJXPlayletInfoModel *)infoModel {
    if (infoModel) {
        DJXPlayletConfig *config = [DJXPlayletConfig new];
        config.skitId = infoModel.shortplay_id;
        config.episode = infoModel.current_episode;
        config.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
        config.infoModel = infoModel;
        
        DJXDrawVideoViewController *vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController performSelector:@selector(djx_topViewController)] presentViewController:vc animated:YES completion:nil];
    }
}
#endif

@end
