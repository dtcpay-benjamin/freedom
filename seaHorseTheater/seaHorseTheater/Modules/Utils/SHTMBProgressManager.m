//
//  SHTMBProgressManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/23.
//

#import "SHTMBProgressManager.h"
#import <MBProgressHUD.h>

@implementation SHTMBProgressManager

+ (void)showHUD:(UIView *)view {
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    } else {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
}

+ (void)hideHUD:(UIView *)view {
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    } else {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [MBProgressHUD hideHUDForView:window animated:YES];
    }
}

+ (void)showTextHUD:(UIView *)view withText:(NSString *)text andSubText:(NSString *)subText {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view ? view : window  animated:YES];
    hud.label.text = text;  // 主文字
    hud.detailsLabel.text = subText; // 可选：副标题
    // 设置背景色为黑色
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.3];
}

+ (void)showText:(UIView *)view withText:(NSString *)text andSubText:(NSString *)subText  isBottom:(BOOL)isBottom {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view ? view : window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.detailsLabel.text = subText; // 可选：副标题
    hud.margin = 10.f;
    // 设置背景色为黑色
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.3];
    if (isBottom) {
        hud.offset = CGPointMake(0, MBProgressMaxOffset); // 可选：显示在底部
    }
    [hud hideAnimated:YES afterDelay:2]; // 延时2秒隐藏
}

+ (void)showActionResult:(UIView *)view isSuccess:(BOOL)isSuccess {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view ? view : window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        hud.label.text = @"成功";
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        hud.label.text = @"失败";
    }
    // 设置背景色为黑色
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.3];
    [hud hideAnimated:YES afterDelay:2.0];
}

@end
