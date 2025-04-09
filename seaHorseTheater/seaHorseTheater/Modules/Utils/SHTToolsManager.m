//
//  SHTToolsManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTToolsManager.h"

@implementation SHTToolsManager

+ (UIViewController *)topViewController {
    UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self topViewControllerFrom:rootVC];
}

+ (UIViewController *)topViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:((UINavigationController *)vc).visibleViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:((UITabBarController *)vc).selectedViewController];
    } else if (vc.presentedViewController) {
        return [self topViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}

@end
