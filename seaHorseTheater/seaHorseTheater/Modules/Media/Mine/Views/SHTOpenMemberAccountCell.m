//
//  SHTOpenMemberAccountTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 7/23/25.
//

#import "SHTOpenMemberAccountCell.h"
#import "SHTMineModel.h"
#import <Masonry/Masonry.h>

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
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20.0);
        make.leading.equalTo(self.contentView).offset(10.0);
        make.trailing.equalTo(self.contentView).offset(-10.0);
        make.bottom.equalTo(self.contentView).offset(-20.0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(40.0);
        make.leading.equalTo(self.backView).offset(20.0);
        make.height.mas_equalTo(32.0);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20.0);
        make.leading.equalTo(self.backView).offset(20.0);
        make.height.mas_equalTo(30.0);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.trailing.equalTo(self.backView).offset(-20.0);
        make.width.mas_equalTo(110.0);
        make.height.mas_equalTo(46.0);
    }];
}

#pragma mark - actions

- (void)setModel:(SHTMineModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.subTitleLabel.text = _model.subTitle;
    [self.openBtn setTitle:_model.otherTitle forState:UIControlStateNormal];
    [self.openBtn setTitle:_model.otherTitle forState:UIControlStateSelected];
}

- (void)openAction:(UIButton *)sender {
    // 去开通会员页面
    NSLog(@"去开通会员~");
    if (self.openMemberAccountTapped) {
        self.openMemberAccountTapped();
    }
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
        _titleLabel.font = SHTUIFontBold(25);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = SHT_BACK_COLOR;
        _subTitleLabel.font = SHTUIFontSystem(20);
    }
    return _subTitleLabel;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.backgroundColor = SHT_BACK_COLOR;
        _openBtn.titleLabel.font = SHTUIFontBold(22);
        [_openBtn setTitleColor:SHTUIColorFromRGB(150, 92.0, 101.0) forState:UIControlStateNormal];
        [_openBtn setTitleColor:SHTUIColorFromRGB(150, 92.0, 101.0) forState:UIControlStateSelected];
        [_openBtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.layer.masksToBounds = YES;
        _openBtn.layer.cornerRadius = 6.0;
    }
    return _openBtn;
}

@end
