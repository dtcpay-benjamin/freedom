//
//  SHTabBarController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2/25/25.
//

#import "SHTTabBarController.h"
#import "SHTHomeViewController.h"
#import "SHTMineViewController.h"

@interface SHTTabBarController ()

@end

@implementation SHTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChilds];
    [self configTabBar];
}

- (void)configTabBar {
    self.tabBar.barTintColor = [UIColor whiteColor]; // 背景色
//    self.tabBar.tintColor = [UIColor redColor];      // 选中时的颜色
//    self.tabBar.unselectedItemTintColor = [UIColor blackColor]; // 未选中颜色
}

- (void)setChilds {
    NSMutableArray *viewControllers = [NSMutableArray array];
    void(^addChildVC)(UIViewController *) = ^(UIViewController * _Nullable childVC) {
        if (childVC) {
            [viewControllers addObject:childVC];
        }
    };
    addChildVC([self configHomeVideoVC]);
    addChildVC([self configMineVC]);
    self.viewControllers = [viewControllers copy];
}

/// 初始化首页
- (UIViewController *)configHomeVideoVC {
    SHTHomeViewController *homeVideoVC = [[SHTHomeViewController alloc] init];
//    homeVideoVC.tabBarItem.title = @"首页";
    homeVideoVC.tabBarItem.image = [UIImage imageNamed:@"home_normal"];
    homeVideoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 保持原图色
    homeVideoVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    return homeVideoVC;
}

/// 初始化我的
- (UINavigationController *)configMineVC {
    SHTMineViewController *mineVideoVc = [[SHTMineViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mineVideoVc];
//    navigationVC.tabBarItem.title = @"我的";
    navigationVC.tabBarItem.image = [UIImage imageNamed:@"me_normal"];
    navigationVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 保持原图色
    navigationVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    return navigationVC;
}

@end
