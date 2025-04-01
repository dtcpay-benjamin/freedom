//
//  SHTFavoritePlayletCell.m
//  seaHorseTheater
//
//  Created by apple on 2025/3/18.
//

#import "SHTFavoritePlayletCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SHTFavoritePlayletModel.h"

@interface SHTFavoritePlayletCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIImageView *deleteImageView;

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
    CGFloat defaultHeight = self.contentView.bounds.size.width * (16.0 / 9.0); // 默认 16:9 比例
    self.imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, defaultHeight);
    self.titleLabel.frame = CGRectMake(5, CGRectGetMaxY(self.imageView.frame) + 5, self.contentView.bounds.size.width - 10, 20);
    self.subtitleLabel.frame = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame) + 2, self.contentView.bounds.size.width - 10, 18);
    self.deleteImageView.frame = CGRectMake(self.contentView.bounds.size.width - 22 - 8, 8, 22, 22);
}


- (void)addSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.deleteImageView];
}

- (void)setPlayletinfoModel:(DJXPlayletInfoModel *)playletinfoModel {
    _playletinfoModel = playletinfoModel;
    NSURL *url = [NSURL URLWithString:_playletinfoModel.cover_image];
    // 开始加载时展示 loadingView
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:nil
                               options:SDWebImageAvoidAutoSetImage
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 下载完成，隐藏 loading
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        if (image) {
            self.imageView.alpha = 0.0;
            self.imageView.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                self.imageView.alpha = 1.0;
            }];
        } else {
            NSLog(@"收藏短剧封面下载失败error:%@", error);
        }
    }];
    self.titleLabel.text = _playletinfoModel.title;
    self.subtitleLabel.text = [NSString stringWithFormat:@"观看至%ld集",(long)_playletinfoModel.current_episode];
}

- (void)setIsEdit:(bool)isEdit {
    _isEdit = isEdit;
    self.deleteImageView.hidden = !_isEdit;
}

- (void)setFavoriteModel:(SHTFavoritePlayletModel *)favoriteModel{
    _favoriteModel = favoriteModel;
    if (favoriteModel.isSelected) {
        self.deleteImageView.image = [UIImage imageNamed:@"selected"];
    } else {
        self.deleteImageView.image = [UIImage imageNamed:@"unselected"];
    }
}
#pragma mark - 懒加载

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 4.0; // 圆角
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

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingView.center = self.contentView.center;
        _loadingView.hidesWhenStopped = YES;
        [self.contentView addSubview:_loadingView];
    }
    return _loadingView;
}

- (UIImageView *)deleteImageView {
    if (!_deleteImageView) {
        _deleteImageView = [[UIImageView alloc] init];
        _deleteImageView.image = [UIImage imageNamed:@"unselected"];
    }
    return _deleteImageView;
}

@end
