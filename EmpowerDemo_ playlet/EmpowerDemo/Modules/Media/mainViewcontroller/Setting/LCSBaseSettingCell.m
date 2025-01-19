//
//  LCSBaseSettingCell.m
//  DJXSamples
//
//  Created by yuxr on 2020/8/18.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSBaseSettingCell.h"

@implementation LCSBaseSettingCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textColor = UIColor.grayColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_subTitleLabel];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCell:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, (self.height - 30) / 2, [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 30)].width, 30);
    
    CGRect subTitleFrame = self.titleLabel.frame;
    subTitleFrame.size.width = [self.subTitleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 30)].width;
    subTitleFrame.origin.x = self.contentView.width - 10 - subTitleFrame.size.width;
    
    self.subTitleLabel.frame = subTitleFrame;
}

- (void)didSelectCell:(UITapGestureRecognizer *)tapGesture {
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self);
    }
}

@end
