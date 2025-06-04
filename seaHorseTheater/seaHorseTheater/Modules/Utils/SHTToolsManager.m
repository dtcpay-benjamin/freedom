//
//  SHTToolsManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTToolsManager.h"
#import "SHTDrawVideoCollectView.h"

@implementation SHTToolsManager

+ (UIViewController *)topViewController {
    UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self topViewControllerFrom:rootVC];
}

+ (UIViewController *)topViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:((UINavigationController *)vc).visibleViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:((UITabBarController *)vc).selectedViewController];
    } else if (vc.presentedViewController) {
        return [self topViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}

+ (void)enterPlayer:(DJXPlayletInfoModel *)infoModel fromVC:(UIViewController<DJXPlayletDetailCellDelegate> *)fromVC {
    DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
        playletConfig.skitId = infoModel.shortplay_id;
        playletConfig.episode = infoModel.current_episode;
        playletConfig.playStartTime = (CGFloat)infoModel.action_time;
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 10;
        playletConfig.unlockEpisodesCountUsingAD = 1;
        playletConfig.hideLikeIcon = YES;
        playletConfig.hideCollectIcon = YES;
        playletConfig.customViewDelegate = fromVC;
        
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet;
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [fromVC presentViewController:vc animated:YES completion:nil];
}

@end
