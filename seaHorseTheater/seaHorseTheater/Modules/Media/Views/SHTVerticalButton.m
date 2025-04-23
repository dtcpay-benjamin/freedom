//
//  SHTVerticalButton.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/23.
//

#import "SHTVerticalButton.h"

@interface SHTVerticalButton()

@end

@implementation SHTVerticalButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacing = 6.0;
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

    self.imageView.frame = CGRectMake(
        (self.bounds.size.width - imageWidth) / 2,
        0,
        imageWidth,
        imageHeight
    );
    
    self.titleLabel.frame = CGRectMake(
        0,
        CGRectGetMaxY(self.imageView.frame) + spacing,
        self.bounds.size.width,
        titleHeight
    );
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
