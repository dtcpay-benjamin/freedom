//
//  SHTBriefIntroductionTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/30.
//

#import "SHTBriefIntroductionTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SHTBriefIntroductionModel.h"

@interface SHTBriefIntroductionTableViewCell()

@property (nonatomic, strong) UIView *backView; // 背景视图
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *vipStatusLabel; // vip开通状态

@end

@implementation SHTBriefIntroductionTableViewCell


- (void)addSubviews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.vipStatusLabel];
}

- (void)addLayoutSubviews {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(20);
        make.leading.equalTo(self.backView.mas_leading).offset(12);
        make.height.mas_equalTo(22);
    }];
    [self.vipStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.backView.mas_leading).offset(12);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-20);
    }];
}

#pragma mark - actions

- (void)setModel:(SHTBriefIntroductionModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.vipStatusLabel.text = model.subtitle;
}

#pragma mark - 懒加载

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SHTUIColorFromRGB(192, 168, 123);
        _backView.layer.cornerRadius = 10.0;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SHTUIColorFromRGB(139, 88, 41);
        _titleLabel.font = SHTUIFontBold(20);
    }
    return _titleLabel;
}

- (UILabel *)vipStatusLabel {
    if (!_vipStatusLabel) {
        _vipStatusLabel = [[UILabel alloc] init];
        _vipStatusLabel.textColor = SHTUIColorFromRGB(94, 64, 22);
        _vipStatusLabel.font = SHTUIFontSystem(18);
    }
    return _vipStatusLabel;
}

@end
