//
//  LCSPlayletMainViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/5/23.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletMainViewController.h"
#import "LCSPlayletInterfaceViewController.h"
#import "LCSPlayletMixViewController.h"
#import "LCSPlayletCardSettingsViewController.h"
#import "LCSPlayletDetailConfigViewController.h"
#import "LCSAPIDemoViewController.h"
#import "LCSCustomDrawAdViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>

@interface LCSPlayletMainViewController () <DJXPlayletAdvertProtocol, DJXPlayletPlayerProtocol, DJXPlayletDetailCellDelegate, DJXDrawVideoViewControllerDelegate, DJXPlayletInterfaceProtocol, DJXDrawVideoViewControllerBannerDelegate>
@property (nonatomic, weak) DJXDrawVideoViewController *vc;
@end

@implementation LCSPlayletMainViewController

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *shortPlayModel = [LCSActionModel plainTitleActionModel:@"短剧" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.playerDelegate = self;

            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_theater | DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.delegate = self;
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *shortPlayInterfaceModel = [LCSActionModel plainTitleActionModel:@"短剧(非封装)" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSPlayletInterfaceViewController *vc = [LCSPlayletInterfaceViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *mixPlayInterfaceModel = [LCSActionModel plainTitleActionModel:@"短剧混排" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSPlayletMixViewController *vc = [LCSPlayletMixViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *playletCardModel = [LCSActionModel plainTitleActionModel:@"短剧卡片" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSPlayletCardSettingsViewController *vc = [[LCSPlayletCardSettingsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    

    LCSActionModel *playletDetailCustomModel = [LCSActionModel plainTitleActionModel:@"短剧详情自定义View" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        DJXPlayletAggregatePageViewController *vc = [[DJXPlayletAggregatePageViewController alloc] initWithConfigBuilder:^(DJXPlayletAggregatePageVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.playerDelegate = self;
            playletConfig.adDelegate = self;
            playletConfig.customViewDelegate = self;
            config.playletConfig = playletConfig;
            config.isShowNavigationItemTitle = YES;
            config.isShowNavigationItemBackButton = YES;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *playletDetailCustomModel1 = [LCSActionModel plainTitleActionModel:@"短剧自定义倍速&跳转" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.playerDelegate = self;
            playletConfig.customViewDelegate = self;
            
            config.drawVideoCellAddSubviewDelegate = self;
            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_theater | DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.delegate = self;
        }];
        self.vc = vc;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    //    LCSActionModel *playletSearchModel = [LCSActionModel plainTitleActionModel:@"短剧搜索" cellType:LCSCellType_video action:^{
    //        lcs_strongify(self)
    //        DJXPlayletSearchViewController *vc = [[DJXPlayletSearchViewController alloc] init];
    //        vc.modalPresentationStyle = UIModalPresentationFullScreen;
    //        [self presentViewController:vc animated:NO completion:nil];
    //    }];
    
    LCSActionModel *shortplayLogicVerifyModel = [LCSActionModel plainTitleActionModel:@"广告解锁" cellType:LCSCellType_video action:^{
        LCSPlayletDetailConfigViewController *vc = [[LCSPlayletDetailConfigViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *drawBanner = [LCSActionModel plainTitleActionModel:@"滑滑流底部banner" cellType:LCSCellType_video action:^{
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.playerDelegate = self;

            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_theater | DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.bannerDelegate = self;
            config.delegate = self;
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *playerBanner = [LCSActionModel plainTitleActionModel:@"短剧详情页底部banner" cellType:LCSCellType_video action:^{
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.interfaceDelegate = self;

            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_theater | DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.delegate = self;
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *customDrawAd = [LCSActionModel plainTitleActionModel:@"自定义Draw广告" cellType:LCSCellType_video action:^{
        LCSCustomDrawAdViewController *vc = [[LCSCustomDrawAdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *apiDemo = [LCSActionModel plainTitleActionModel:@"点赞收藏" cellType:LCSCellType_video action:^{
        LCSAPIDemoViewController *vc = [[LCSAPIDemoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.items = @[
        @[shortPlayModel,
          shortPlayInterfaceModel,
          mixPlayInterfaceModel],
        @[playletCardModel],
        @[playletDetailCustomModel, playletDetailCustomModel1],
        //        @[playletSearchModel],
        @[shortplayLogicVerifyModel],
        @[drawBanner, playerBanner, customDrawAd],
        @[apiDemo]
    ];
}

- (void)pageViewControllerSwitchToIndex:(NSInteger)index {
    NSLog(@"[短剧回调]页面回调 %s", __func__);
}

///广告回调

- (void)lcdAdFillFail:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdAdLoadFail:(nonnull DJXAdTrackEvent *)event error:(nonnull NSError *)error {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdAdLoadSuccess:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdAdWillShow:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdClickAdViewEvent:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdSendAdRequest:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoAdContinue:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoAdOverPlay:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoAdPause:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoAdStartPlay:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoBufferEvent:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)lcdVideoRewardFinishEvent:(nonnull DJXAdTrackEvent *)event {
    NSNumber *verift = event.params[@"ad_verify"];
    NSLog(@"[短剧回调]广告回调 %s 激励是否完成：%d", __func__, verift.boolValue);
}

- (void)lcdVideoRewardSkipEvent:(nonnull DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

///播放器回调

- (void)drawVideoContinue:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideoOverPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideoPause:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideoPlayCompletion:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideoStartPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
    // 详情页倍速拿到UI实例
    self.vc = viewController.parentViewController.parentViewController;
}

- (void)onVideSeekToTime:(NSTimeInterval)endTime inPosition:(NSInteger)position {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideo:(UIViewController *)viewController config:(DJXPlayletInfoModel *)config progress:(CGFloat)progress {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideoError:(UIViewController *)viewController config:(DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

#pragma mark - DJXPlayletDetailCellDelegate
- (UIView *)djx_drawVideoCellSubview:(UITableViewCell *)cell {
    return [self djx_playletDetailCellCustomView:cell];
}

- (UIView *)djx_playletDetailCellCustomView:(UITableViewCell *)cell {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(20, 300, 400, 400)];
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 80, 80)];
    a.backgroundColor = [UIColor greenColor];
    [a addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setEpisodeSpeed1_5)]];
    UILabel *al = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    al.text = @"单集1.5倍";
    al.textColor = UIColor.blackColor;
    [a addSubview:al];
    [bg addSubview:a];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(120, 0, 80, 80)];
    b.backgroundColor = [UIColor redColor];
    [b addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setShortPlaySpeed1_5)]];
    UILabel *bl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    bl.text = @"整剧1.5倍";
    bl.textColor = UIColor.blackColor;
    [b addSubview:bl];
    [bg addSubview:b];
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(220, 0, 80, 80)];
    c.backgroundColor = [UIColor whiteColor];
    [c addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setGlobalPlaySpeed3)]];
    UILabel *cl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    cl.text = @"全局3倍";
    cl.textColor = UIColor.blackColor;
    [c addSubview:cl];
    [bg addSubview:c];
    
    UIView *a1 = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 80, 80)];
    a1.backgroundColor = [UIColor greenColor];
    [a1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setEpisodeSpeed0_5)]];
    UILabel *al1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    al1.text = @"单集0.5倍";
    al1.textColor = UIColor.blackColor;
    [a1 addSubview:al1];
    [bg addSubview:a1];
    
    UIView *b1 = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 80, 80)];
    b1.backgroundColor = [UIColor redColor];
    [b1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setShortPlaySpeed0_5)]];
    UILabel *bl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    bl1.text = @"整剧0.5倍";
    bl1.textColor = UIColor.blackColor;
    [b1 addSubview:bl1];
    [bg addSubview:b1];
    
    UIView *c1 = [[UIView alloc] initWithFrame:CGRectMake(220, 100, 80, 80)];
    c1.backgroundColor = [UIColor whiteColor];
    [c1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_setGlobalPlaySpeed1)]];
    UILabel *cl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    cl1.text = @"全局1倍";
    cl1.textColor = UIColor.blackColor;
    [c1 addSubview:cl1];
    [bg addSubview:c1];
    
    UIView *a2 = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 120, 80)];
    a2.backgroundColor = [UIColor brownColor];
    [a2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_enterPlayPage)]];
    UILabel *al2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    al2.text = @"跳转详情页";
    al2.textColor = UIColor.blackColor;
    [a2 addSubview:al2];
    [bg addSubview:a2];
    
    UIView *a3 = [[UIView alloc] initWithFrame:CGRectMake(160, 200, 120, 80)];
    a3.backgroundColor = [UIColor brownColor];
    [a3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(djx_chooseEpisode)]];
    UILabel *al3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    al3.text = @"跳转选集面板";
    al3.textColor = UIColor.blackColor;
    [a3 addSubview:al3];
    [bg addSubview:a3];
    return bg;
}
- (void)djx_enterPlayPage {
    [self.vc enterPlayPage];
}
- (void)djx_chooseEpisode {
    [self.vc chooseEpisode];
}
- (void)djx_setEpisodeSpeed1_5 {
    [self.vc setPlaySpeed:1.5 scope:DJXDrawVideoSpeedScopeEpisode];
}
- (void)djx_setShortPlaySpeed0_5 {
    [self.vc setPlaySpeed:0.5 scope:DJXDrawVideoSpeedScopeShortPlay];
}
- (void)djx_setGlobalPlaySpeed3 {
    [DJXPlayletManager.shareInstance setGlobalPlaySpeed:3];
}
- (void)djx_setEpisodeSpeed0_5 {
    [self.vc setPlaySpeed:0.5 scope:DJXDrawVideoSpeedScopeEpisode];
}
- (void)djx_setShortPlaySpeed1_5 {
    [self.vc setPlaySpeed:1.5 scope:DJXDrawVideoSpeedScopeShortPlay];
}
- (void)djx_setGlobalPlaySpeed1 {
    [DJXPlayletManager.shareInstance setGlobalPlaySpeed:1];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(nonnull DJXPlayletInfoModel *)playletInfo {
    
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView {
    customView.frame = CGRectMake(20, 300, 400, 400);
}

- (UIView *)drawVideoVCBottomBannerView:(UIViewController *)vc {
    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    banner.backgroundColor = [UIColor yellowColor];
    return banner;
}

- (UIView *)playletDetailBottomBanner {
    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    banner.backgroundColor = [UIColor blueColor];
    return banner;
}

#else
@implementation LCSPlayletMainViewController
#endif
@end
