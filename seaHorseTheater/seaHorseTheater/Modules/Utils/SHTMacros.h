//
//  SHTMacros.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/19/25.
//

#import <Foundation/Foundation.h>
#import "SHTConfigID.h"
#import "UIView+SHT.h"

typedef NS_ENUM(NSUInteger, SHTToastType) {
    SHTToastTypeDefault, // 使用DJXSDK默认的toast
    SHTToastTypeCustom, // 自定义toast
    SHTToastTypeNone // 不展示toast
};

#define SHTScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define SHTScreenHeight           [[UIScreen mainScreen] bounds].size.height
#define SHTMAXScreenSide          MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
// 宏定义 - 状态栏高度
#define SHT_STATUS_BAR_HEIGHT    ([UIApplication sharedApplication].statusBarFrame.size.height)
// 宏定义 - 导航栏高度
#define SHT_NAV_BAR_HEIGHT       44.0
// 宏定义 - 状态栏 + 导航栏总高度
#define SHT_NAV_BAR_TOTAL_HEIGHT (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)

#define SHT_IS_iphoneX            (SHT_isNotchScreen())
#define SHT_bottomHeight          (SHT_IS_iphoneX?34:0)
#define SHT_tabBarHeight          (50+SHT_bottomHeight)

#define SHT_SEARCH_BACK_COLOR  [UIColor whiteColor]
#define SHT_SEARCH_BACK_BORDERCOLOR      [UIColor colorWithWhite:0.95 alpha:1.0]
#define SHT_SEARCH_CELL_BACK      [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:250.0/255.0 alpha:1.0]
#define SHT_SEARCH_TEXT_COLOR     [UIColor colorWithRed:102.0/255.0 green:104.0/255.0 blue:107.0/255.0 alpha:1.0]
#define HISTORY_SEARCHES_KEY  @"historySearchesKey"

extern BOOL SHT_isNotchScreen(void);
NS_ASSUME_NONNULL_BEGIN

@interface SHTMacros : NSObject

@end

NS_ASSUME_NONNULL_END
