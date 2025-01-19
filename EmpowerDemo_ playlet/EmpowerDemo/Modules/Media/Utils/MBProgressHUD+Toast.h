//
//  MBProgressHUD+Toast.h
//  DJXSamples
//
//  Created by yuxr on 2020/6/7.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Toast)

+ (void)showToast:(NSString *)text
       withConfig:(void(^ _Nullable)(MBProgressHUD *hud))configBlock
dismissAfterDelay:(NSTimeInterval)delay;
+ (void)showToast:(NSString *)text
dismissAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
