//
//  SHTToolsManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTToolsManager : NSObject

+ (UIViewController *)topViewController;

+ (UIViewController *)topViewControllerFrom:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
