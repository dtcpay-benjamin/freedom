//
//  LCSPlayletCardDemoViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/5/30.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletCardDemoViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>

@interface LCSPlayletCardDemoViewController () <DJXPlayletCardDelegate, DJXPlayletInterfaceProtocol>

@property (nonatomic) DJXPlayletCard *playletCard;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descLabel;

@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *pauseButton;
@property (nonatomic) UIButton *muteButton;
@property (nonatomic) UIButton *unmuteButton;
@property (nonatomic) UIButton *retryButton;

@property (nonatomic) BOOL playingBeforeEnterBackground;

@property (nonatomic) NSDate *showTime;

@end

@implementation LCSPlayletCardDemoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoplay = YES;
        _mute = YES;
        _loop = YES;
        _hideUI = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
    
    [self.view addSubview:self.playletCard];
    self.showTime = [NSDate date];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
    
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.pauseButton];
    [self.view addSubview:self.muteButton];
    [self.view addSubview:self.unmuteButton];
    [self.view addSubview:self.retryButton];
    
    [self observeApplicationState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.showTime = [NSDate date];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:self.showTime];
    [self.playletCard trackShowWithDuration:duration];
}

- (void)observeApplicationState {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActived:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)onApplicationBecomeActive:(NSNotification *)notification {
    if (self.playingBeforeEnterBackground) {
        [self.playletCard play];
        self.playingBeforeEnterBackground = NO;
    }
}

- (void)onApplicationWillResignActived:(NSNotification *)notification {
    if (self.playletCard.playbackState == DJXPlayletCardPlaybackStatePlaying) {
        self.playingBeforeEnterBackground = YES;
        [self.playletCard pause];
    }
}

#pragma mark - DJXPlayletCardDelegate

- (void)playletCard:(DJXPlayletCard *)playletCard didLoadData:(DJXPlayletInfoModel *)playletData error:(NSError *)error {
    self.titleLabel.text = playletData.title;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.playletCard.frame) + 10, self.playletCard.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.descLabel.text = [NSString stringWithFormat:@"类型:%@\n集数:%ld\n简介:%@", playletData.category_name, playletData.total, playletData.desc];
    [self.descLabel sizeToFit];
    self.descLabel.frame = CGRectMake(CGRectGetMaxX(self.playletCard.frame) + 10, CGRectGetMaxY(self.titleLabel.frame) + 10, self.view.frame.size.width - CGRectGetMaxX(self.playletCard.frame) - 10 - 10, self.playletCard.frame.size.height - self.titleLabel.frame.size.height - 10);
}

- (void)playletCardReadyToDisplay:(DJXPlayletCard *)playletCard {
    NSLog(@"#LCSPlayletCardDemoViewController# %s", __func__);
}

- (void)playletCardReadyToPlay:(DJXPlayletCard *)playletCard {
    NSLog(@"#LCSPlayletCardDemoViewController# %s", __func__);
}

- (void)playletCard:(DJXPlayletCard *)playletCard playbackStateDidChanged:(DJXPlayletCardPlaybackState)playbackState {
    NSLog(@"#LCSPlayletCardDemoViewController# %s", __func__);
}

- (void)playletCardUserStopped:(DJXPlayletCard *)playletCard {
    NSLog(@"#LCSPlayletCardDemoViewController# %s", __func__);
}

- (void)playletCardDidFinish:(DJXPlayletCard *)playletCard error:(NSError *)error videoStatusException:(NSInteger)statusCode {
    NSLog(@"#LCSPlayletCardDemoViewController# %s", __func__);
}

#pragma mark - Getters & Setters

- (DJXPlayletCard *)playletCard {
    if (!_playletCard) {
        _playletCard = [[DJXPlayletCard alloc] initWithConfig:^(DJXPlayletCardConfig * _Nonnull cardConfig) {
            cardConfig.skit_id = self.skit_id;
            cardConfig.frame = CGRectMake(10, 200, self.cardWith, 200);
            cardConfig.mute = self.mute;
            cardConfig.loop = self.loop;
            cardConfig.hideActionUI = self.hideUI;
            cardConfig.autoPlay = self.autoplay;
            cardConfig.hidePlayButton = self.hidePlayButton;
            cardConfig.hideMuteButton = self.hideMuteButton;
        }];
        _playletCard.delegate = self;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPlayletCard:)];
        [_playletCard addGestureRecognizer:tapGestureRecognizer];
    }
    return _playletCard;
}

