//
//  LCSPlayletMixViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2023/4/23.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletMixViewController.h"

#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>

@interface LCSPlayletMixViewController () <DJXAdvertCallBackProtocol, DJXPlayletAdvertProtocol, DJXPlayletPlayerProtocol, DJXPlayletInterfaceProtocol, DJXDrawVideoViewControllerDelegate, DJXDrawVideoViewControllerDelegate, DJXDrawVideoCellAddSubviewDelegate>

@property (nonatomic, strong) UITextField *nTextField;

@property (nonatomic, strong) UITextField *mTextField;

@property (nonatomic, strong) UITextField *freeTextField;

@property (nonatomic, strong) UITextField *topTextField;

@end

@implementation LCSPlayletMixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, LCSScreenHeight - LCS_tabBarHeight - 200, LCSScreenWidth * 0.25, 50)];
    self.nTextField.placeholder = @"播放免费集数";
    self.nTextField.font = [UIFont systemFontOfSize:14];
    [self.tableView addSubview:self.nTextField];
    
    self.mTextField = [[UITextField alloc] initWithFrame:CGRectMake(LCSScreenWidth * 0.25, LCSScreenHeight - LCS_tabBarHeight - 200, LCSScreenWidth * 0.25, 50)];
    self.mTextField.placeholder = @"单次解锁集数";
    self.mTextField.font = [UIFont systemFontOfSize:14];
    [self.tableView addSubview:self.mTextField];
    
    self.freeTextField = [[UITextField alloc] initWithFrame:CGRectMake(LCSScreenWidth * 0.5, LCSScreenHeight - LCS_tabBarHeight - 200, LCSScreenWidth * 0.25, 50)];
    self.freeTextField.placeholder = @"混排免费集数";
    self.freeTextField.font = [UIFont systemFontOfSize:14];
    [self.tableView addSubview:self.freeTextField];
    
    self.topTextField = [[UITextField alloc] initWithFrame:CGRectMake(LCSScreenWidth * 0.75, LCSScreenHeight - LCS_tabBarHeight - 200, LCSScreenWidth * 0.25, 50)];
    self.topTextField.placeholder = @"混排首部短剧";
    self.topTextField.font = [UIFont systemFontOfSize:14];
    [self.tableView addSubview:self.topTextField];
}

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *playletMix = [LCSActionModel plainTitleActionModel:@"纯短剧混排(SDK广告)" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = [self.nTextField.text integerValue] ?: 0;
            playletConfig.unlockEpisodesCountUsingAD = [self.mTextField.text integerValue] ?: 0;
            playletConfig.adDelegate = self;
            playletConfig.playerDelegate = self;
            playletConfig.interfaceDelegate = self;
            
            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed | DJXDrawVideoVCTabOptions_theater;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.showCloseButton = YES;
            config.delegate = self;
            config.drawVideoCellAddSubviewDelegate = self;
            config.playletFreeCount = [self.freeTextField.text integerValue] ?: 0;
            config.topSkitId = [self.topTextField.text integerValue] ?: 0;
            config.hiddenPlayletEnterView = YES;
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *playletMixInterface = [LCSActionModel plainTitleActionModel:@"纯短剧混排(自定义广告)" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
            playletConfig.adDelegate = self;
            playletConfig.playerDelegate = self;
            playletConfig.interfaceDelegate = self;

            config.playletConfig = playletConfig;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
            config.shouldHideTabBarView = YES;
            config.showCloseButton = YES;
            config.delegate = self;
            config.playletFreeCount = [self.freeTextField.text integerValue] ?: 0;
            config.topSkitId = [self.topTextField.text integerValue] ?: 0;
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];  
    
    self.items = @[
        @[playletMix,
          playletMixInterface],
    ];
}

- (UIView *)djx_drawVideoCellSubview:(UITableViewCell *)cell {
    UIView *x = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    x.backgroundColor = [UIColor yellowColor];
    UILabel *l = [[UILabel alloc] init];
    l.textColor = [UIColor redColor];
    [x addSubview:l];
    return x;
}

- (void)djx_drawVideoCell:(UITableViewCell *)cell updateSubview:(UIView *)subview withData:(DJXPlayletInfoModel *)playletInfoModel {
    UILabel *l = subview.subviews.firstObject;
    l.text = playletInfoModel.title;
    [l sizeToFit];
}

#pragma mark 短剧回调

//播放器回调（通用）
- (void)drawVideoStartPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, config.shortplay_id, config.title, config.current_episode);
}

- (void)drawVideoContinue:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, config.shortplay_id, config.title, config.current_episode);
}

- (void)drawVideoOverPlay:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, config.shortplay_id, config.title, config.current_episode);
}

- (void)drawVideoPause:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, config.shortplay_id, config.title, config.current_episode);
}

- (void)drawVideoPlayCompletion:(nonnull UIViewController *)viewController config:(nonnull DJXPlayletInfoModel *)config {
    NSLog(@"[短剧回调]播放器回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, config.shortplay_id, config.title, config.current_episode);
}

- (void)onVideSeekToTime:(NSTimeInterval)endTime inPosition:(NSInteger)position {
    NSLog(@"[短剧回调]播放器回调 %s", __func__);
}

- (void)drawVideo:(UIViewController *)viewController config:(DJXPlayletInfoModel *)config progress:(CGFloat)progress {
    NSLog(@"[短剧回调]播放器回调 %s progress:%f", __func__, progress);
}

//广告回调（封装形式）
- (void)djxSendAdRequest:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxAdLoadSuccess:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxAdLoadFail:(DJXAdTrackEvent *)event error:(NSError *)error {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxAdFillFail:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxAdWillShow:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoAdStartPlay:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoAdPause:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoAdContinue:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoAdOverPlay:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxClickAdViewEvent:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoBufferEvent:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoRewardFinishEvent:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)djxVideoRewardSkipEvent:(DJXAdTrackEvent *)event {
    NSLog(@"[短剧回调]广告回调 %s", __func__);
}

- (void)nextPlayletWillPlay:(nonnull DJXPlayletInfoModel *)infoModel {
    NSLog(@"[短剧回调]接口回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, infoModel.shortplay_id, infoModel.title, infoModel.current_episode);
}

- (void)clickEnterView:(nonnull DJXPlayletInfoModel *)infoModel {
    NSLog(@"[短剧回调]接口回调 %s skitID:%ld skitName:%@ episode:%ld", __func__, infoModel.shortplay_id, infoModel.title, infoModel.current_episode);
    
    if (infoModel) {
        DJXPlayletConfig *config = [DJXPlayletConfig new];
        config.skitId = infoModel.shortplay_id;
        config.episode = infoModel.current_episode + 1;
        config.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
        config.playerDelegate = self;
        config.infoModel = infoModel;
        
        DJXDrawVideoViewController *vc = [[DJXPlayletManager shareInstance] playletViewControllerWithParams:config];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController performSelector:@selector(djx_topViewController)] presentViewController:vc animated:YES completion:nil];
    }
}

#else
@interface LCSPlayletMixViewController ()
#endif
@end
