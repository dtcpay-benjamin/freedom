//
//  SHTAlertHelper.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTAlertHelper.h"
#import "SHTToolsManager.h"
#import <objc/runtime.h>

@implementation SHTAlertHelper

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
             cancelBtnText:(nullable NSString *)cancelText
            confirmBtnText:(nullable NSString *)confirmText
              inController:(nullable UIViewController *)controller
              cancelAction:(nullable SHTAlertActionBlock)cancelAction
             confirmAction:(nullable SHTAlertActionBlock)confirmAction {
    // 如果没有传 controller，则使用顶层控制器
    if (!controller) {
        controller = [SHTToolsManager topViewController];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (cancelText) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelText
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction();
            }
        }];
        [alert addAction:cancel];
    }
    
    if (confirmText) {
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmText
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
            if (confirmAction) {
                confirmAction();
            }
        }];
        [alert addAction:confirm];
    }
    
    if (controller) {
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)showMembershipConfirmDialogInController:(UIViewController *)controller confirmAction:(void(^)(void))confirmAction {

    UIView *bgView = [[UIView alloc] initWithFrame:controller.view.bounds];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, controller.view.bounds.size.width - 80, 180)];
    alertView.center = controller.view.center;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, alertView.bounds.size.width, 25)];
    titleLabel.text = @"确认开通";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [alertView addSubview:titleLabel];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, alertView.bounds.size.width - 40, 60)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeNone;
    textView.backgroundColor = [UIColor clearColor];

    NSString *message = @"请阅读并同意《会员服务协议》（含自动续费条款）";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange linkRange = [message rangeOfString:@"《会员服务协议》"];
    if (linkRange.location != NSNotFound) {
        [attrStr addAttribute:NSLinkAttributeName
                        value:@"vipAgreement://"
                        range:linkRange];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(0, message.length)];
    }

    textView.attributedText = attrStr;
    textView.delegate = (id<UITextViewDelegate>)controller;
    [alertView addSubview:textView];

    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, alertView.bounds.size.width - 40, 40)];
    confirmBtn.backgroundColor = [UIColor systemRedColor];
    [confirmBtn setTitle:@"继续开通" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 6;
    [confirmBtn addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirmBtn];

    [bgView addSubview:alertView];
    [controller.view addSubview:bgView];

    // 存 confirmBlock
    objc_setAssociatedObject(confirmBtn, "confirmBlock", confirmAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(confirmBtn, "popupView", bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)confirmButtonTapped:(UIButton *)sender {
    void (^confirmBlock)(void) = objc_getAssociatedObject(sender, "confirmBlock");
    UIView *popup = objc_getAssociatedObject(sender, "popupView");
    [popup removeFromSuperview];
    if (confirmBlock) {
        confirmBlock();
    }
}

@end
