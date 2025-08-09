//
//  UILabel+SHTSizeCalculation.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SHTSizeCalculation)

/// 计算 UILabel 文本所需高度（支持 numberOfLines 限制）
/// @param width 限制的最大宽度
- (CGFloat)upc_heightForWidth:(CGFloat)width;

/// 计算 UILabel 文本所需宽度（支持 numberOfLines 限制）
/// @param height 限制的最大高度
- (CGFloat)upc_widthForHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
