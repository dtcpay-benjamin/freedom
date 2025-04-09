//
//  SHTAlertHelper.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTAlertHelper.h"
#import "SHTToolsManager.h"

@implementation SHTAlertHelper

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
             cancelBtnText:(nullable NSString *)cancelText
            confirmBtnText:(nullable NSString *)confirmText
              inController:(nullable UIViewController *)controller
              cancelAction:(nullable SHTAlertActionBlock)cancelAction
             confirmAction:(nullable SHTAlertActionBlock)confirmAction {
    if (!cancelText) {
        cancelText = @"取消";
    }
    
    if (!confirmText) {
        confirmText = @"确认";
    }
    
    // 如果没有传 controller，则使用顶层控制器
    if (!controller) {
        controller = [SHTToolsManager topViewController];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelText
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmText
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        if (confirmAction) {
            confirmAction();
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    if (controller) {
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

@end
