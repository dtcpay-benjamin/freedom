//
//  SHTRouteUtil.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTRouteUtil : NSObject

// 模态视图弹出
+ (void)presentFrom:(UIViewController *)fromVC to:(UIViewController *)toVC;

// 导航视图弹出
+ (void)pushFrom:(UIViewController *)fromVC to:(UIViewController *)toVC;

@end

NS_ASSUME_NONNULL_END
