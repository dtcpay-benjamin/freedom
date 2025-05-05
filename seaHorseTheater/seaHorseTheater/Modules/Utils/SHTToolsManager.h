//
//  SHTToolsManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import <Foundation/Foundation.h>
#import <PangrowthDJX/DJXSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTToolsManager : NSObject

+ (UIViewController *)topViewController;

+ (UIViewController *)topViewControllerFrom:(UIViewController *)vc;

+ (void)enterPlayer:(DJXPlayletInfoModel *)infoModel fromVC:(UIViewController<DJXPlayletDetailCellDelegate> *)fromVC;

@end

NS_ASSUME_NONNULL_END
