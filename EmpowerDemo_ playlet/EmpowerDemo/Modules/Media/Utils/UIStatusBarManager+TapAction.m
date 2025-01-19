//
//  UIStatusBarManager+TapAction.m
//  EmpowerDemo
//
//  Created by ByteDance on 2023/2/15.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "UIStatusBarManager+TapAction.h"

@implementation UIStatusBarManager (TapAction)

- (void)handleTapAction:(id)arg {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTapActionNotification" object:nil];
}

@end
