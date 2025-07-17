//
//  SHTAlertHelper.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SHTAlertActionBlock)(void);

@interface SHTAlertHelper : NSObject

+ (instancetype)sharedHelper;

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
             cancelBtnText:(nullable NSString *)cancelText
              confirmBtnText:(nullable NSString *)confirmText
              inController:(nullable UIViewController *)controller
               cancelAction:(nullable SHTAlertActionBlock)cancelAction
              confirmAction:(nullable SHTAlertActionBlock)confirmAction;

/// 展示自定义会员开通弹窗
+ (void)showMembershipConfirmDialogInController:(UIViewController *)controller params:(NSDictionary *)params confirmAction:(void(^)(void))confirmAction closeAction:(void(^)(void))closeAction storePopup:(void(^)(UIView *popupView))popupCallback;

@end

NS_ASSUME_NONNULL_END
