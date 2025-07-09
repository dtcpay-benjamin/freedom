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
@property (nonatomic, strong) UITextView *contentTextView; // 内容

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
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(300);
    }];
}

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentTextView];
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentTextView.text = _content;
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

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentTextView.font = SHTUIFontSystem(14);
        _contentTextView.textColor = SHTUIColorFromRGB(98, 93, 82);
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = NO;
    }
    return _contentTextView;
}

@end
