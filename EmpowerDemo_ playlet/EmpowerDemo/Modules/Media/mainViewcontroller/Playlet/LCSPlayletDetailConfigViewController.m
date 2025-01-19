//
//  LCSPlayletDetailConfigViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/10/10.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSPlayletDetailConfigViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>

@interface LCSPlayletDetailConfigViewController () <DJXPlayletInterfaceProtocol>

@property (nonatomic) DJXPlayletConfig *defaultConfig;

@property (nonatomic) UIButton *enterButton;

@property (nonatomic) NSInteger freeCount;

@property (nonatomic) NSInteger unlockCountPerAD;

@property (nonatomic) DJXPlayletUnlockModeType unlockModeType;

@property (nonatomic) DJXPlayletUnlockADModeOptions playletUnlockADMode;

@end

@implementation LCSPlayletDetailConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    self.unlockModeType = DJXPlayletUnlockModeType_Default;
    self.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    UIView *hideBackButton = [self lineView:0 title:@"隐藏返回按钮" tag:1];
    [scrollView addSubview:hideBackButton];
    
    UIView *hideTopInfo = [self lineView:50 title:@"隐藏左上角第几集" tag:2];
    [scrollView addSubview:hideTopInfo];
    
    UIView *hideMoreButton = [self lineView:100 title:@"隐藏右上角更多按钮" tag:3];
    [scrollView addSubview:hideMoreButton];
    
    UIView *hideBottomInfo = [self lineView:150 title:@"隐藏底部信息" tag:4];
    [scrollView addSubview:hideBottomInfo];
    
    UIView *hideRewardDialog = [self lineView:200 title:@"不显示激励广告确认弹框" tag:5];
    [scrollView addSubview:hideRewardDialog];
    
    UIView *hidelike = [self lineView:250 title:@"隐藏点赞" tag:6];
    [scrollView addSubview:hidelike];
    
    UIView *hideCollect = [self lineView:300 title:@"隐藏收藏" tag:7];
    [scrollView addSubview:hideCollect];

    UIView *disableDoubleClickLike = [self lineView:350 title:@"禁用双击点赞" tag:8];
    [scrollView addSubview:disableDoubleClickLike];
    
    UIView *continueUnlock = [self lineView:400 title:@"是否连续解锁" tag:9];
    [scrollView addSubview:continueUnlock];
    
    UIView *playletUnlockADMode = [self lineView:450 title:@"是否开发者自定义广告" tag:10];
    [scrollView addSubview:playletUnlockADMode];
    
    UIView *disableLongPressSpeed = [self lineView:500 title:@"禁用长按倍速" tag:11];
    [scrollView addSubview:disableLongPressSpeed];

    [scrollView addSubview:self.enterButton];
}

- (UIView *)lineView:(CGFloat)y title:(NSString *)title tag:(NSInteger)tag {
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 48)];
    
    UILabel *l = [[UILabel alloc] init];
    l.text = title;
    [l sizeToFit];
    l.frame = CGRectMake(20, (48 - l.frame.size.height) / 2, l.frame.size.width, l.frame.size.height);
    [c addSubview:l];
    
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectZero];
    s.frame = CGRectMake(self.view.frame.size.width - 20 - s.frame.size.width, (48 - s.frame.size.height) / 2, s.frame.size.width, s.frame.size.height);
    s.tag = tag;
    [s addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    [c addSubview:s];
    
    return c;
}

- (void)onChange:(UISwitch *)sender {
    if (sender.tag == 1) {
        self.defaultConfig.hideBackButton = sender.isOn;
    } else if (sender.tag == 2) {
        self.defaultConfig.hideTopInfo = sender.isOn;
    } else if (sender.tag == 3) {
        self.defaultConfig.hideMoreButton = sender.isOn;
    } else if (sender.tag == 4) {
        self.defaultConfig.hideBottomInfo = sender.isOn;
    } else if (sender.tag == 5) {
        self.defaultConfig.hideRewardDialog = sender.isOn;
    } else if (sender.tag == 6) {
        self.defaultConfig.hideLikeIcon = sender.isOn;
    } else if (sender.tag == 7) {
        self.defaultConfig.hideCollectIcon = sender.isOn;
    } else if (sender.tag == 8) {
        self.defaultConfig.disableDoubleClickLike = sender.isOn;
    } else if (sender.tag == 9) {
        self.unlockModeType = sender.isOn ? DJXPlayletUnlockModeType_Continuous : DJXPlayletUnlockModeType_Default;
    } else if (sender.tag == 10) {
        self.playletUnlockADMode = sender.isOn ? DJXPlayletUnlockADMode_Specific : DJXPlayletUnlockADMode_Common;
    } else if (sender.tag == 11) {
        self.defaultConfig.disableLongPressSpeed = sender.isOn;
    }
}

