//
//  LCSGridMainViewController.m
//  LCDSamples
//
//  Created by iCuiCui on 2020/7/29.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSGridMainViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import <LCDSDK/LCDSDK.h>
#import "LCSMacros.h"
#import "UIView+LCSAddition.h"

@interface LCSGridMainViewController ()<LCDGridVideoViewControllerDelegate , LCDAdvertCallBackProtocol >

@end

@implementation LCSGridMainViewController

- (void)buildCells {
    self.items = @[@[[self buildActionModelForType:LCSCellContainerVCTypeSingle],
                     [self buildActionModelForType:LCSCellContainerVCTypeCustomRefresh],
                     [self buildActionModelForType:LCSCellContainerVCTypeStay],
                     [self buildActionModelForType:LCSCellContainerVCTypeChannel],
                     [self buildActionModelForType:LCSCellContainerVCTypeTab]]];
}

- (LCDGridVideoViewController *)buildGridVCWithCustomAppear:(BOOL)customAppear customRefresh:(BOOL)customRefresh  gridType:(LCDGridVideoVCType)gridType {
    LCDGridVideoViewController *gridVC = [[LCDGridVideoViewController alloc] initWithConfigBuilder:^(LCDGridVideoVCConfig * _Nonnull config) {
        if (gridType == LCDGridVideoVCType_waterfall) {
            // 自定义距离屏幕顶部的高度
            config.contentInset = UIEdgeInsetsMake(LCS_stautsBarHeight + 16, 0, 0, 0);
        } else {
//            config.contentInset = UIEdgeInsetsMake(LCS_stautsBarHeight, 0, 0, 0);
        }
        config.gridVideoVCType = gridType;
        config.delegate = self;
        config.adDelegate = self;
        // gridVC放到tab里的时候，才有可能需要令customAppear = YES;
        config.customAppear = customAppear;
        config.customRefresh = customRefresh;
    }];
    return gridVC;
}

- (LCDGridVideoViewController *)buildGridVCWithCustomAppear:(BOOL)customAppear {
    return [self buildGridVCWithCustomAppear:customAppear customRefresh:NO gridType:LCDGridVideoVCType_grid];
}

- (LCSActionModel *)buildActionModelForType:(LCSCellContainerVCType)containerType title:(NSString *)title gridType:(LCDGridVideoVCType)gridType {
    lcs_weakify(self)
    switch (containerType) {
        case LCSCellContainerVCTypeSingle:
        {
            return [LCSActionModel plainTitleActionModel:title cellType:LCSCellType_grid action:^{
                lcs_strongify(self)
                LCDGridVideoViewController *gridVC = [self buildGridVCWithCustomAppear:NO customRefresh:NO gridType:gridType];
                gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
                UIButton *closeButton = [self createCloseButtonWithRelatedVC:gridVC];
                [gridVC.view addSubview:closeButton];
                [self presentViewController:gridVC animated:YES completion:^{
                }];
            }];
        }
        case LCSCellContainerVCTypeCustomRefresh:
        {
            return [LCSActionModel plainTitleActionModel:@"宫格（自定义刷新）" cellType:LCSCellType_grid action:^{
                lcs_strongify(self)
                LCDGridVideoViewController *gridVC = [self buildGridVCWithCustomAppear:NO customRefresh:YES gridType:gridType];
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
                    if (gridType == LCDGridVideoVCType_waterfall) {
                        header.ignoredScrollViewContentInsetTop = LCS_stautsBarHeight + 16;
                    }
                    
                    gridVC.dataView.mj_header = header;
                }];
            }];
        }
            break;
        case LCSCellContainerVCTypeStay:
        {
            return [LCSActionModel plainTitleActionModel:@"宫格(带挽留)" cellType:LCSCellType_grid action:^{
                lcs_strongify(self)
                LCDGridVideoViewController *gridVC = [self buildGridVCWithCustomAppear:NO];
                gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
                UIButton *closeButton = [self createStayCloseButtonWithRelatedVC:gridVC];
                [gridVC.view addSubview:closeButton];
                [self presentViewController:gridVC animated:YES completion:^{
                    
                }];
            }];
        }
        case LCSCellContainerVCTypeChannel:
        {
            return [LCSActionModel plainTitleActionModel:title
                                                cellType:LCSCellType_grid containerVCType:LCSCellContainerVCTypeChannel
                                                  rootVC:self
                                          modelVCBuilder:^UIViewController *(LCSChannelViewController *parentVC) {
                lcs_strongify(self)
                LCDGridVideoViewController *gridVC = [self buildGridVCWithCustomAppear:YES customRefresh:NO gridType:gridType];
                parentVC.categoryWillAppear = ^{
                    [gridVC gridVideoViewControllerDidAppear];
                };
                parentVC.categoryWillDisAppear = ^{
                    [gridVC gridVideoViewControllerDidDisappear];
                };
                gridVC.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_navBarHeight-38);
                return gridVC;
            }];
        }
        case LCSCellContainerVCTypeTab:
        {
            return [LCSActionModel plainTitleActionModel:title cellType:LCSCellType_grid containerVCType:LCSCellContainerVCTypeTab rootVC:self modelVCBuilder:^UIViewController *(UIViewController *parentVC) {
                lcs_strongify(self)
                LCDGridVideoViewController *gridVC = [self buildGridVCWithCustomAppear:NO customRefresh:NO  gridType:gridType];
                gridVC.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_tabBarHeight);
                return gridVC;
            }];
        }
        default:
            return nil;
    }
}

- (UIButton *)createStayCloseButtonWithRelatedVC:(UIViewController *)relatedVC  {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.relatedViewController = relatedVC;
    closeButton.frame = CGRectMake(15, LCS_stautsBarHeight, 24, 24);
    [closeButton setImage:[UIImage imageNamed:@"LCS_closeButton_black"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"LCS_closeButton_black"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(didClickStayCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

static NSTimeInterval lastClickBackTime;

- (void)didClickStayCloseButton:(UIButton *)button {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (lastClickBackTime == 0 || now - lastClickBackTime > 3) {// 第一次触发刷新
        lastClickBackTime = [[NSDate date] timeIntervalSince1970];
        LCDGridVideoViewController *vc = (LCDGridVideoViewController *)button.relatedViewController;
        lcs_weakify(vc)
        [vc refreshDataToStayUserWithCompletion:^(NSError * _Nullable error) {
            lcs_strongify(vc)
            [vc showToastToStayUser];
        }];
    } else if (now - lastClickBackTime <= 3) { // 3s以内重复点击 直接退出
        [button.relatedViewController dismissViewControllerAnimated:YES completion:^{
            lastClickBackTime = 0;
        }];
    }
}

- (LCSActionModel *)buildActionModelForType:(LCSCellContainerVCType)containerType {
    return [self buildActionModelForType:containerType title:@"宫格" gridType:LCDGridVideoVCType_grid];
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
