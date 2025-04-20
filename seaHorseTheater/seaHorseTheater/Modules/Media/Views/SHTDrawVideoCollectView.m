//
//  SHTDrawVideoCollectView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/17.
//

#import "SHTDrawVideoCollectView.h"

@interface SHTDrawVideoCollectView()

@property (nonatomic, strong)UIButton *collectBtn;// 收藏按钮
@property (nonatomic, strong)UILabel *collectLabel;// 文本

@end

@implementation SHTDrawVideoCollectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectBtn];
        [self addSubview:self.collectLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectBtn.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.collectLabel.frame = CGRectMake(0.0, 40.0, 40.0, 14.0);
}

#pragma mark - actions

- (void)setPlayletInfoModel:(DJXPlayletInfoModel *)playletInfoModel {
    _playletInfoModel = playletInfoModel;
}

- (void)setStatus:(NSInteger)favorite_state {
    if (favorite_state == 1) {
        self.collectBtn.selected = YES;
        [self updateFavoriteCountLabel];
    } else {
        self.collectBtn.selected = NO;
        self.collectLabel.text = @"收藏";
    }
}

- (void)updateFavoriteCountLabel {
    NSString *displayText = @"";
    if (self.playletInfoModel.favorite_count >= 100000000) {
        // 超过一亿，保留1位小数，单位“亿”
        CGFloat billion = self.playletInfoModel.favorite_count / 100000000.0;
        displayText = [NSString stringWithFormat:@"%.1f亿", billion];
    } else if (self.playletInfoModel.favorite_count >= 10000) {
        // 超过一万，保留1位小数，单位“万”
        CGFloat tenThousand = self.playletInfoModel.favorite_count / 10000.0;
        displayText = [NSString stringWithFormat:@"%.1f万", tenThousand];
    } else {
        // 不足一万，直接显示整数
        displayText = [NSString stringWithFormat:@"%ld", (long)self.playletInfoModel.favorite_count];
    }
    self.collectLabel.text = displayText;
}

- (void)collectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self updateFavoriteCountLabel];
    } else {
        self.collectLabel.text = @"收藏";

    }
    if (self.collectActionCallBack) {
        self.collectActionCallBack(sender.isSelected);
    }
}

#pragma mark - 懒加载

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UILabel *)collectLabel {
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] init];
        _collectLabel.font = [UIFont systemFontOfSize:12.0];
        _collectLabel.textColor = [UIColor whiteColor];
        _collectLabel.text = @"收藏";
        _collectLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _collectLabel;
}
@end
