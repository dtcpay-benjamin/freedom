//
//  SHTMemberTypeView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberTypeView.h"
#import "SHTMemberModel.h"

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
    
}

- (void)addLayoutSubviews {
    
}

- (void)setModel:(SHTMemberModel *)model {
    _model = model;
    
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = SHTUIFontSystem(18);
    }
    return _titleLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = SHTUIColorFromRGB(98.0, 78.0, 41.0);
        _amountLabel.font = SHTUIFontBold(20);
    }
    return _amountLabel;
}

- (UILabel *)originalAmountLabel {
    if (!_originalAmountLabel) {
        _originalAmountLabel = [[UILabel alloc] init];
        _originalAmountLabel.textColor = SHTUIColorFromRGB(146.0, 146.0, 146.0);
        _originalAmountLabel.font = SHTUIFontSystem(16);
    }
    return _originalAmountLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = SHTUIColorFromRGB(91.0, 74.0, 41.0);
        _subtitleLabel.font = SHTUIFontSystem(15);
    }
    return _subtitleLabel;
}
@end
