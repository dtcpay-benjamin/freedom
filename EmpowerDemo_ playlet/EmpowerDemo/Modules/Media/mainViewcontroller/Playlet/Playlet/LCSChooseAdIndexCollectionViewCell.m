//
//  LCSChooseAdIndexCollectionViewCell.m
//  EmpowerDemo
//
//  Created by ByteDance on 2024/3/7.
//  Copyright © 2024 bytedance. All rights reserved.
//

#import "LCSChooseAdIndexCollectionViewCell.h"

@interface LCSChooseAdIndexCollectionViewCell ()

@property (nonatomic) UILabel *titleLabel;

@end

@implementation LCSChooseAdIndexCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.center = CGPointMake(self.contentView.size.width / 2, self.contentView.size.height / 2);
}

- (void)setData:(NSInteger)i selected:(BOOL)selected {
    self.titleLabel.text = @(i).stringValue;
    [self.titleLabel sizeToFit];
    if (@available(iOS 13.0, *)) {
        self.contentView.backgroundColor = selected ? UIColor.systemFillColor : UIColor.clearColor;
    } else {
        // Fallback on earlier versions
        self.contentView.backgroundColor = selected ? UIColor.blueColor : UIColor.clearColor;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
