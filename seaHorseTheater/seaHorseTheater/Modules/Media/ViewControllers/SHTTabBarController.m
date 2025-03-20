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
}

- (void)setChilds {
    NSMutableArray *viewControllers = [NSMutableArray array];

    void(^addChildVC)(UIViewController *) = ^(UIViewController * _Nullable childVC) {
        if (childVC) {
            [viewControllers addObject:childVC];
        }
    };
    addChildVC([self configHomeVideoVC]);
    self.viewControllers = [viewControllers copy];
    [self.navigationController.navigationBar setHidden:YES];

}
/// 初始化首页
- (UINavigationController *)configHomeVideoVC {
    SHTHomeViewController *homeVideoVc = [[SHTHomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVideoVc];
    navigationController.navigationBarHidden = YES;
    navigationController.navigationBar.alpha = 0.0;
    navigationController.navigationBar.userInteractionEnabled = NO;
    // 设置黑色导航栏
//    if (@available(iOS 13.0, *)) {
//        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
//        [appearance configureWithOpaqueBackground];
//        appearance.backgroundColor = [UIColor blackColor];
//        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//        navigationController.navigationBar.standardAppearance = appearance;
//        navigationController.navigationBar.scrollEdgeAppearance = appearance;
//    } else {
//        navigationController.navigationBar.barTintColor = [UIColor blackColor];
//        navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//    }
//    navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    navigationController.navigationBar.translucent = NO;
//    navigationController.tabBarItem.image = [UIImage imageNamed:@"collection"];
    navigationController.title = @"首页";
    return navigationController;
}
/// 初始化我的
- (UINavigationController *)configMineVideoVC {
    SHTMineViewController *mineVideoVc = [[SHTMineViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mineVideoVc];
    navigationVC.title = @"我的";
    return navigationVC;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
