//
//  SHTMemberTypeView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberTypeView.h"
#import "SHTMemberModel.h"
#import <Masonry/Masonry.h>

@interface SHTMemberTypeView()

@property(nonatomic, strong) UILabel *titleLabel; // 标题
@property(nonatomic, strong) UILabel *amountLabel; // 现价
@property(nonatomic, strong) UILabel *originalAmountLabel; // 原价
@property(nonatomic, strong) UILabel *subtitleLabel; // 副标题

@end

@implementation SHTMemberTypeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayoutSubviews];
}

#pragma mark - functions

- (void)addSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.originalAmountLabel];
    [self addSubview:self.subtitleLabel];
}

- (void)addLayoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(22);
    }];
    [self.originalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(20);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(18);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originalAmountLabel.mas_bottom).offset(20);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(17);
    }];
}

- (void)setModel:(SHTMemberModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.amountLabel.text = _model.showAmount;
    self.originalAmountLabel.attributedText = _model.showOriginalAmount;
    self.subtitleLabel.text = _model.subtitle;
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = SHTUIFontSystem(18);
    }
    return _titleLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = SHTUIColorFromRGB(98.0, 78.0, 41.0);
        _amountLabel.font = SHTUIFontBold(20);
    }
    return _amountLabel;
}

- (UILabel *)originalAmountLabel {
    if (!_originalAmountLabel) {
        _originalAmountLabel = [[UILabel alloc] init];
        _originalAmountLabel.textAlignment = NSTextAlignmentCenter;
        _originalAmountLabel.textColor = SHTUIColorFromRGB(146.0, 146.0, 146.0);
        _originalAmountLabel.font = SHTUIFontSystem(16);
    }
    return _originalAmountLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = SHTUIColorFromRGB(91.0, 74.0, 41.0);
        _subtitleLabel.backgroundColor = SHTUIColorFromRGB(240.0, 236.0, 217.0);
        _subtitleLabel.font = SHTUIFontSystem(15);
    }
    return _subtitleLabel;
}

@end
