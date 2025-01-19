//
//  AppDelegate+ADSDK.h
//  EmpowerDemo
//
//  Created by admin on 2021/5/18.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ADSDK)

- (void)requestIDFAIfNeeded;
- (void)setupADSDK:(void (^)(BOOL success))completionHandler;

@end

NS_ASSUME_NONNULL_END
