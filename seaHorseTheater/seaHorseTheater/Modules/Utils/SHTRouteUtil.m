//
//  SHTRouteUtil.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTRouteUtil.h"

@implementation SHTRouteUtil

+ (void)presentFrom:(UIViewController *)fromVC to:(UIViewController *)toVC {
    toVC.modalPresentationStyle = UIModalPresentationFullScreen;
    // 全屏弹出
    toVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // 默认从下往上弹出
    // 弹出控制器
    [fromVC presentViewController:toVC animated:YES completion:nil];
}

@end
