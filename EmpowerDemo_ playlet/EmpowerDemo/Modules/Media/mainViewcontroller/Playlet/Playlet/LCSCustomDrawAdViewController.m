//
//  LCSCustomDrawAdViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2024/3/6.
//  Copyright © 2024 bytedance. All rights reserved.
//

#import "LCSCustomDrawAdViewController.h"
#import "LCSChooseAdIndexCollectionViewController.h"

#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXDrawVideoViewController.h>
#import <PangrowthDJX/DJXPlayletProtocol.h>
@interface LCSCustomDrawAdViewController () <DJXShortplayDetailDrawAdDelegate>

@property (nonatomic) UILabel *indexResultLabel;

@property (nonatomic) UIButton *chooseIndexButton;

@property (nonatomic) UIButton *customAdButton;

@property (nonatomic, copy) NSArray<NSNumber *> *customAdIndex;

@end

@implementation LCSCustomDrawAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    self.customAdIndex = @[@1, @3];
    [self.view addSubview:self.indexResultLabel];
    [self.view addSubview:self.chooseIndexButton];
    [self.view addSubview:self.customAdButton];
}

- (UILabel *)indexResultLabel {
    if (!_indexResultLabel) {
        _indexResultLabel = [[UILabel alloc] init];
        _indexResultLabel.frame = CGRectMake(20, (self.view.frame.size.height - 48) / 2 - 150, self.view.frame.size.width - 40, 48);
        _indexResultLabel.text = [NSString stringWithFormat:@"[%@]", [self.customAdIndex componentsJoinedByString:@","]];
        _indexResultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexResultLabel;
}

- (UIButton *)chooseIndexButton {
    if (!_chooseIndexButton) {
        _chooseIndexButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _chooseIndexButton.frame = CGRectMake(20, (self.view.frame.size.height - 48) / 2 - 50, self.view.frame.size.width - 40, 48);
        [_chooseIndexButton setTitle:@"选择广告位置" forState:UIControlStateNormal];
        [_chooseIndexButton addTarget:self action:@selector(onClickChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseIndexButton;
}

- (void)onClickChooseAction:(UIButton *)sender {
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    LCSChooseAdIndexCollectionViewController *vc = [[LCSChooseAdIndexCollectionViewController alloc] initWithCollectionViewLayout:layout];
    vc.selectBlock = ^(NSArray<NSNumber *> * _Nonnull selectedIndex) {
        self.customAdIndex = selectedIndex;
        self.indexResultLabel.text = [NSString stringWithFormat:@"[%@]", [self.customAdIndex componentsJoinedByString:@","]];
    };
    [self presentViewController:vc animated:vc completion:nil];
}

- (UIButton *)customAdButton {
    if (!_customAdButton) {
        _customAdButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _customAdButton.frame = CGRectMake(20, (self.view.frame.size.height - 48) / 2, self.view.frame.size.width - 40, 48);
        [_customAdButton setTitle:@"进入短剧播放详情页" forState:UIControlStateNormal];
        [_customAdButton addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customAdButton;
}

- (void)onClickAction:(UIButton *)sender {
    DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 10;
        playletConfig.unlockEpisodesCountUsingAD = 5;
        playletConfig.customAdIndex = self.customAdIndex;
        playletConfig.customDrawAdViewDelegate = self;

        config.playletConfig = playletConfig;
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_theater | DJXDrawVideoVCTabOptions_playlet_feed;
        config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight);
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{}];
}

- (UIView *)djx_shortplayDetailCellCreateAdView:(UITableViewCell *)cell adInputIndex:(NSUInteger)adIndex {
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    UILabel *x = [[UILabel alloc] init];
    x.text = @"这里是广告演示";
    [adView addSubview:x];
    return adView;
}

- (void)djx_shortplayDetailCell:(UITableViewCell *)cell bindDataToDrawAdView:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex {
    if ([drawAdView.subviews.firstObject isKindOfClass:[UILabel class]]) {
        UILabel *x = drawAdView.subviews.firstObject;
        x.text = [NSString stringWithFormat:@"广告 %ld", adIndex];
        [x sizeToFit];
    }
}

- (void)djx_shortplayDetailCell:(UITableViewCell *)cell layoutSubview:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex {
    drawAdView.frame = cell.contentView.bounds;
    if ([drawAdView.subviews.firstObject isKindOfClass:[UILabel class]]) {
        UILabel *x = drawAdView.subviews.firstObject;
        x.frame = CGRectMake((drawAdView.frame.size.width - x.frame.size.width) / 2, (drawAdView.frame.size.height - x.frame.size.height) / 2, x.frame.size.width, x.frame.size.height);
    }
}

#else
@interface LCSCustomDrawAdViewController ()
#endif
@end
