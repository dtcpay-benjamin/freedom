//
//  MBProgressHUD+Toast.m
//  DJXSamples
//
//  Created by yuxr on 2020/6/7.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "MBProgressHUD+Toast.h"

@implementation MBProgressHUD (Toast)

+ (void)showToast:(NSString *)text withConfig:(void(^ _Nullable)(MBProgressHUD *hud))configBlock dismissAfterDelay:(NSTimeInterval)delay {
    [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.backgroundView.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.textColor = UIColor.whiteColor;
    hud.label.text = text;
    
    if (configBlock) {
        configBlock(hud);
    }

    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showToast:(NSString *)text dismissAfterDelay:(NSTimeInterval)delay {
    [self showToast:text
         withConfig:nil
  dismissAfterDelay:delay];
}

@end
