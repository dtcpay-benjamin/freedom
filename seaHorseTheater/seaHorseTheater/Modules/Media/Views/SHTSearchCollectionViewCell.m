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

- (void)setModel:(DJXPlayletInfoModel *)model {
    _model = model;
    self.text = model.title;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = _text;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    _titleLabel.frame = CGRectMake(0.0, 0.0, size.width + 20.0, 30.0);
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = SHT_SEARCH_TEXT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = SHT_SEARCH_CELL_BACK;
        _titleLabel.layer.cornerRadius = 15;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}


@end
