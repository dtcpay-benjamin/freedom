//
//  SHTMacros.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/19/25.
//

#import "SHTMacros.h"
BOOL SHT_LOG_ENABLED = YES;

SHTToastType SHT_TOAST_TYPE = SHTToastTypeDefault;

inline BOOL SHT_isNotchScreen(void) {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    BOOL isNotchScreen = SHTMAXScreenSide >= 812.0;//((SHTMAXScreenSide == 812.0) || (SHTMAXScreenSide == 896));
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        if (window) {
            isNotchScreen = window.safeAreaInsets.bottom > 0;
        }
    }
    return isNotchScreen;
}

@implementation SHTMacros

@end
