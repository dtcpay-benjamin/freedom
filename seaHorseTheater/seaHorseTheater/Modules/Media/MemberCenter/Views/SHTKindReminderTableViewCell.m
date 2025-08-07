//
//  SHTKindReminderTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/9.
//

#import "SHTKindReminderTableViewCell.h"
#import <Masonry/Masonry.h>

@interface SHTKindReminderTableViewCell()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel; // 标题

@property (nonatomic, strong) UITextView *reminderTextView;  // 内容

@end

@implementation SHTKindReminderTableViewCell

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.reminderTextView];
}

- (void)addLayoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(22);
    }];
    [self.reminderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(135);
    }];
}


- (void)setContent:(NSString *)content {
    _content = content;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_content];

    UIFont *font = SHTUIFontSystem(14);
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _content.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:SHTUIColorFromRGB(98, 93, 82) range:NSMakeRange(0, _content.length)];

    // 设置可点击的“恢复权益”部分
    NSRange restoreRange = [_content rangeOfString:@"【恢复权益】"];
    if (restoreRange.location != NSNotFound) {
        NSURL *url = [NSURL URLWithString:@"action://restore"];
        [attrString addAttribute:NSLinkAttributeName value:url range:restoreRange];
    }

    self.reminderTextView.attributedText = attrString;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
        inRange:(NSRange)characterRange
    interaction:(UITextItemInteraction)interaction {
    if ([URL.scheme isEqualToString:@"action"] && [URL.host isEqualToString:@"restore"]) {
        // 点击恢复权益，执行跳转操作
        if (self.restoreAction) {
            self.restoreAction();
        }
        return NO;
    }
    return YES;
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

- (UITextView *)reminderTextView {
    if (!_reminderTextView) {
        _reminderTextView = [[UITextView alloc] init];
        _reminderTextView.font = SHTUIFontSystem(14);
        _reminderTextView.textColor = SHTUIColorFromRGB(98, 93, 82);
        _reminderTextView.editable = NO;
        _reminderTextView.scrollEnabled = NO;
        _reminderTextView.backgroundColor = [UIColor clearColor];
        _reminderTextView.textContainerInset = UIEdgeInsetsZero;
        _reminderTextView.textContainer.lineFragmentPadding = 0;
        _reminderTextView.delegate = self;
        _reminderTextView.linkTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor systemBlueColor],
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
        };
    }
    return _reminderTextView;
}

@end
