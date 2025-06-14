//
//  SHTSearchCollectionReusableView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/27.
//

#import "SHTSearchCollectionReusableView.h"

@interface SHTSearchCollectionReusableView()

@property (nonatomic, strong) UILabel *titleLabel; // 标题栏
@property (nonatomic, strong) UIView *actionView; // 事件响应视图
@property (nonatomic, strong) UIImageView *actionImgView; // 事件响应图标
@property (nonatomic, strong) UILabel *actionLabel; // 事件响应标签


@end

@implementation SHTSearchCollectionReusableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubViewsLayouts];
}

- (void)addSubViews {
    [self addSubview:self.titleLabel];
    [self.actionView addSubview:self.actionImgView];
    [self.actionView addSubview:self.actionLabel];
    [self addSubview:self.actionView];
    // 添加点击手势
    UITapGestureRecognizer *tapGes =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.actionView addGestureRecognizer:tapGes];
}

- (void)addSubViewsLayouts {
    self.titleLabel.frame = CGRectMake(24.0, 0.0, (SHTScreenWidth - 48.0) * 0.5, 32.0);
}

#pragma mark - actions
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setActionImage:(UIImage *)actionImage {
    _actionImage = actionImage;
    self.actionImgView.image = _actionImage;
}

- (void)setActionTitle:(NSString *)actionTitle {
    _actionTitle = actionTitle;
    self.actionLabel.text = _actionTitle;
    if (_actionTitle.length > 0) {
        self.actionView.frame = CGRectMake(SHTScreenWidth - 24.0 - 68.0 + 5.0, 0.0, 68.0, 32.0);
        self.actionImgView.frame = CGRectMake(0.0, 8.0, 16.0, 16.0);
        self.actionLabel.frame = CGRectMake(20.0, 8.0, 48.0, 16.0);
        self.actionLabel.hidden = NO;
    } else {
        self.actionView.frame = CGRectMake(SHTScreenWidth - 24.0 - 32.0 + 8.0, 0.0, 32.0, 32.0);
        self.actionImgView.frame = CGRectMake(8.0, 8.0, 16.0, 16.0);
        self.actionLabel.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
        self.actionLabel.hidden = YES;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGes {
    if (self.onTapped) {
        self.onTapped();
    }
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)actionView {
    if (!_actionView) {
        _actionView = [[UIView alloc] init];
        _actionView.backgroundColor = [UIColor clearColor];
    }
    return _actionView;
}

- (UIImageView *)actionImgView {
    if (!_actionImgView) {
        _actionImgView = [[UIImageView alloc] init];
    }
    return _actionImgView;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.font = [UIFont systemFontOfSize:15];
        _actionLabel.textColor = [UIColor grayColor];
        _actionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _actionLabel;
}

@end
