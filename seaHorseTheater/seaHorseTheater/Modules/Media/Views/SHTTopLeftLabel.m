//
//  SHTTopLeftLabel.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/30.
//

#import "SHTTopLeftLabel.h"

@interface SHTTopLeftLabel()

@end

@implementation SHTTopLeftLabel


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    // 获取 label 默认的文字区域
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    // 修改原点为左上角（x 不变，y = bounds.origin.y）
    textRect.origin = bounds.origin;
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
    // 使用上面 textRect 的 rect 进行绘制，实现顶部对齐
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
