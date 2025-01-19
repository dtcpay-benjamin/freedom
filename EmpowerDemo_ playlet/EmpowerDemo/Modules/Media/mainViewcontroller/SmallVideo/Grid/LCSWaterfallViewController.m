//
//  LCSWaterfallViewController.m
//  LCDSamples
//
//  Created by yuxr on 2021/8/13.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSWaterfallViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import <LCDSDK/LCDSDK.h>
#import "LCSMacros.h"
#import "UIView+LCSAddition.h"

@interface LCSWaterfallViewController ()<LCDGridVideoViewControllerDelegate , LCDAdvertCallBackProtocol >

@end

@implementation LCSWaterfallViewController

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *model = [LCSActionModel plainTitleActionModel:@"双feed" cellType:LCSCellType_grid action:^{
        lcs_strongify(self)
        
        LCDGridVideoViewController *gridVC = [[LCDGridVideoViewController alloc] initWithConfigBuilder:^(LCDGridVideoVCConfig * _Nonnull config) {
            // 自定义距离屏幕顶部的高度
            config.contentInset = UIEdgeInsetsMake(LCS_stautsBarHeight + 16, 0, 0, 0);
            
            config.gridVideoVCType = LCDGridVideoVCType_waterfall;
            config.delegate = self;
            config.adDelegate = self;
            }];
        
        gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
        UIButton *closeButton = [self createCloseButtonWithRelatedVC:gridVC];
        [gridVC.view addSubview:closeButton];
        [self presentViewController:gridVC animated:YES completion:^{
        }];
    }];
    
    LCSActionModel *model_customRefresh = [LCSActionModel plainTitleActionModel:@"双feed（自定义刷新）" cellType:LCSCellType_grid action:^{
        lcs_strongify(self)
        
        LCDGridVideoViewController *gridVC = [[LCDGridVideoViewController alloc] initWithConfigBuilder:^(LCDGridVideoVCConfig * _Nonnull config) {
            // 自定义距离屏幕顶部的高度
            config.contentInset = UIEdgeInsetsMake(LCS_stautsBarHeight + 16, 0, 0, 0);
            
            config.gridVideoVCType = LCDGridVideoVCType_waterfall;
            config.delegate = self;
            config.customRefresh = YES;
            config.adDelegate = self;
            }];
        
        gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
        UIButton *closeButton = [self createCloseButtonWithRelatedVC:gridVC];
        [gridVC.view addSubview:closeButton];
        [self presentViewController:gridVC animated:YES completion:^{
            lcs_weakify(gridVC)
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                lcs_strongify(gridVC)
                [gridVC refreshDataWithCompletion:^(NSError * _Nullable error) {
                    lcs_strongify(gridVC)
                    [gridVC.dataView.mj_header endRefreshing];
                }];
            }];
            header.stateLabel.textColor = UIColor.blackColor;
            header.lastUpdatedTimeLabel.hidden = YES;
            
            header.ignoredScrollViewContentInsetTop = LCS_stautsBarHeight + 16;
            
            gridVC.dataView.mj_header = header;
        }];
    }];
    
    self.items = @[@[model,model_customRefresh]];
}

#pragma mark - LCDGridVideoViewControllerDelegate

- (void)lcdClickGridItemEvent:(LCDEvent *)event controller:(UIViewController *)gridViewController {
    LCS_COMMON_CALLBACK_LOG(@"【Grid-event】", @"click grid item", nil);
}

- (void)lcdGridItemClientShowEvent:(LCDEvent *)event {
    LCS_COMMON_CALLBACK_LOG(@"【Grid-event】", @"client show", nil);
}

- (void)lcdDataRefreshCompletion:(NSError *)error {
    NSString *desc = @"data refresh completion";
    if (error) {
        desc = [desc stringByAppendingFormat:@" with error: %@", error.localizedDescription];
    }
    LCS_LOG_WITH_TAG(@"【Grid-event】", desc);
}

- (void)lcdGridDataRefreshCompletion:(NSError *)error {
    NSString *desc = @"new data refresh completion";
    if (error) {
        desc = [desc stringByAppendingFormat:@" with error: %@", error.localizedDescription];
    }
    LCS_LOG_WITH_TAG(@"【Grid-event】", desc);
}

#pragma mark - LCDRequestCallBackProtocol
- (void)lcdContentRequestStart:(LCDEvent * _Nullable)event {
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request start");
}

- (void)lcdContentRequestSuccess:(NSArray<LCDEvent *> *)events {
    LCDEvent *event = events.firstObject;
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request success");
}

- (void)lcdContentRequestFail:(LCDEvent *)event {
    LCS_REQUEST_EVENT_CALLBACK_LOG(@"news request fail");
}

#pragma mark - LCDPlayerCallBackProtocol
- (void)drawVideoStartPlay:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video start play");
}

- (void)drawVideoPlayCompletion:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video play completion");
}

- (void)drawVideoOverPlay:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video over play");
}

- (void)drawVideoPause:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video pause");
}

- (void)drawVideoContinue:(UIViewController *)viewController event:(LCDEvent *)event {
    LCS_PLAYER_CALLBACK_LOG(@"draw video continue");
}

#pragma mark - LCDUserInteractionCallBackProtocol
- (void)lcdClickAuthorAvatarEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click author avatar");
}

- (void)lcdClickAuthorNameEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click author name");
}

- (void)lcdClickLikeButton:(BOOL)isLike event:(LCDEvent *)event {
    NSString *desc = [NSString stringWithFormat:@"click like button, isLike:%d", isLike];
    LCS_COVER_CALLBACK_LOG(desc);
}

- (void)lcdClickCommentButtonEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click comment button");
}

- (void)lcdClickShareShareEvent:(LCDEvent *)event {
    LCS_COVER_CALLBACK_LOG(@"click share share");
}

#pragma mark - LCDAdvertCallBackProtocol
- (void)lcdSendAdRequest:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"send ad request");
}

- (void)lcdAdLoadSuccess:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad load success");
}

- (void)lcdAdLoadFail:(LCDAdTrackEvent *)event error:(NSError *)error {
    LCS_AD_CALLBACK_LOG(@"ad load fail");
}

- (void)lcdAdFillFail:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad fill fail");
}

- (void)lcdAdWillShow:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"ad will show");
}

- (void)lcdVideoAdStartPlay:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad start play");
}

- (void)lcdVideoAdPause:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad pause");
}

- (void)lcdVideoAdContinue:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad continue");
}

- (void)lcdVideoAdOverPlay:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"video ad over play");
}

- (void)lcdClickAdViewEvent:(LCDAdTrackEvent *)event {
    LCS_AD_CALLBACK_LOG(@"click ad view");
}
@end
