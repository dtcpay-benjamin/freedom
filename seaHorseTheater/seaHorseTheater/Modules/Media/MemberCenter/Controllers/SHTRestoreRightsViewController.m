//
//  SHTRestoreRightsViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/7.
//

#import "SHTRestoreRightsViewController.h"
#import "SHTSubscriptionManager.h"
#import <Masonry/Masonry.h>

@interface SHTRestoreRightsViewController ()

@property (nonatomic, strong) UILabel *titleLabel; // 恢复权益声明（标题）

@property (nonatomic, strong) UILabel *descLabel; // 正文内容

@property (nonatomic, strong) UIButton *recoverButton; // 红色按钮

@end

@implementation SHTRestoreRightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR_DARK;
    self.title = @"会员未到账";
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setupSubViewsLayouts];
}

- (void)setupUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.recoverButton];
}

- (void)setupSubViewsLayouts {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    [self.recoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Actions

- (void)recoverAction {
    // 调用恢复购买方法
    NSLog(@"点击恢复权益");
    [[SHTSubscriptionManager sharedManager] restorePurchases];
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"恢复权益声明";
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = SHT_BACK_COLOR_DARK;
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"1. 成功支付了会员套餐但权益未及时到账，可以选择恢复权益\n\n2. 恢复权益操作为刷新流程，苹果不会重新扣费\n\n3. 恢复权益操作通常需要一定的处理时间，若在点击恢复权益后未及时生效，请稍后进入我的 VIP 页面查看\n\n点击下方按钮尝试恢复权益";
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = [UIColor darkGrayColor];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recoverButton setTitle:@"恢复权益" forState:UIControlStateNormal];
        [_recoverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _recoverButton.backgroundColor = SHTUIColorFromRGB(232.0, 78.0, 58.0);
        _recoverButton.layer.cornerRadius = 22;
        _recoverButton.clipsToBounds = YES;
        [_recoverButton addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recoverButton;
}

@end
