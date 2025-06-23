//
//  SHTMemberImmediatelyCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/23.
//

#import "SHTMemberImmediatelyCell.h"

@interface SHTMemberImmediatelyCell()

@property (nonatomic, strong) UIButton *immediatelyBtn; // 开通按钮
@property (nonatomic, strong) UIButton *radioButton; // 阅读单选按钮
@property (nonatomic, strong) UILabel *agreementTextLabel; // 引导阅读协议文本

@end

@implementation SHTMemberImmediatelyCell


#pragma mark - actions

// 立即开通
- (void)immediatelyAction:(UIButton *)sender {

}

// 选择阅读协议
- (void)radioAction:(UIButton *)sender {
    
}

#pragma mark - 懒加载

- (UIButton *)immediatelyBtn{
    if (!_immediatelyBtn) {
        _immediatelyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_immediatelyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [_immediatelyBtn setTitle:@"立即开通" forState:UIControlStateSelected];
        [_immediatelyBtn setTitleColor:SHTUIColorFromRGB(96, 70, 24) forState:UIControlStateNormal];
        [_immediatelyBtn setTitleColor:SHTUIColorFromRGB(96, 70, 24) forState:UIControlStateSelected];
        [_immediatelyBtn setBackgroundColor:SHTUIColorFromRGB(245, 224, 178)];
        [_immediatelyBtn addTarget:self action:@selector(immediatelyAction:) forControlEvents:UIControlEventTouchUpInside];
        _immediatelyBtn.titleLabel.font = SHTUIFontSystem(22);
    }
    return _immediatelyBtn;
}

- (UIButton *)radioButton {
    if (!_radioButton) {
        _radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_radioButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [_radioButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [_radioButton addTarget:self action:@selector(radioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _radioButton;
}

- (UILabel *)agreementTextLabel{
    if (!_agreementTextLabel) {
        _agreementTextLabel = [[UILabel alloc] init];
    }
    return _agreementTextLabel;
}

@end
