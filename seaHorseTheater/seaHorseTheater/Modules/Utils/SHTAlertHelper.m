//
//  SHTAlertHelper.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTAlertHelper.h"
#import "SHTToolsManager.h"
#import "SHTNonSelectableTextView.h"
#import <objc/runtime.h>

@implementation SHTAlertHelper

+ (instancetype)sharedHelper {
    static SHTAlertHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

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

+ (void)showMembershipConfirmDialogInController:(UIViewController *)controller params:(NSDictionary *)params  confirmAction:(void(^)(void))confirmAction closeAction:(void(^)(void))closeAction                                       storePopup:(void(^)(UIView *popupView))popupCallback {
    NSString *title = params[@"title"];
    NSString *message = params[@"message"];
    NSString *keyWords = params[@"keyWords"];
    NSString *confirmTitle = params[@"confirmTitle"];
    NSString *protocolHeader = params[@"protocolHeader"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    bgView.backgroundColor = [SHT_BACK_COLOR_DARK colorWithAlphaComponent:0.5];

    CGFloat alertWidth = controller.view.bounds.size.width - 80;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, alertWidth, 150)];
    alertView.center = controller.view.center;
    alertView.backgroundColor = SHT_BACK_COLOR;
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, alertWidth, 25)];
//    titleLabel.text = @"确认开通";
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SHTUIFontBold(18);
    [alertView addSubview:titleLabel];

    SHTNonSelectableTextView *textView = [[SHTNonSelectableTextView alloc] initWithFrame:CGRectMake(20, 50, alertWidth - 40, 30)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.dataDetectorTypes = UIDataDetectorTypeNone;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textContainer.lineFragmentPadding = 0;
//    NSString *message = @"请阅读并同意《会员服务协议》（含自动续费条款）";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
//    NSRange linkRange = [message rangeOfString:@"《会员服务协议》"];
    NSRange linkRange = [message rangeOfString:keyWords];
    if (linkRange.location != NSNotFound) {
        [attrStr addAttribute:NSLinkAttributeName value:protocolHeader range:linkRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:SHT_BACK_COLOR_DARK range:NSMakeRange(0, message.length)];
    }
    textView.attributedText = attrStr;
    textView.delegate = (id<UITextViewDelegate>)controller;
    [alertView addSubview:textView];

    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, alertWidth - 40, 40)];
    confirmBtn.backgroundColor = [UIColor systemRedColor];
//    [confirmBtn setTitle:@"继续开通" forState:UIControlStateNormal];
    [confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 6;
    [confirmBtn addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirmBtn];

    // 右上角关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertWidth - 24 - 10, 10, 24, 24)];
    [closeBtn setImage:[UIImage imageNamed:@"navi_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAlertButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeBtn];
    
    [bgView addSubview:alertView];
    [keyWindow addSubview:bgView]; // 注意是加到window
    
    // 绑定数据
    objc_setAssociatedObject(confirmBtn, "confirmBlock", confirmAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(confirmBtn, "popupView", bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(closeBtn, "closeBlock", closeAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(closeBtn, "popupView", bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (popupCallback) {
        popupCallback(bgView);
    }
}

+ (void)confirmButtonTapped:(UIButton *)sender {
    void (^confirmBlock)(void) = objc_getAssociatedObject(sender, "confirmBlock");
    UIView *popup = objc_getAssociatedObject(sender, "popupView");
    [popup removeFromSuperview];
    popup = nil;
    if (confirmBlock) {
        confirmBlock();
    }
}

+ (void)closeAlertButtonTapped:(UIButton *)sender {
    void (^closeBlock)(void) = objc_getAssociatedObject(sender, "closeBlock");
    UIView *popup = objc_getAssociatedObject(sender, "popupView");
    [popup removeFromSuperview];
    popup = nil;
    if (closeBlock) {
        closeBlock();
    }
}

@end
