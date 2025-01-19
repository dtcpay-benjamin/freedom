//
//  LCSMacros.h
//  DJXSamples
//
//  Created by iCuiCui on 2020/4/19.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#ifndef LCSMacros_h
#define LCSMacros_h

#import <Foundation/Foundation.h>
#import "LCSConfigID.h"
#import "UIView+LCS.h"
#import "UIView+LCSLayout.h"

/// ********* Debug switchs begin

/// Log
extern BOOL LCS_LOG_ENABLED;

typedef NS_ENUM(NSUInteger, LCSDemoToastType) {
    LCSDemoToastTypeDefault, // 使用DJXSDK默认的toast
    LCSDemoToastTypeCustom, // 自定义toast
    LCSDemoToastTypeNone // 不展示toast
};

extern LCSDemoToastType LCS_TOAST_TYPE;

/// ********* Debug switchs end

#define LCS_Log(frmt, ...)   \
do {                                                      \
    if(LCS_LOG_ENABLED) {   \
    NSLog(@"【LCSamples】%@", [NSString stringWithFormat:frmt,##__VA_ARGS__]);  \
    }       \
} while(0)

#define LCS_LOG_WITH_TAG(tag, callBackDesc) \
LCS_Log(@"LCSCallBack%@ %@", tag, callBackDesc)

#define LCS_COMMON_CALLBACK_LOG(tag, callBackDesc, additionStr) \
LCS_Log(@"LCSCallBack%@ %@, - event:%@ %@", tag, callBackDesc, [event toJSONString], additionStr ?: @"")

#define LCS_PLAYER_CALLBACK_LOG(callBackDesc) \
LCS_COMMON_CALLBACK_LOG(@"【Player】", callBackDesc, nil)

#define LCS_COVER_CALLBACK_LOG(callBackDesc) \
LCS_COMMON_CALLBACK_LOG(@"【Cover】", callBackDesc, nil)

#define LCS_AD_CALLBACK_LOG(callBackDesc) \
LCS_COMMON_CALLBACK_LOG(@"【Advert】", callBackDesc, nil)

#define LCS_REQUEST_EVENT_CALLBACK_LOG(callBackDesc) \
LCS_COMMON_CALLBACK_LOG(@"【Request】", callBackDesc, nil)

#define LCS_DETAIL_CALLBACK_LOG(callBackDesc) \
LCS_COMMON_CALLBACK_LOG(@"【Detail】", callBackDesc, nil)

//// UI
#define LCS_mainColor      LCS_RGB(0xf0, 0x41, 0x42)
#define unValidColor       LCS_RGB(0xd7, 0xd7, 0xd7)
#define LCS_RGB(r,g,b)     [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]
#define LCS_RGBA(r,g,b,a)     [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define LCS_inconWidth     28
#define LCSScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define LCSScreenHeight           [[UIScreen mainScreen] bounds].size.height
#define LCSMINScreenSide          MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define LCSMAXScreenSide          MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define LCS_IS_iphoneX            (lcs_isNotchScreen())
#define LCS_bottomHeight          (LCS_IS_iphoneX?34:0)
#define LCS_tabBarHeight          (50+LCS_bottomHeight)
#define LCS_stautsBarHeight       (LCS_IS_iphoneX?44:20)
#define LCS_navBarHeight          (LCS_IS_iphoneX?88:64)
#define DJX_safeTopMargin         (LCS_IS_iphoneX?24:0)

//// other
#ifndef lcs_weakify
#if __has_feature(objc_arc)
#define lcs_weakify(object) __weak __typeof__(object) weak##object = object;
#else
#define lcs_weakify(object) __block __typeof__(object) block##object = object;
#endif
#endif
#ifndef lcs_strongify
#if __has_feature(objc_arc)
#define lcs_strongify(object) __typeof__(object) object = weak##object;
#else
#define lcs_strongify(object) __typeof__(object) object = block##object;
#endif
#endif

extern BOOL lcs_isNotchScreen(void);

NS_ASSUME_NONNULL_BEGIN

@interface LCSMacros : NSObject

@end

NS_ASSUME_NONNULL_END
#endif /* LCSMacros_h */
