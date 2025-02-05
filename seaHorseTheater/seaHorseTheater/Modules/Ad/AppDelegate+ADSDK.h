//
//  AppDelegate+ADSDK.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "AppDelegate.h"
#if __has_include (<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ADSDK)
- (void)requestIDFAIfNeeded;
- (void)setupADSDK:(void (^)(BOOL success))completionHandler;
@end

NS_ASSUME_NONNULL_END
