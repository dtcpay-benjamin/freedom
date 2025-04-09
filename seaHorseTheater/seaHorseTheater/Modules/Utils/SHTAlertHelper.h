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

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
             cancelBtnText:(nullable NSString *)cancelText
              confirmBtnText:(nullable NSString *)confirmText
              inController:(nullable UIViewController *)controller
               cancelAction:(nullable SHTAlertActionBlock)cancelAction
              confirmAction:(nullable SHTAlertActionBlock)confirmAction;

@end

NS_ASSUME_NONNULL_END
