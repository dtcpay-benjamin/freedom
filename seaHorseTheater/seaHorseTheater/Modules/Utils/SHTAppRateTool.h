//
//  SHTAppRateTool.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTAppRateTool : NSObject

/// 弹出系统评分弹窗（系统会限制每年最多3次）
+ (void)requestSystemReview;

/// 跳转 App Store 的评分页面（不受限制）
+ (void)jumpToAppStoreReviewPage;

/// 可选：推荐在“设置页”或“反馈成功后”调用
+ (void)requestReviewWithFallback;

/// 分享App
+ (void)shareAppAction:(UIViewController *)superVC;

@end

NS_ASSUME_NONNULL_END
