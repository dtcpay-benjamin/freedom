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

- (void)collectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.collectLabel.text = @"已收藏";
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
