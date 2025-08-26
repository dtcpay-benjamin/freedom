//
//  SHTToolsManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/9.
//

#import "SHTToolsManager.h"
#import "SHTDrawVideoCollectView.h"
#import "SHTSubscriptionManager.h"
#import "DJXPlayletInfoModel+SHTFavorite.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
//        playletConfig.freeEpisodesCount = [[SHTSubscriptionManager sharedManager] isSubscribed] ? 20 : 5; // 如果已经开通订阅则可以免费观看20集，反之只能免费观看5集
        playletConfig.freeEpisodesCount = 5; // 可免费观看5集
//        playletConfig.unlockEpisodesCountUsingAD = [[SHTSubscriptionManager sharedManager] isSubscribed] ? 10 : 1; // 如果已经开通订阅则观看一次激励视频解锁10集，反之只能解锁1集
        playletConfig.unlockEpisodesCountUsingAD = 1; // 观看一次激励视频解锁1集
        playletConfig.hideLikeIcon = YES; // 隐藏点赞按钮
        playletConfig.disableDoubleClickLike = YES;
        playletConfig.hideCollectIcon = YES; // 隐藏收藏按钮，用自定义
        playletConfig.hideMoreButton = YES; // 隐藏更多按钮
        playletConfig.customViewDelegate = fromVC;
        
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet;
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
        config.progressBarStyle = DJXDrawVideoProgressBarStyleDarkContent;
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [fromVC presentViewController:vc animated:YES completion:nil];
}

+ (NSDictionary *)serializationFromJson:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

+ (UIViewController *)getTopViewController {
    // 获取 keyWindow（兼容 iOS 13+ Scene）
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                keyWindow = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }

    UIViewController *rootVC = keyWindow.rootViewController;
    UIViewController *presentingVC = rootVC;

    // 递归查找最顶层的 presentedViewController
    while (presentingVC.presentedViewController) {
        presentingVC = presentingVC.presentedViewController;
    }
    return presentingVC;
}

+ (void)downloadCoverImageForPlayletInfo:(DJXPlayletInfoModel *)playletInfo {
    NSURL *url = [NSURL URLWithString:playletInfo.cover_image];
    [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image,
                                                          NSData * _Nullable data,
                                                          NSError * _Nullable error,
                                                          SDImageCacheType cacheType,
                                                          BOOL finished,
                                                          NSURL * _Nullable imageURL) {
        if (image) {
            playletInfo.coverImage = image; // 存到分类属性
            NSLog(@"封面下载成功: %@", imageURL);
        } else {
            NSLog(@"封面下载失败: %@, error: %@", imageURL, error);
        }
    }];
}

+ (void)downloadCoverImagesForPlayletList:(NSArray<DJXPlayletInfoModel *> *)playletList {
    for (DJXPlayletInfoModel *model in playletList) {
        if (model.cover_image.length == 0) {
            NSLog(@"model.cover_image 为空，跳过");
            continue;
        }
        
        NSURL *url = [NSURL URLWithString:model.cover_image];
        [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image,
                                                              NSData * _Nullable data,
                                                              NSError * _Nullable error,
                                                              SDImageCacheType cacheType,
                                                              BOOL finished,
                                                              NSURL * _Nullable imageURL) {
            if (image) {
                model.coverImage = image; // 存到分类属性
                NSLog(@"封面下载成功: %@", imageURL);
            } else {
                NSLog(@"封面下载失败: %@, error: %@", imageURL, error);
            }
        }];
    }
}

@end
