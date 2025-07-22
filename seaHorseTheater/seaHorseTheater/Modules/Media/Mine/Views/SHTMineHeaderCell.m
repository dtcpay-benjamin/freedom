//
//  SHTMineHeaderCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/22.
//

#import "SHTMineHeaderCell.h"
#import <Masonry/Masonry.h>

@interface SHTMineHeaderCell ()

@property (nonatomic, strong) UIImageView *headerImgview; //头像
@property (nonatomic, strong) UILabel *uniqueIdentifierLabel; //唯一标识

@end

@implementation SHTMineHeaderCell


- (void)addSubviews {
    [self.contentView addSubview:self.headerImgview];
    [self.contentView addSubview:self.uniqueIdentifierLabel];
}

- (void)addLayoutSubviews {
    [self.headerImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SHT_NAV_BAR_TOTAL_HEIGHT + 20.0);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(80.0);
        make.height.mas_equalTo(80.0);
    }];
    [self.uniqueIdentifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgview.mas_bottom).offset(20.0);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(20.0);
    }];
}

#pragma mark - 懒加载

- (UIImageView *)headerImgview {
    if (!_headerImgview) {
        _headerImgview = [[UIImageView alloc] init];
    }
    return _headerImgview;
}

- (UILabel *)uniqueIdentifierLabel {
    if (!_uniqueIdentifierLabel) {
        _uniqueIdentifierLabel = [[UILabel alloc] init];
        _uniqueIdentifierLabel.textAlignment = NSTextAlignmentCenter;
        _uniqueIdentifierLabel.textColor = SHT_BACK_COLOR;
        _uniqueIdentifierLabel.font = SHTUIFontSystem(16);
    }
    return _uniqueIdentifierLabel;
}

@end
