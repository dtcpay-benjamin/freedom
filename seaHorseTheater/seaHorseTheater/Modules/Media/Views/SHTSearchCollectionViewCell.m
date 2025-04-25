//
//  SHTSearchCollectionViewCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTSearchCollectionViewCell.h"

@interface SHTSearchCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SHTSearchCollectionViewCell

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

- (void)addSubviews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = _text;
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = SHT_SEARCH_BACK_BORDERCOLOR;
        _titleLabel.layer.cornerRadius = 15;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}


@end
