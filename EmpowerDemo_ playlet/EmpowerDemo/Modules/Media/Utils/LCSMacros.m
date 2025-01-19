//
//  LCSMacros.m
//  DJXSamples
//
//  Created by iCuiCui on 2020/4/19.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSMacros.h"
BOOL LCS_LOG_ENABLED = YES;

LCSDemoToastType LCS_TOAST_TYPE = LCSDemoToastTypeDefault;

inline BOOL lcs_isNotchScreen(void) {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    BOOL isNotchScreen = LCSMAXScreenSide >= 812.0;//((LCSMAXScreenSide == 812.0) || (LCSMAXScreenSide == 896));
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        if (window) {
            isNotchScreen = window.safeAreaInsets.bottom > 0;
        }
    }
    return isNotchScreen;
}

@implementation LCSMacros

@end
