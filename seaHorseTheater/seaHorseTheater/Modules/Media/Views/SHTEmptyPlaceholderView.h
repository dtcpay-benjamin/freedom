//
//  SHTEmptyPlaceholderView.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTEmptyPlaceholderView : UIView

/// 初始化方法
/// @param frame 视图大小
/// @param imageName 可选图片名，为空则不展示
/// @param message 提示文案
/// @param buttonTitle 按钮标题
/// @param actionBlock 点击按钮的回调
- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(nullable NSString *)imageName
                      message:(NSString *)message
                  buttonTitle:(NSString *)buttonTitle
                  actionBlock:(void(^)(void))actionBlock;

@end

NS_ASSUME_NONNULL_END