- (void)onTapPlayletCard:(UITapGestureRecognizer *)sender {
    UIViewController *c = [[UIViewController alloc] init];
    DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
        playletConfig.freeEpisodesCount = 5;
        playletConfig.unlockEpisodesCountUsingAD = 5;
        playletConfig.interfaceDelegate = self;
        playletConfig.skitId = self.playletCard.playletInfo.shortplay_id;
        playletConfig.episode = 1;
        playletConfig.hideRewardDialog = YES;
        playletConfig.hideMoreButton = YES;
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet;
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
        config.inner_playPlet_bottomOffset = 20;
        config.from_page = @"card";
    }];
    [c.view addSubview:vc.view];
    [c addChildViewController:vc];
    c.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:c animated:YES completion:^{}];
}

- (void)playletDetailUnlockFlowStart:(DJXPlayletInfoModel *)infoModel unlockInfoHandler:(void (^)(DJXPlayletUnlockModel * _Nonnull))unlockInfoHandler extraInfo:(NSDictionary * _Nullable)extraInfo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"看广告解锁"
                                                                   message:[NSString stringWithFormat:@"看一个激励广告解锁%d集", 5]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
        unlockInfo.cancelUnlock = YES;
        unlockInfoHandler(unlockInfo);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"看广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
        unlockInfo.playletId = infoModel.shortplay_id;
        unlockInfo.unlockEpisodeCount = 5;
        unlockInfoHandler(unlockInfo);
    }]];
    [self.presentedViewController presentViewController:alert animated:YES completion:nil];
}

- (void)playletDetailUnlockFlowShowCustomAD:(DJXPlayletInfoModel *)infoModel onADWillShow:(void (^)(NSString * cpm))onADWillShow onADRewardDidVerified:(void (^)(DJXRewardAdResult * _Nonnull))onADRewardDidVerified {
    !onADWillShow ?: onADWillShow(@"1000");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.presentedViewController.view animated:YES];
    hud.label.text = @"模拟开发者激励广告";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.presentedViewController.view animated:YES];
        DJXRewardAdResult *result = [[DJXRewardAdResult alloc] init];
        result.success = YES;
        result.cpm = @"80";
        !onADRewardDidVerified ?: onADRewardDidVerified(result);
    });
}

- (void)playletDetailUnlockFlowEnd:(DJXPlayletInfoModel *)infoModel success:(BOOL)success error:(NSError *)error extraInfo:(NSDictionary * _Nullable)extraInfo {
    if (success) {
        NSLog(@"《%@》解锁成功", infoModel.title);
    } else if (error.code == DJXPlayletUnlockResult_Request_Error) {
        NSLog(@"《%@》解锁时发生网络错误", infoModel.title);
    } else if (error.code == DJXPlayletUnlockResult_AD_Not_Show) {
        NSLog(@"《%@》广告未展示", infoModel.title);
    } else {
        NSLog(@"《%@》未知错误", infoModel.title);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        if (@available(iOS 13.0, *)) {
            _titleLabel.textColor = UIColor.labelColor;
        }
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        if (@available(iOS 13.0, *)) {
            _descLabel.textColor = UIColor.labelColor;
        }
    }
    return _descLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [self createButton:@"播放" frame:CGRectMake(10, CGRectGetMaxY(self.playletCard.frame) + 20, (self.view.frame.size.width - 30) / 2, 48)];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [self createButton:@"暂停" frame:CGRectMake(self.view.frame.size.width / 2 + 5, CGRectGetMaxY(self.playletCard.frame) + 20, (self.view.frame.size.width - 30) / 2, 48)];
    }
    return _pauseButton;
}

- (UIButton *)muteButton {
    if (!_muteButton) {
        _muteButton = [self createButton:@"静音" frame:CGRectMake(10, CGRectGetMaxY(self.playButton.frame) + 10, (self.view.frame.size.width - 30) / 2, 48)];
    }
    return _muteButton;
}

- (UIButton *)unmuteButton {
    if (!_unmuteButton) {
        _unmuteButton = [self createButton:@"取消静音" frame:CGRectMake(self.view.frame.size.width / 2 + 5, CGRectGetMaxY(self.playButton.frame) + 10, (self.view.frame.size.width - 30) / 2, 48)];
    }
    return _unmuteButton;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [self createButton:@"重新加载" frame:CGRectMake(10, CGRectGetMaxY(self.muteButton.frame) + 10, (self.view.frame.size.width - 30) / 2, 48)];
    }
    return _retryButton;
}

- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
    button.backgroundColor = UIColor.systemBlueColor;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)onTapButton:(UIButton *)sender {
    if (sender == self.playButton) {
        [self.playletCard play];
    } else if (sender == self.pauseButton) {
        [self.playletCard pause];
    } else if (sender == self.muteButton) {
        [self.playletCard setMuted:YES];
    } else if (sender == self.unmuteButton) {
        [self.playletCard setMuted:NO];
    } else if (sender == self.retryButton) {
        [self.playletCard retryLoadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#else
@implementation LCSPlayletCardDemoViewController
#endif
@end
