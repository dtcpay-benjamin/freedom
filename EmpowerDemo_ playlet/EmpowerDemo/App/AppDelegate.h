//
//  AppDelegate.h
//  Runner
//
//  Created by bob on 2020/2/27.
//  delete comment   11 last one
//  Copyright © 2020 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

FOUNDATION_EXPORT NSNotificationName const kDJXAppWillCallDidFinishLaunchingWithOptions;

@interface AppDelegate : UIResponder <UIApplicationDelegate>  

@property (strong, nonatomic) UIWindow *window;

- (void)prepare;
- (void)setup;

@end

