//
//  SHTDrawVideoCollectView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/17.
//

#import "SHTDrawVideoCollectView.h"
#import "SHTVerticalButton.h"
#import "SHTAlertHelper.h"

@interface SHTDrawVideoCollectView()

@property (nonatomic, strong)SHTVerticalButton *collectBtn; // 收藏按钮
@property (nonatomic, copy)NSString *displayText; // 短剧被收藏的数量
@end

@implementation SHTDrawVideoCollectView

#pragma mark - actions

- (void)setPlayletInfoModel:(DJXPlayletInfoModel *)playletInfoModel {
    _playletInfoModel = playletInfoModel;
    [self updateFavoriteCount];
    [self.collectBtn setTitle:_displayText forState:UIControlStateSelected];
}

- (void)setStatus:(NSInteger)favorite_state {
    if (favorite_state == 1) {
        self.collectBtn.selected = YES;
    } else {
        self.collectBtn.selected = NO;
    }
}

- (void)updateFavoriteCount {
    if (_playletInfoModel.favorite_count >= 100000000) {
        // 超过一亿，保留1位小数，单位“亿”
        CGFloat billion = _playletInfoModel.favorite_count / 100000000.0;
        _displayText = [NSString stringWithFormat:@"%.1f亿", billion];
    } else if (_playletInfoModel.favorite_count >= 10000) {
        // 超过一万，保留1位小数，单位“万”
        CGFloat tenThousand = _playletInfoModel.favorite_count / 10000.0;
        _displayText = [NSString stringWithFormat:@"%.1f万", tenThousand];
    } else {
        // 不足一万，直接显示整数
        _displayText = [NSString stringWithFormat:@"%ld", (long)_playletInfoModel.favorite_count];
    }
}

- (void)collectAction:(UIButton *)sender {
    BOOL isSelected = !sender.isSelected;
    if (isSelected) {
        [self collectDynamicAction:isSelected];
    } else {
        __weak typeof(self) weakSelf = self;
        [SHTAlertHelper showAlertWithTitle:@"确认取消追剧吗？"
                                   message:@"取消后可能找不到本剧哦～"
                             cancelBtnText:@"再想想"
                            confirmBtnText:@"确认"
                              inController:nil
                              cancelAction:nil confirmAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf collectDynamicAction:isSelected];
        }];
    }
}

- (void)collectDynamicAction:(BOOL)isSelected {
    self.collectBtn.selected = isSelected;
    __weak typeof(self) weakSelf = self;
    // 增加图片缩放动画效果
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.collectBtn.imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.collectBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    // 添加淡入淡出图片切换动画
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.collectBtn.imageView.layer addAnimation:transition forKey:nil];
    if (self.collectActionCallBack) {
        self.collectActionCallBack(self.collectBtn.isSelected);
    }
}
#pragma mark - 懒加载

- (SHTVerticalButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [SHTVerticalButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateSelected];
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBtn setTitle:_displayText forState:UIControlStateSelected];
        [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _collectBtn.titleLabel.font = SHTUIFontSystem(12);
        [_collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        _collectBtn.frame = CGRectMake(0.0, 0.0, 40.0, 60.0);
        [self addSubview:_collectBtn];
    }
    return _collectBtn;
}

@end
