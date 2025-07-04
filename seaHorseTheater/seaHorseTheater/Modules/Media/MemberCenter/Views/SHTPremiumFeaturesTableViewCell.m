//
//  SHTPremiumFeaturesTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/4.
//

#import "SHTPremiumFeaturesTableViewCell.h"

@interface SHTPremiumFeaturesView()

@property (nonatomic, strong) UIImageView *featuresImageView; // 功能图片标识
@property (nonatomic, strong) UILabel *titleLabel; // 功能标题
@property (nonatomic, strong) UILabel *subTitleLabel; // 功能副标题

@end

@implementation SHTPremiumFeaturesView

- (void)setData:(NSDictionary *)data {
    _data = data;
    
}

#pragma mark - 懒加载

- (UIImageView *)featuresImageView {
    if (!_featuresImageView) {
        _featuresImageView = [[UIImageView alloc] init];
    }
    return _featuresImageView;
}

@end

@interface SHTPremiumFeaturesTableViewCell()

@end

@implementation SHTPremiumFeaturesTableViewCell


@end
