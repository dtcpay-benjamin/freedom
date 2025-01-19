//
//  LCSSwitchSettingCell.m
//  DJXSamples
//
//  Created by yuxr on 2020/8/18.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSSwitchSettingCell.h"

@implementation LCSSwitchSettingCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _switchView = [UISwitch new];
        _switchView.onTintColor = LCS_mainColor;
        [_switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchView.frame = CGRectMake(self.contentView.width - 10 - 50, self.titleLabel.top, 50, 30);
}

- (void)switchValueChanged:(UISwitch *)switchView {
    !self.swithValueDidChanged ?: self.swithValueDidChanged(switchView);
}

@end
