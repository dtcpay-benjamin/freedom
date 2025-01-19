//
//  LCSVideoCardDislikeView.m
//  EmpowerDemo
//
//  Created by yuxr on 2021/12/17.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSVideoCardDislikeView.h"

@implementation LCSVideoCardDislikeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        _dislikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dislikeBtn.backgroundColor = UIColor.redColor;
        [_dislikeBtn setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [self addSubview:_dislikeBtn];
        [_dislikeBtn addTarget:self action:@selector(didClickDislikeBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showWithDislikeBtn:(UIView *)dislikeBtn dislikeActionBlock:(void (^)(void))dislikeActionBlock {
    UIView *parentView = UIApplication.sharedApplication.keyWindow;
    self.customMaskView = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = parentView.bounds;
        b.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [b addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [b addSubview:self];
        b;
    });
    
    [parentView addSubview:self.customMaskView];
    [parentView bringSubviewToFront:self.customMaskView];
    
    CGPoint arrowPoint = [self.customMaskView convertPoint:dislikeBtn.center fromView:dislikeBtn.superview];
    self.lcs_originY = arrowPoint.y;
    
    self.dislikeActionBlock = dislikeActionBlock;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dislikeBtn.lcs_size = CGSizeMake(self.lcs_width - 40, self.lcs_height - 20);
    self.dislikeBtn.lcs_center = CGPointMake(self.lcs_width / 2, self.lcs_height / 2);
}

- (void)didClickDislikeBtn {
    [self dismiss];
    if (self.dislikeActionBlock) {
        self.dislikeActionBlock();
    }
}

- (void)dismiss {
    [self.customMaskView removeFromSuperview];
    self.customMaskView = nil;
}

@end
