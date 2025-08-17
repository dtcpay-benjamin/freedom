//
//  SHTDrawVideoCollectView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/17.
//

#import "SHTDrawVideoCollectView.h"
#import "SHTVerticalButton.h"
#import "SHTAlertHelper.h"
#import "SHTLanguageUtil.h"

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

- (NSString *)displayCountText:(NSInteger)count {
    LanguageType language = [SHTLanguageUtil fetchCurrentLanguageType];
    
    NSString *unitText = @"";
    CGFloat displayNumber = 0.0;
    
    if (language == LanguageEN) {
        // 英文逻辑，使用 K / M 单位，更自然
        if (count >= 1000000) {
            displayNumber = count / 1000000.0;
            unitText = @"M";
        } else if (count >= 1000) {
            displayNumber = count / 1000.0;
            unitText = @"K";
        }
    } else {
        // 中文/日文/韩文逻辑，保留万/亿单位
        if (count >= 100000000) {
            displayNumber = count / 100000000.0;
            switch (language) {
                case LanguageZH_CN: unitText = @"亿"; break;
                case LanguageZH_TW: unitText = @"億"; break;
                case LanguageJA:   unitText = @"億"; break;
                case LanguageKO:   unitText = @"억"; break;
                default: break;
            }
        } else if (count >= 10000) {
            displayNumber = count / 10000.0;
            switch (language) {
                case LanguageZH_CN:
                case LanguageZH_TW: unitText = @"万"; break;
                case LanguageJA:   unitText = @"万"; break;
                case LanguageKO:   unitText = @"만"; break;
                default: break;
            }
        }
    }
    
    NSString *displayText = nil;
    if ((language == LanguageEN && count < 1000) ||
        (language != LanguageEN && count < 10000)) {
        displayText = [NSString stringWithFormat:@"%ld", (long)count];
    } else {
        // 去掉小数点末尾 .0，更干净
        NSString *numberString = [NSString stringWithFormat:@"%.1f", displayNumber];
        if ([numberString hasSuffix:@".0"]) {
            numberString = [numberString substringToIndex:numberString.length - 2];
        }
        displayText = [NSString stringWithFormat:@"%@%@", numberString, unitText];
    }
    
    return displayText;
}

- (void)updateFavoriteCount {
    _displayText = [self displayCountText:_playletInfoModel.favorite_count];
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
        [_collectBtn setTitle:@"追剧" forState:UIControlStateNormal];
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
