//
//  SHTFavoritePlayletCell.m
//  seaHorseTheater
//
//  Created by apple on 2025/3/18.
//

#import "SHTFavoritePlayletCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SHTFavoritePlayletCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation SHTFavoritePlayletCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self  addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  addSubviews];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 50);
    self.titleLabel.frame = CGRectMake(5, CGRectGetMaxY(self.imageView.frame) + 5, self.contentView.bounds.size.width - 10, 20);
    self.subtitleLabel.frame = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame) + 2, self.contentView.bounds.size.width - 10, 18);
}


- (void)addSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
}

- (void)setPlayletinfoModel:(DJXPlayletInfoModel *)playletinfoModel{
    _playletinfoModel = playletinfoModel;
    NSURL *url = [NSURL URLWithString:_playletinfoModel.cover_image];
    [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"收藏短剧封面下载失败error:%@", error);
        }
    }];
    self.titleLabel.text = _playletinfoModel.title;
    self.subtitleLabel.text = [NSString stringWithFormat:@"观看至%ld集",(long)_playletinfoModel.current_episode];
}

#pragma mark - 懒加载

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return  _imageView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    return _subtitleLabel;
}
@end
