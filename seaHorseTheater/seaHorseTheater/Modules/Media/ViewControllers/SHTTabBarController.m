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
}
/// 初始化首页
- (UIViewController *)configHomeVideoVC {
    SHTHomeViewController *homeVideoVc = [[SHTHomeViewController alloc] init];
    homeVideoVc.title = @"首页";
    return homeVideoVc;
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
