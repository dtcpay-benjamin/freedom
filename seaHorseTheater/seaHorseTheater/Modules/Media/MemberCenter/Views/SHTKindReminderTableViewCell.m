//
//  SHTKindReminderTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/9.
//

#import "SHTKindReminderTableViewCell.h"
#import <Masonry/Masonry.h>

@interface SHTKindReminderTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *contentLabel; // 内容

@end

@implementation SHTKindReminderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(22);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(135);
    }];
}

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = _content;
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SHTUIColorFromRGB(150, 146, 128);
        _titleLabel.font = SHTUIFontBold(20);
        _titleLabel.text = @"温馨提示";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.font = SHTUIFontSystem(14);
        _contentLabel.textColor = SHTUIColorFromRGB(98, 93, 82);
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
