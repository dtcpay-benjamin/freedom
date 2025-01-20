//
//  AppDelegate+DJDelegate.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/19/25.
//

#import "AppDelegate+DJXDelegate.h"

NSNotificationName _Nonnull const SHTDJXSDKSetConfigNotification = @"SHTDJXSDKSetConfigNotification";

static NSString * JSONConfigPath(void) {
    return [[NSBundle mainBundle] pathForResource:@"SDK_Setting_5603361" ofType:@"json"];
}

@implementation AppDelegate (DJXDelegate)

- (void)initSDKConfig {
    DJXConfig *config = [DJXConfig new];
    config.authorityDelegate = self;
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:SHTDJXSDKSetConfigNotification object:nil userInfo:@{@"config": config}]];
    [DJXManager initializeWithConfigPath:JSONConfigPath() config:config];
}
/// 初始化短剧
- (void)setUpDJXSDK:(nonnull DJXStartCompletionBlock)block {
    [DJXManager startWithCompleteHandler:^(BOOL isSuccess, NSDictionary * _Nonnull userInfo) {
        if (isSuccess == true) {
            NSLog(@"初始化注册成功！");
        } else {
            NSLog(@"%@", userInfo[@"msg"]);
        }
        if (block) {
            block(isSuccess, userInfo);
        }
    }];
}
/// 初始化短剧滑滑流
- (nonnull UINavigationController *)configPlayletVC {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.tabBarItem.title = @"短剧";
    // TODO:暂时没有图标
    vc.tabBarItem.image = [UIImage imageNamed:@"video"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBar.hidden = YES;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vc.view.width, vc.view.height - SHT_tabBarHeight)];
    view.backgroundColor = UIColor.whiteColor;
    [vc.view addSubview:view];
    
    DJXDrawVideoViewController *smallVideoVC = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 5;
        playletConfig.unlockEpisodesCountUsingAD = 2;
        
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
        config.viewSize = CGSizeMake(SHTScreenWidth, SHTScreenHeight - SHT_tabBarHeight);
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
    }];
    
    [vc addChildViewController:smallVideoVC];
    [view addSubview:smallVideoVC.view];
    view.layer.masksToBounds = YES;
    
    return navi;
}
/// 初始化短剧剧场页
- (nonnull UINavigationController *)configPlayletTheater {
}
@end
