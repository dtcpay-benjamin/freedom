//
//  SHTMainViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "SHTHomeViewController.h"
#import <PangrowthDJX/DJXSDK.h>

@interface SHTHomeViewController ()

@end

@implementation SHTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 初始化短剧滑滑流
- (nonnull UINavigationController *)configPlayletVC {
    UIViewController *vc = [[UIViewController alloc] init];
    // TODO:暂时没有图标
    vc.tabBarItem.image = [UIImage imageNamed:@"video"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.title = @"短剧";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
