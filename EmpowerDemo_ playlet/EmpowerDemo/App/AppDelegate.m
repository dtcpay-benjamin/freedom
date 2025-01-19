//
//  AppDelegate.m
//  mPaaSProject_InHouse
//
//  Created by Bob on 2020/3/30. 
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DJXDelegate.h"
#import "AppDelegate+ADSDK.h"
#import "LCSConfigID.h"
#import "IntroViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = IntroViewController.new;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)prepare {
    [self initSDKConfig];
}

- (void)setup {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    [self requestIDFAIfNeeded];
    [self setupADSDK:^(BOOL success) {
        if (success) {
            [self setupPangrowthSDK];
        }
    }];
}

- (void)setupPangrowthSDK {
    dispatch_group_t group = dispatch_group_create();
#if __has_include (<PangrowthDJX/DJXSDK.h>)
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setUpDJXSDK:^(BOOL initStatus, NSDictionary * _Nonnull userInfo) {
            if (initStatus) {
                NSLog(@"%@ success", NSStringFromSelector(_cmd));
                dispatch_group_leave(group);
            }
        }];
    });
#endif
#if __has_include (<PangrowthMiniStory/MNManager.h>)
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setUpDGSSDK:^(BOOL initStatus, NSDictionary * _Nonnull userInfo) {
            if (initStatus) {
                NSLog(@"%@ success", NSStringFromSelector(_cmd));
                dispatch_group_leave(group);
            }
        }];
    });
#endif
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setUpLCDSDK:^(LCDINITStatus initStatus, NSDictionary * _Nonnull userInfo) {
            if (initStatus) {
                NSLog(@"%@ success", NSStringFromSelector(_cmd));
                dispatch_group_leave(group);
            }
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self configMainController];
    });
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
#if __has_include (<PangrowthDJX/DJXSDK.h>)
    addChildVC([self configPlayletVC]);
    addChildVC([self configPlayletTheater]);
#endif

#if __has_include (<PangrowthMiniStory/MNManager.h>)
    addChildVC([self configMiniStoryVC]);
#endif
    addChildVC([self configVideoVC]);
    addChildVC([self configAllVideoVC]);
    
    tabBarController.viewControllers = [viewControllers copy];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    [tabBarController.navigationController.navigationBar setHidden:YES];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
