//
//  SHTRecentWatchCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/25.
//

#import "SHTRecentWatchCell.h"
#import <PangrowthDJX/DJXSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"
#import "DJXPlayletInfoModel+SHTFavorite.h"
#import "SHTMacros.h"

@interface SHTRecentWatchCell ()

@property (nonatomic, strong) UIImageView *coverImageView; // 封面

@property (nonatomic, strong) UILabel *episodeLabel; // 集数

@property (nonatomic, strong) UILabel *titleLabel; // 标题

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation SHTRecentWatchCell

- (void)addSubviews {
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.episodeLabel];
    [self.contentView addSubview:self.titleLabel];
}

- (void)addLayoutSubviews {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(150);
    }];
    
    [self.episodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_top).offset(5);
        make.trailing.equalTo(self.coverImageView.mas_trailing).offset(-5);
        make.height.mas_equalTo(18);
        make.width.greaterThanOrEqualTo(@50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    
    self.loadingView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 25.0);
}

- (void)setModel:(DJXPlayletInfoModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.episodeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"total_episodes", nil), (long)model.total];
    if (_model.coverImage) {
        self.coverImageView.image = _model.coverImage;
    } else {
        NSURL *url = [NSURL URLWithString:_model.cover_image];
        __weak typeof(self) weakSelf = self;
        // 开始加载时展示 loadingView
        [self.loadingView startAnimating];
        self.loadingView.hidden = NO;
        [self.coverImageView sd_setImageWithURL:url
                          placeholderImage:nil
                                   options:SDWebImageAvoidAutoSetImage
                                 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 下载完成，隐藏 loading
            [strongSelf.loadingView stopAnimating];
            strongSelf.loadingView.hidden = YES;
            if (image) {
                strongSelf.coverImageView.alpha = 0.0;
                strongSelf.coverImageView.image = image;
                [UIView animateWithDuration:0.3 animations:^{
                    strongSelf.coverImageView.alpha = 1.0;
                }];
            } else {
                NSLog(@"最近观看短剧封面下载失败error:%@", error);
            }
        }];
    }
}

#pragma mark - 懒加载

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 6.0;
    }
    return _coverImageView;
}

- (UILabel *)episodeLabel {
    if (!_episodeLabel) {
        _episodeLabel = [[UILabel alloc] init];
        _episodeLabel.font = [UIFont systemFontOfSize:12];
        _episodeLabel.textColor = [UIColor whiteColor];
        _episodeLabel.backgroundColor = [SHT_BACK_COLOR_DARK colorWithAlphaComponent:0.6];
        _episodeLabel.textAlignment = NSTextAlignmentCenter;
        _episodeLabel.layer.cornerRadius = 3;
        _episodeLabel.layer.masksToBounds = YES;
    }
    return _episodeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        _loadingView.hidesWhenStopped = YES;
        [self.contentView addSubview:_loadingView];
    }
    return _loadingView;
}

@end
