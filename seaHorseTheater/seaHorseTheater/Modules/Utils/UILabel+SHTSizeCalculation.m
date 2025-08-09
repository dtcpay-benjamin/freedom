//
//  UILabel+SHTSizeCalculation.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/9/25.
//

#import "UILabel+SHTSizeCalculation.h"

@implementation UILabel (SHTSizeCalculation)

/// 计算 UILabel 文本所需高度（支持 numberOfLines 限制）
/// @param width 限制的最大宽度
- (CGFloat)upc_heightForWidth:(CGFloat)width {
    if (self.text.length == 0) return 0;

    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    // 行间距 & 对齐方式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = self.lineBreakMode;
    paragraph.alignment = self.textAlignment;
    
    NSDictionary *attributes;
    if (self.attributedText) {
        attributes = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
    } else {
        attributes = @{
            NSFontAttributeName: self.font,
            NSParagraphStyleAttributeName: paragraph
        };
    }
    
    CGRect rect = [self.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil];
    CGFloat textHeight = ceil(rect.size.height);
    
    // 如果有限制行数，计算最大可显示高度
    if (self.numberOfLines > 0) {
        CGFloat lineHeight = self.font.lineHeight;
        CGFloat maxHeight = lineHeight * self.numberOfLines;
        return MIN(textHeight, maxHeight);
    }
    
    return textHeight;
}

/// 计算 UILabel 文本所需宽度（支持 numberOfLines 限制）
/// @param height 限制的最大高度
- (CGFloat)upc_widthForHeight:(CGFloat)height {
    if (self.text.length == 0) return 0;
    
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = self.lineBreakMode;
    paragraph.alignment = self.textAlignment;
    
    NSDictionary *attributes;
    if (self.attributedText) {
        attributes = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
    } else {
        attributes = @{
            NSFontAttributeName: self.font,
            NSParagraphStyleAttributeName: paragraph
        };
    }
    
    CGRect rect = [self.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil];
    CGFloat textWidth = ceil(rect.size.width);
    
    // 宽度计算一般不受 numberOfLines 限制，但如果要考虑单行最大宽度：
    if (self.numberOfLines == 1) {
        return MIN(textWidth, maxSize.width);
    }
    
    return textWidth;
}

@end
