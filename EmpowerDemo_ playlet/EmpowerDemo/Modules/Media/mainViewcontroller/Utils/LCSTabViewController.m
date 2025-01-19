//
//  LCSTabViewController.m
//  DJXSamples
//
//  Created by iCuiCui on 2020/7/29.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSTabViewController.h"

@interface LCSTabViewController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIViewController *firstVC;
@property (nonatomic, strong) UITabBarController *mainTabVC;
@end

@implementation LCSTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.blackStyle) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self buidSubViews];
}

- (void)selectedTabController {
    [self.mainTabVC setSelectedIndex:1];
}

- (void)selectedfirstController {
    [self.mainTabVC setSelectedIndex:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.blackStyle) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;;
    }
}

- (void)buidSubViews {
    [UITabBar appearance].translucent = NO;
    
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    self.mainTabVC = tabVC;
    tabVC.delegate = self;
    if (self.blackStyle) {
        tabVC.tabBar.tintColor = [UIColor whiteColor];
        tabVC.tabBar.barTintColor = LCS_RGB(0x15,0x17,0x1f);
        if (@available(iOS 10.0, *)) {
            tabVC.tabBar.unselectedItemTintColor = LCS_RGB(0xcb,0xcb,0xcb);
        }
    } else {
        tabVC.tabBar.tintColor = LCS_mainColor;
        tabVC.tabBar.barTintColor =[UIColor whiteColor];
    }
    
    UIViewController *mainViewController = [[UIViewController alloc] init];
    self.firstVC = self.firstTabController?self.firstTabController:mainViewController;
    [self addChildVC:self.firstVC toTabVC:tabVC title:@"首页"];
    
    UIViewController *tabVc = self.tabController?self.tabController:[UIViewController new];
    NSString *tabName = self.tabName?self.tabName:@"小视频";
    [self addChildVC:tabVc toTabVC:tabVC title:tabName];
    
    UIViewController *meViewController = self.mineTabController?self.mineTabController:[UIViewController new];
    [self addChildVC:meViewController toTabVC:tabVC title:@"我的"];
    
    [self.view addSubview:tabVC.view];
    [self addChildViewController:tabVC];
    
    self.closeButton = [self createCloseButton];
    [self.view addSubview:self.closeButton];
}

- (UIButton *)createCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(15, LCS_stautsBarHeight+15, 24, 24);
    NSString *imageName = self.blackStyle?@"LCS_closeButton":@"LCS_closeButton_black";
    [closeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

- (void)didClickCloseButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)addChildVC:(UIViewController *)viewController toTabVC:(UITabBarController *)tabVC title:(NSString *)title {
    viewController.tabBarItem.title = title;
    CGFloat titleFont = 16;
    [viewController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:titleFont]} forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:titleFont]} forState:UIControlStateSelected];
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,(titleFont-48)/2)];
    [tabVC addChildViewController:viewController];
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.firstVC) {
        self.closeButton.hidden = NO;
    } else {
        self.closeButton.hidden = YES;
    }
}

@end
