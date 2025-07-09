//
//  SHTPremiumFeaturesTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/4.
//

#import "SHTPremiumFeaturesTableViewCell.h"
#import <Masonry/Masonry.h>

@interface SHTPremiumFeaturesView()

@property (nonatomic, strong) UIImageView *featuresImageView; // 功能图片标识
@property (nonatomic, strong) UILabel *titleLabel; // 功能标题
@property (nonatomic, strong) UILabel *subTitleLabel; // 功能副标题

@end

@implementation SHTPremiumFeaturesView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLayoutSubviews];
}

- (void)addSubviews {
    [self addSubview:self.featuresImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
}

- (void)addLayoutSubviews {
    [self.featuresImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.featuresImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(18);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(18);
    }];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSString *imgStr = _data[@"featuresImage"];
    if (imgStr && imgStr.length > 0) {
        self.featuresImageView.image = [UIImage imageNamed:imgStr];
    }
    NSString *titleStr = _data[@"title"];
    if (titleStr && titleStr.length > 0) {
        self.titleLabel.text = titleStr;
    }
    NSString *subTitleStr = _data[@"subTitle"];
    if (subTitleStr && subTitleStr.length > 0) {
        self.subTitleLabel.text = subTitleStr;
    }
}

#pragma mark - 懒加载

- (UIImageView *)featuresImageView {
    if (!_featuresImageView) {
        _featuresImageView = [[UIImageView alloc] init];
        _featuresImageView.layer.masksToBounds = YES;
        _featuresImageView.layer.cornerRadius = 8.0;
        _featuresImageView.backgroundColor = SHTUIColorFromRGB(39, 32, 29);
    }
    return _featuresImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = SHTUIColorFromRGB(138, 131, 123);
        _titleLabel.font = SHTUIFontBold(16);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = SHTUIColorFromRGB(80, 77, 70);
        _subTitleLabel.font = SHTUIFontSystem(14);
    }
    return _subTitleLabel;
}

@end

@interface SHTPremiumFeaturesTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图

@end

@implementation SHTPremiumFeaturesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(SHTScreenWidth);
        make.height.mas_equalTo(20);
    }];
}

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
}


- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self.contentView addSubview:self.scrollView];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 80;
    CGFloat height = 135.0;
    for (int i = 0; i < _datas.count; i++) {
        NSDictionary *dic = _datas[i];
        x = 20 * (i + 1) + width * i;
        SHTPremiumFeaturesView *featuresView = [[SHTPremiumFeaturesView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        featuresView.data = dic;
        [self.scrollView addSubview:featuresView];
    }
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = SHTUIColorFromRGB(112, 103, 94);
        _titleLabel.font = SHTUIFontBold(15);
        _titleLabel.text = @"功能特权";
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SHTScreenWidth, 135)];
        // 允许水平滚动
        _scrollView.contentSize = CGSizeMake(SHTScreenWidth + 60, 135); // 宽度大于 scrollView.frame.size.width
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
