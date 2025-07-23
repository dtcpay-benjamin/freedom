//
//  SHTOpenMemberAccountTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 7/23/25.
//

#import "SHTOpenMemberAccountCell.h"

@interface SHTOpenMemberAccountCell()

@property (nonatomic, strong) UIView *backView; // 背景视图
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *subTitleLabel; // 副标题
@property (nonatomic, strong) UIButton *openBtn; // 开通会员按钮

@end

@implementation SHTOpenMemberAccountCell

- (void)addSubviews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subTitleLabel];
    [self.backView addSubview:self.openBtn];
}

- (void)addLayoutSubviews {
    
}

#pragma mark - actions

- (void)openAction:(UIButton *)sender {
    
}

#pragma mark - 懒加载

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SHT_BACK_COLOR_DARK;
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 12.0;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SHT_BACK_COLOR;
        _titleLabel.font = SHTUIFontBold(30);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = SHT_BACK_COLOR;
        _subTitleLabel.font = SHTUIFontSystem(25);
    }
    return _subTitleLabel;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setTitle:@"开通会员" forState:UIControlStateNormal];
        [_openBtn setTitle:@"开通会员" forState:UIControlStateSelected];
        [_openBtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.layer.masksToBounds = YES;
        _openBtn.layer.cornerRadius = 6.0;
    }
    return _openBtn;
}

@end
