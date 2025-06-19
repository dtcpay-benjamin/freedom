//
//  SHTSearchTableViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/29.
//

#import "SHTSearchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SHTTopLeftLabel.h"

@interface SHTSearchTableViewCell()

@property (nonatomic, strong) UIImageView *imgView; // 短剧封面
@property (nonatomic, strong) SHTTopLeftLabel *titleLabel; // 短剧标题
@property (nonatomic, strong) SHTTopLeftLabel *descLabel; // 短剧简介
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation SHTSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imgViewWidth = 85.0;
    CGFloat imgViewHeight = imgViewWidth * (16.0 / 9.0); // 默认 16:9 比例
    self.imgView.frame = CGRectMake(24.0, 10.0, imgViewWidth, imgViewHeight);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10.0, 10.0, self.contentView.bounds.size.width - 24.0 * 2 - 10.0 - imgViewWidth, 20);
    self.descLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 10.0, CGRectGetWidth(self.titleLabel.frame), self.contentView.bounds.size.height - CGRectGetMaxY(self.titleLabel.frame) - 10.0 * 2);
    self.loadingView.center = self.imgView.center;
}

- (void)addSubviews {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
}

- (void)setPlayletinfoModel:(DJXPlayletInfoModel *)playletinfoModel {
    _playletinfoModel = playletinfoModel;
    NSURL *url = [NSURL URLWithString:_playletinfoModel.cover_image];
    // 开始加载时展示 loadingView
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
    [self.imgView sd_setImageWithURL:url
                      placeholderImage:nil
                               options:SDWebImageAvoidAutoSetImage
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 下载完成，隐藏 loading
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        if (image) {
            self.imgView.alpha = 0.0;
            self.imgView.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                self.imgView.alpha = 1.0;
            }];
        } else {
            NSLog(@"收藏短剧封面下载失败error:%@", error);
        }
    }];
    self.titleLabel.text = _playletinfoModel.title;
    self.descLabel.text = _playletinfoModel.desc;
}

#pragma mark - 懒加载

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = SHT_SEARCH_CELL_BACK ;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.layer.cornerRadius = 4.0; // 圆角
    }
    return  _imgView;
}


- (SHTTopLeftLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SHTTopLeftLabel alloc] init];
        _titleLabel.font = SHTUIFontSystem(16);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (SHTTopLeftLabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[SHTTopLeftLabel alloc] init];
        _descLabel.font = SHTUIFontSystem(12);
        _descLabel.textColor = SHT_SEARCH_TEXT_COLOR;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        [self.contentView addSubview:_loadingView];
    }
    return _loadingView;
}

@end
