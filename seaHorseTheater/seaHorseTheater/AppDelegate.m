//
//  AppDelegate.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/5/25.
//

#import "AppDelegate.h"
#import "AppDelegate+DJXDelegate.h"
#import "AppDelegate+ADSDK.h"
#import "SHTKaiPingADViewController.h"
#import "SHTTabBarController.h"
#import "SHTKeychainHelper.h"
#import "SHTSubscriptionManager.h"
#import "SHTAlertHelper.h"

@interface AppDelegate()<UIApplicationDelegate, UITabBarControllerDelegate>

@property(nonatomic, strong) SHTTabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 短剧SDK初始化
    [self initDJX];
    [self setUpHome];
    return YES;
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // 获取订阅状态
//    [self fetchSubscriptionStatus];
//}

// 初始化短剧SDK
- (void)initDJX {
    [self initSDKConfig];
}
// 创建主页
- (void)setUpHome {
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
    self.tabBarController = [[SHTTabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self changeTabBarColor:SHT_TABBAR_HOME_COLOR];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

// 改变tabBar的背景色
- (void)changeTabBarColor:(UIColor *)color {
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = color;
        self.tabBarController.tabBar.standardAppearance = appearance;
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
    } else {
        self.tabBarController.tabBar.barTintColor = color;
    }
}

// 获取当前用户的订阅状态
- (void)fetchSubscriptionStatus {
//    if (![SHTKeychainHelper hasKey:@"isSubscribed"]) {
//        [[SHTSubscriptionManager sharedManager] checkSubscriptionStatus];
//    }
    [[SHTSubscriptionManager sharedManager] checkSubscriptionStatus];
}

#pragma mark - UITabBarControllerDelegate
//
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
//    [self changeTabBarColor:SHT_TABBAR_HOME_COLOR];
//}

@end
