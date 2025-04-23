//
//  SHTMBProgressManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTMBProgressManager : NSObject

// 显示加载中
+ (void)showHUD:(UIView *)view;

// 隐藏
+ (void)hideHUD:(UIView *)view;

// 带文字的加载中
+ (void)showTextHUD:(UIView *)view withText:(NSString *)text andSubText:(NSString *)subText;

// 只显示文字（不带加载中）
+ (void)showText:(UIView *)view withText:(NSString *)text andSubText:(NSString *)subText isBottom:(BOOL)isBottom;

// 显示成功/失败的提示图标
+ (void)showActionResult:(UIView *)view isSuccess:(BOOL)isSuccess;
@end

NS_ASSUME_NONNULL_END
