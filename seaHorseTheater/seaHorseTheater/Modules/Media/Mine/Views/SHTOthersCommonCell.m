//
//  SHTOthersCommonCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/25.
//

#import "SHTOthersCommonCell.h"
#import "SHTMineModel.h"
#import <Masonry/Masonry.h>

@interface SHTOthersCommonCell()

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIImageView *instructionsImgView; // 指示箭头

@end

@implementation SHTOthersCommonCell

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.instructionsImgView];
}

- (void)addLayoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(40.0);
        make.height.mas_equalTo(20.0);
    }];
    [self.instructionsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-20.0);
        make.width.mas_equalTo(12.0);
        make.height.mas_equalTo(12.0);
    }];
}

- (void)setModel:(SHTMineModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SHT_BACK_COLOR;
        _titleLabel.font = SHTUIFontSystem(18);
    }
    return _titleLabel;
}

- (UIImageView *)instructionsImgView {
    if (!_instructionsImgView) {
        _instructionsImgView = [[UIImageView alloc] init];
        [_instructionsImgView setImage:[UIImage imageNamed:@"SHT_right_indication"]];
    }
    return _instructionsImgView;
}

@end
