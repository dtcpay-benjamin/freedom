//
//  LCSMeInfoViewController.m
//  LCDSamples
//
//  Created by 崔亚楠 on 2021/9/26.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSMeInfoViewController.h"
#import <LCDSDK/LCDSDK.h>
#import "UIImageView+WebCache.h"

@interface LCSMeInfoViewController ()
@property (nonatomic, strong) LCDNativeAccessUserInfo *userInfo;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *headIconView;
@property (nonatomic, strong) UILabel *nickNameLable;
@property (nonatomic, strong) UILabel *totalLikeCountLabel;
@property (nonatomic, strong) UILabel *totalFollowCountLabel;

@end

@implementation LCSMeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.userInfo = [[LCDNativeAccessUserInfo alloc] init];
    [self buildSubViews];
    [self loadDataAction];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bgView.frame = CGRectMake(0, LCS_navBarHeight+20, self.view.lcs_width, 139);
    self.headIconView.frame = CGRectMake(12,LCS_navBarHeight+25, 60, 60);
    self.nickNameLable.frame = CGRectMake(self.headIconView.lcs_right + 12, LCS_navBarHeight+35, self.view.lcs_width, 40);
    self.totalLikeCountLabel.frame = CGRectMake(0,self.bgView.lcs_bottom, self.view.lcs_width/2, 20);
    self.totalFollowCountLabel.frame = CGRectMake(self.view.lcs_width/2,self.bgView.lcs_bottom, self.view.lcs_width/2, 20);
}

- (void)loadDataAction {
    lcs_weakify(self)
    [LCDNativeAccessUserInfoLoadManager loadAccessUserInfoCompletion:^(LCDNativeAccessUserInfo * _Nullable accessUserInfo, NSError * _Nullable error) {
        lcs_strongify(self)
        if (accessUserInfo) {
            [self updateInfoWithUserInfo:accessUserInfo];
        }
    }];
}

- (void)updateInfoWithUserInfo:(LCDNativeAccessUserInfo*)userInfo {
    if (userInfo.bgImageUrl.length) {
        [self.bgView sd_setImageWithURL:[NSURL URLWithString:userInfo.bgImageUrl]];
    }
    if (userInfo.headIconUrl.length) {
        [self.headIconView sd_setImageWithURL:[NSURL URLWithString:userInfo.headIconUrl]];
    }
    if (userInfo.nickName.length) {
        [self.nickNameLable setText:userInfo.nickName];
    }
    if (userInfo.totaDiggCount) {
        [self.totalLikeCountLabel setText:[NSString stringWithFormat:@"喜欢 %ld",(long)userInfo.totaDiggCount]];
    }
    if (userInfo.totalFollowingCount) {
        [self.totalFollowCountLabel setText:[NSString stringWithFormat:@"关注 %ld",(long)userInfo.totalFollowingCount]];
    }
}

- (void)buildSubViews {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.headIconView];
    [self.view addSubview:self.nickNameLable];
    [self.view addSubview:self.totalLikeCountLabel];
    [self.view addSubview:self.totalFollowCountLabel];
}

#pragma mark setter&&getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.backgroundColor = [UIColor grayColor];
        [_bgView setImage:self.userInfo.defaultBgImage];
    }
    return _bgView;
}

- (UIImageView *)headIconView {
    if (!_headIconView) {
        _headIconView = [UIImageView new];
        [_headIconView setImage:self.userInfo.defaultHeadIcon];
        _headIconView.layer.cornerRadius = 30;
        _headIconView.layer.borderWidth = 3;
        _headIconView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headIconView.clipsToBounds = YES;
    }
    return _headIconView;
}

- (UILabel *)nickNameLable {
    if (!_nickNameLable) {
        _nickNameLable = [UILabel new];
        _nickNameLable.font = [UIFont systemFontOfSize:20];
        _nickNameLable.textColor = [UIColor whiteColor];
        _nickNameLable.text = self.userInfo.defaultNickName;
        _nickNameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLable;
}

- (UILabel *)totalLikeCountLabel {
    if (!_totalLikeCountLabel) {
        _totalLikeCountLabel = [UILabel new];
        _totalLikeCountLabel.font = [UIFont systemFontOfSize:15];
        _totalLikeCountLabel.textColor = [UIColor grayColor];
        _totalLikeCountLabel.textAlignment = NSTextAlignmentCenter;
        _totalLikeCountLabel.text = @"喜欢 0";
    }
    return _totalLikeCountLabel;
}

- (UILabel *)totalFollowCountLabel {
    if (!_totalFollowCountLabel) {
        _totalFollowCountLabel = [UILabel new];
        _totalFollowCountLabel.font = [UIFont systemFontOfSize:15];
        _totalFollowCountLabel.textColor = [UIColor grayColor];
        _totalFollowCountLabel.textAlignment = NSTextAlignmentCenter;
        _totalFollowCountLabel.text = @"关注 0";
    }
    return _totalFollowCountLabel;
}


@end
