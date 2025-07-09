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

+ (void)pushFrom:(UIViewController *)fromVC to:(UIViewController *)toVC {
    // 设置导航栏返回按钮颜色为黑色
    fromVC.navigationController.navigationBar.tintColor = SHT_BACK_COLOR_DARK;
    // 隐藏返回按钮文字
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    fromVC.navigationItem.backBarButtonItem = backItem;
    toVC.hidesBottomBarWhenPushed = YES;
    [fromVC.navigationController pushViewController:toVC animated:YES];
}

@end
