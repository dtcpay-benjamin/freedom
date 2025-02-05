//
//  AppDelegate.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/5/25.
//

#import "AppDelegate.h"
#import "AppDelegate+DJXDelegate.h"
#import "AppDelegate+ADSDK.h"
#import <Reachability/Reachability.h>
#import "SHTKaiPingADViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 短剧SDK初始化
    [self initDJX];
    [self setUpHome];
    return YES;
}

// 初始化短剧SDK
- (void)initDJX {
    [self initSDKConfig];
}
// 创建主页
- (void)setUpHome {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    [self requestIDFAIfNeeded];
    [self setupADSDK:^(BOOL success) {
        if (success) {
//            [self setupPangrowthSDK];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.window.rootViewController = [[SHTKaiPingADViewController alloc] init];
                [self.window makeKeyAndVisible];
            });
        }
    }];
}

// 创建短剧SDK
- (void)setupPangrowthSDK {
    __weak typeof(self) weakSelf = self;
    [self setUpDJXSDK:^(BOOL initStatus, NSDictionary * _Nonnull userInfo) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (initStatus) {
            NSLog(@"创建短剧%@ success", NSStringFromSelector(_cmd));
            [strongSelf configMainController];
        }
    }];
}

/// 配置主页面
- (void)configMainController {
    NSMutableArray *viewControllers = [NSMutableArray array];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    void(^addChildVC)(UIViewController *) = ^(UIViewController * _Nullable childVC) {
        if (childVC) {
            [viewControllers addObject:childVC];
        }
    };
    addChildVC([self configPlayletVC]);
    addChildVC([self configPlayletTheater]);
    addChildVC([self configAllVideoVC]);
    tabBarController.viewControllers = [viewControllers copy];
    [tabBarController.navigationController.navigationBar setHidden:YES];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
