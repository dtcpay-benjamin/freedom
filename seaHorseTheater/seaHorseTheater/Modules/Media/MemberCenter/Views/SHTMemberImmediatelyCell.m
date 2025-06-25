//
//  SHTMemberImmediatelyCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/23.
//

#import "SHTMemberImmediatelyCell.h"
#import <Masonry/Masonry.h>

@interface SHTMemberImmediatelyCell()

@property (nonatomic, strong) UIButton *immediatelyBtn; // 开通按钮
@property (nonatomic, strong) UIButton *radioButton; // 阅读单选按钮
@property (nonatomic, strong) UILabel *agreementTextLabel; // 引导阅读协议文本

@end

@implementation SHTMemberImmediatelyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayoutSubviews];
}

- (void)addSubviews {
    [self.contentView addSubview:self.immediatelyBtn];
    [self.contentView addSubview:self.radioButton];
    [self.contentView addSubview:self.agreementTextLabel];
}


- (void)addLayoutSubviews {
    [self.immediatelyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(30);
        make.trailing.equalTo(self).offset(-30);
        make.height.mas_equalTo(60);
    }];
    
    [self.radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.immediatelyBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.immediatelyBtn.mas_leading).offset(6);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    [self.agreementTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.radioButton);
        make.leading.equalTo(self.radioButton.mas_trailing).offset(6);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark - actions

// 立即开通
- (void)immediatelyAction:(UIButton *)sender {
    if (self.memberImmediatelyOnTapped) {
        self.memberImmediatelyOnTapped();
    }
}

// 选择阅读协议
- (void)radioAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.radioOnTapped) {
        self.radioOnTapped(sender.isSelected);
    }
}

// 会员服务协议点击跳转
- (void)serviceAgreementHandleTapOn:(UITapGestureRecognizer *)tap {
    if (self.serviceAgreementOnTapped) {
        self.serviceAgreementOnTapped();
    }
}

#pragma mark - 懒加载

- (UIButton *)immediatelyBtn {
    if (!_immediatelyBtn) {
        _immediatelyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_immediatelyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [_immediatelyBtn setTitle:@"立即开通" forState:UIControlStateSelected];
        [_immediatelyBtn setTitleColor:SHTUIColorFromRGB(96, 70, 24) forState:UIControlStateNormal];
        [_immediatelyBtn setTitleColor:SHTUIColorFromRGB(96, 70, 24) forState:UIControlStateSelected];
        [_immediatelyBtn setBackgroundColor:SHTUIColorFromRGB(245, 224, 178)];
        [_immediatelyBtn addTarget:self action:@selector(immediatelyAction:) forControlEvents:UIControlEventTouchUpInside];
        _immediatelyBtn.titleLabel.font = SHTUIFontBold(22);
        _immediatelyBtn.layer.cornerRadius = 30.0;
        _immediatelyBtn.layer.masksToBounds = YES;
    }
    return _immediatelyBtn;
}

- (UIButton *)radioButton {
    if (!_radioButton) {
        _radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_radioButton setImage:[UIImage imageNamed:@"agreement_unselected"] forState:UIControlStateNormal];
        [_radioButton setImage:[UIImage imageNamed:@"agreement_selected"] forState:UIControlStateSelected];
        [_radioButton addTarget:self action:@selector(radioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _radioButton;
}

- (UILabel *)agreementTextLabel {
    if (!_agreementTextLabel) {
        _agreementTextLabel = [[UILabel alloc] init];
        _agreementTextLabel.userInteractionEnabled = YES;
        // 文字内容
        NSString *fullText = @"开通前请阅读《会员服务协议》（含自动续费条款）";
        NSString *linkText = @"《会员服务协议》";
        // 构造富文本
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullText];
        // 设置整体字体和颜色
        [attrStr addAttribute:NSFontAttributeName value:SHTUIFontSystem(13) range:NSMakeRange(0, fullText.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:SHTUIColorFromRGB(153.0, 147.0, 137.0) range:NSMakeRange(0, fullText.length)];
        // 设置链接部分样式
        NSRange linkRange = [fullText rangeOfString:linkText];
        [attrStr addAttribute:NSForegroundColorAttributeName value:SHTUIColorFromRGB(163.0, 157.0, 148.0) range:linkRange];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:linkRange];
        [attrStr addAttribute:NSBaselineOffsetAttributeName value:@(1.5) range:linkRange];
        _agreementTextLabel.attributedText = attrStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceAgreementHandleTapOn:)];
        [_agreementTextLabel addGestureRecognizer:tap];
    }
    return _agreementTextLabel;
}

@end