- (DJXPlayletConfig *)defaultConfig {
    if (!_defaultConfig) {
        _defaultConfig = [[DJXPlayletConfig alloc] init];
        _defaultConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Specific;
        _defaultConfig.interfaceDelegate = self;
    }
    return _defaultConfig;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _enterButton.frame = CGRectMake(20, 600, self.view.frame.size.width - 40, 48);
        [_enterButton setTitle:@"进入" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(onClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (void)onClickEnterButton:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"广告解锁" message:@"免费集数 & 广告解锁集数" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *freeCountTextField;
    [actionSheet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"5";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        freeCountTextField = textField;
    }];
    __block UITextField *freeADTextField;
    [actionSheet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"5";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        freeADTextField = textField;
    }];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.freeCount = [freeCountTextField.text integerValue];
        self.unlockCountPerAD = [freeADTextField.text integerValue];
        DJXPlayletAggregatePageViewController *vc = [[DJXPlayletAggregatePageViewController alloc] initWithConfigBuilder:^(DJXPlayletAggregatePageVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = self.defaultConfig;
            playletConfig.playletUnlockADMode = self.playletUnlockADMode;
            playletConfig.freeEpisodesCount = self.freeCount;
            playletConfig.unlockEpisodesCountUsingAD = self.unlockCountPerAD;
            config.playletConfig = playletConfig;
            config.isShowNavigationItemTitle = YES;
            config.isShowNavigationItemBackButton = YES;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - DJXPlayletInterfaceProtocol

- (void)playletDetailUnlockFlowStart:(DJXPlayletInfoModel *)infoModel unlockInfoHandler:(void (^)(DJXPlayletUnlockModel * _Nonnull))unlockInfoHandler extraInfo:(NSDictionary * _Nullable)extraInfo {
    NSString *lockString = @"剧集解锁状态";
    for (int i= 0;  i < infoModel.lockStatusArray.count; i++) {
        NSNumber *status = infoModel.lockStatusArray[i];
        lockString = [lockString stringByAppendingFormat:@"%@%@集-%@", i == 0 ? @":":@",", @(i+1), status.intValue == 1 ? @"已解锁":@"未解锁"];
    }
    NSLog(@"[短剧解锁开始回调]%@", lockString);
    if ([extraInfo valueForKey:@"isContinuityUnlock"]) {
        //连续解锁逻辑
        NSInteger current_unlock_episode = [[extraInfo valueForKey:@"current_unlock_episode"] integerValue];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"看广告解锁"
                                                                       message:[NSString stringWithFormat:@"看一个激励广告解锁%ld集,\n 再看一次广告解锁%@集-%@集", self.unlockCountPerAD, @(current_unlock_episode), @(current_unlock_episode + self.unlockCountPerAD)]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
            unlockInfo.cancelUnlock = YES;
            unlockInfo.unlockModeType = DJXPlayletUnlockModeType_Continuous;
            unlockInfoHandler(unlockInfo);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"看广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
            unlockInfo.playletId = infoModel.shortplay_id;
            unlockInfo.unlockEpisodeCount = self.unlockCountPerAD;
            unlockInfo.unlockModeType = DJXPlayletUnlockModeType_Continuous;
            unlockInfoHandler(unlockInfo);
        }]];
        [self.presentedViewController presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"看广告解锁"
                                                                       message:[NSString stringWithFormat:@"看一个激励广告解锁%ld集", self.unlockCountPerAD]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
            unlockInfo.cancelUnlock = YES;
            unlockInfo.unlockModeType = self.unlockModeType;
            unlockInfoHandler(unlockInfo);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"看广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            DJXPlayletUnlockModel *unlockInfo = [[DJXPlayletUnlockModel alloc] init];
            unlockInfo.playletId = infoModel.shortplay_id;
            unlockInfo.unlockEpisodeCount = self.unlockCountPerAD;
            unlockInfo.unlockModeType = self.unlockModeType;
            unlockInfoHandler(unlockInfo);
        }]];
        [self.presentedViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)playletDetailUnlockFlowShowCustomAD:(DJXPlayletInfoModel *)infoModel onADWillShow:(void (^)(NSString * cpm))onADWillShow onADRewardDidVerified:(void (^)(DJXRewardAdResult * _Nonnull))onADRewardDidVerified {
    !onADWillShow ?: onADWillShow(@"1000");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.presentedViewController.view animated:YES];
    hud.label.text = @"模拟开发者激励广告";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.presentedViewController.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"观看广告完成"
                                                                       message:@"是否广告激励完成"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DJXRewardAdResult *result = [[DJXRewardAdResult alloc] init];
            result.success = YES;
            result.cpm = @"80";
            !onADRewardDidVerified ?: onADRewardDidVerified(result);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"未完成" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            DJXRewardAdResult *result = [[DJXRewardAdResult alloc] init];
            result.success = NO;
            result.cpm = @"80";
            !onADRewardDidVerified ?: onADRewardDidVerified(result);
        }]];
        [self.presentedViewController presentViewController:alert animated:YES completion:nil];
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

#else
@interface LCSPlayletDetailConfigViewController ()
#endif
@end
