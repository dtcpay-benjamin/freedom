//
//  AppDelegate+DJDelegate.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/19/25.
//

#import "AppDelegate+DJXDelegate.h"

NSNotificationName _Nonnull const SHTDJXSDKSetConfigNotification = @"SHTDJXSDKSetConfigNotification";

static NSString * JSONConfigPath(void) {
    return [[NSBundle mainBundle] pathForResource:@"SDK_Setting_5603361" ofType:@"json"];
}

@implementation AppDelegate (DJXDelegate)

- (void)initSDKConfig {
    DJXConfig *config = [DJXConfig new];
    config.authorityDelegate = self;
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:SHTDJXSDKSetConfigNotification object:nil userInfo:@{@"config": config}]];
    [DJXManager initializeWithConfigPath:JSONConfigPath() config:config];
}
/// 初始化短剧
- (void)setUpDJXSDK:(nonnull DJXStartCompletionBlock)block {
    [DJXManager startWithCompleteHandler:^(BOOL isSuccess, NSDictionary * _Nonnull userInfo) {
        if (isSuccess == true) {
            NSLog(@"初始化注册成功！");
        } else {
            NSLog(@"%@", userInfo[@"msg"]);
        }
        if (block) {
            block(isSuccess, userInfo);
        }
    }];
}
@end
