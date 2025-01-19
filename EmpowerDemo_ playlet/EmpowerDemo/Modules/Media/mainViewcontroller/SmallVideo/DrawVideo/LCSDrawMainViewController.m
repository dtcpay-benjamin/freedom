//
//  LCSDrawMainViewController.m
//  LCDSamples
//
//  Created by iCuiCui on 2020/7/29.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSDrawMainViewController.h"
#import <LCDSDK/LCDSDK.h>
#import "LCSMacros.h"
#import "UIView+LCSAddition.h"
#import "LCSChannelViewController.h"
#import "LCSTabViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "LCSDrawMoreAlertViewController.h"
#import "MBProgressHUD+Toast.h"
#import <Reachability/Reachability.h>
#import "LCSDrawSimulateShareViewController.h"
#import "LCSDrawCustomTopTabViewController.h"

NSNotificationName _Nonnull const kLCSDrawMainVCAddCellsNotification = @"kLCSDrawMainVCAddCellsNotification";

@interface LCSDrawMainViewController ()<LCDDrawVideoViewControllerDelegate , LCDAdvertCallBackProtocol >

@end

@implementation LCSDrawMainViewController

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *videoModel_Ad = [LCSActionModel plainTitleActionModel:@"小视频" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCDDrawVideoViewController *vc = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            lcs_strongify(self)
            config.showCloseButton = YES;
            config.out_bottomOffset = 5;
            config.delegate = self;
            config.adDelegate = self;
            }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:vc animated:YES completion:^{
        }];
    }];
    
    LCSActionModel *videoModel_customRefresh = [LCSActionModel plainTitleActionModel:@"小视频(自定义刷新)" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCDDrawVideoViewController *vc = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            lcs_strongify(self)
            
//            config.navBarInset.top = 80;
//            config.navBarInset.buttonLeft = 50;
//            config.navBarInset.buttonRight = 50;
//            config.recommandTabName = @"测试";
            config.customRefresh = YES;
            config.showCloseButton = YES;
            config.out_bottomOffset = 5;
            config.delegate = self;
            config.adDelegate = self;
            config.configScrollViewsBlock = ^(LCDDrawVideoViewController *vc, UIScrollView * _Nonnull dataView, NSUInteger atIndex) {
                lcs_weakify(vc)
                lcs_weakify(dataView)
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    lcs_strongify(vc)
                    [vc refreshDataWithCompletion:^(NSError * _Nullable error) {
                        lcs_strongify(dataView)
                        [dataView.mj_header endRefreshing];
                    }];
                }];
                header.stateLabel.textColor = UIColor.whiteColor;
                header.lastUpdatedTimeLabel.hidden = YES;
                dataView.mj_header = header;
            };
        }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:vc animated:YES completion:^{
        }];
    }];

    
    LCSActionModel *videoModel_channel = [LCSActionModel plainTitleActionModel:@"小视频（频道页版）" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCDDrawVideoViewController *drawVC = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            lcs_strongify(self)
            config.navBarInset.top = 0;
            config.delegate = self;
            config.adDelegate = self;
//            config.customAppear = YES;// 需要自定义展示和隐藏
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_navBarHeight-38);
            config.adDelegate = self;
            }];
        
        LCSChannelViewController *vc = [LCSChannelViewController new];
        vc.categoryName = @"小视频";
        vc.categoryController = drawVC;
        vc.categoryWillAppear = ^{
            [drawVC drawVideoViewControllerDidAppear];
        };
        vc.categoryWillDisAppear = ^{
            [drawVC drawVideoViewControllerDidDisappear];
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *videoModel_tab = [LCSActionModel plainTitleActionModel:@"小视频（tab版）" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCDDrawVideoViewController *drawVC = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            lcs_strongify(self)
            config.delegate = self;
            config.adDelegate = self;
            config.hiddenGuideGeste = YES;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_tabBarHeight);
            config.progressBarStyle = LCDDrawVideoProgressBarStyleLightContent;
            config.adDelegate = self;
            }];
        
        LCSTabViewController *vc = [LCSTabViewController new];
        vc.tabName = @"小视频";
        vc.tabController = drawVC;
        vc.blackStyle = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
        
    }];
    
    LCSActionModel *videoModel_stay = [LCSActionModel plainTitleActionModel:@"小视频（带挽留）" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCDDrawVideoViewController *vc = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            lcs_strongify(self)
            config.delegate = self;
            config.adDelegate = self;
            config.hiddenGuideGeste = YES;
            config.out_bottomOffset = LCS_bottomHeight + 20;
            config.showCloseButton = NO;
            config.adDelegate = self;
            }];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"LCS_closeButton"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(15, LCS_stautsBarHeight + 10 + 6, 24, 24);
        [backButton addTarget:self action:@selector(didClickDrawBackButton:) forControlEvents:UIControlEventTouchUpInside];
        backButton.relatedViewController = vc;
        [self presentViewController:vc animated:YES completion:^{
            [vc.view addSubview:backButton];
        }];
    }];
    
    LCSActionModel *videoModel_share = [LCSActionModel plainTitleActionModel:@"小视频（模拟分享进入）" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSTabViewController *tabVc = [LCSTabViewController new];

        LCDDrawVideoViewController *drawVC = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
            config.showCloseButton = NO;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_tabBarHeight);
        }];
        tabVc.firstTabController = drawVC;

        LCSDrawSimulateShareViewController *simulateShareVc = [[LCSDrawSimulateShareViewController alloc] init];
        tabVc.tabName = @"分享";
        tabVc.tabController = simulateShareVc;
        tabVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tabVc animated:NO completion:nil];
        
        lcs_weakify(drawVC)
        lcs_weakify(simulateShareVc)
        lcs_weakify(tabVc)
        simulateShareVc.tapBlock = ^{
            lcs_strongify(drawVC)
            lcs_strongify(simulateShareVc)
            lcs_strongify(tabVc)
            drawVC.shareAwakeDataGroupID = simulateShareVc.groupId;
            [tabVc selectedfirstController];
        };
        simulateShareVc.tapNewVideoBlock = ^{
            lcs_strongify(simulateShareVc)
            lcs_strongify(tabVc)
            LCDDrawVideoViewController *newdrawVC = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
                lcs_strongify(simulateShareVc)
                config.showCloseButton = YES;
                config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_tabBarHeight);
                config.initShareAwakeDataGroupID = simulateShareVc.groupId;
            }];
            newdrawVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [tabVc presentViewController:newdrawVC animated:NO completion:nil];
        };
    }];
    
    LCSActionModel *videoModel_customTab = [LCSActionModel plainTitleActionModel:@"小视频（自定义tab）" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSDrawCustomTopTabViewController *customTopTabSelectVC = [LCSDrawCustomTopTabViewController new];
        
        customTopTabSelectVC.enterDrawVideoAction = ^(LCSDrawCustomTopTabViewController * _Nonnull tabSelectVC) {
            LCDDrawVideoViewController *vc = [[LCDDrawVideoViewController alloc] initWithConfigBuilder:^(LCDDrawVideoVCConfig * _Nonnull config) {
                lcs_strongify(self)
                config.drawVCTabOptions = tabSelectVC.drawVCTabOptions;
                config.shouldDisableFollowingFunc = tabSelectVC.shouldDisableFollowingFunc;
                config.shouldHideTabBarView = tabSelectVC.shouldHideTabBarView;
                
                config.showCloseButton = YES;
                config.out_bottomOffset = 5;
                config.delegate = self;
                config.adDelegate = self;
                config.configScrollViewsBlock = ^(LCDDrawVideoViewController *vc, UIScrollView * _Nonnull dataView, NSUInteger atIndex) {
                    lcs_weakify(vc)
                    lcs_weakify(dataView)
                    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        lcs_strongify(vc)
                        [vc refreshDataWithCompletion:^(NSError * _Nullable error) {
                            lcs_strongify(dataView)
                            [dataView.mj_header endRefreshing];
                        }];
                    }];
                    header.stateLabel.textColor = UIColor.whiteColor;
                    header.lastUpdatedTimeLabel.hidden = YES;
                    dataView.mj_header = header;
                };
            }];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            lcs_strongify(self)
            [self presentViewController:vc animated:YES completion:^{
            }];
        };
        
        [self.navigationController pushViewController:customTopTabSelectVC animated:NO];
    }];
    

    self.items = [NSMutableArray arrayWithObject:@[videoModel_Ad, videoModel_customRefresh,videoModel_channel,videoModel_tab,videoModel_stay,videoModel_share,videoModel_customTab]];
    [self addCells];
}

- (void)addCells {
    [NSNotificationCenter.defaultCenter postNotificationName:kLCSDrawMainVCAddCellsNotification
                                                      object:@{
        @"vc": self,
        @"cellModelArray": self.items
    }];
}

static NSTimeInterval lastClickBackTime;
- (void)didClickDrawBackButton:(UIButton *)button {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (lastClickBackTime == 0 || now - lastClickBackTime > 3) {// 第一次触发刷新
        lastClickBackTime = [[NSDate date] timeIntervalSince1970];
        LCDDrawVideoViewController *vc = (LCDDrawVideoViewController *)button.relatedViewController;
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

- (void)didClickReportContentBackButton:(UIButton *)button {
    [button.relatedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportContent:(UIButton *)button {
    LCDDrawVideoViewController *vc = (LCDDrawVideoViewController *)button.relatedViewController;
    lcs_weakify(vc)
    LCSDrawMoreAlertViewController *alertMore = [[LCSDrawMoreAlertViewController alloc] initWithDidClickReportBtn:^{
        lcs_strongify(vc)
        UIViewController<LCDReportContentViewController> *reportVC = [vc createReportContentViewController];
        reportVC.navigationItem.title = @"举报";
        reportVC.navigationItem.leftBarButtonItem = ({
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(15, 15, 24, 24);
            [backButton setImage:[UIImage imageNamed:@"LCS_back"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(didClickReportContentBackButton:) forControlEvents:UIControlEventTouchUpInside];
            backButton.relatedViewController = reportVC;
            [[UIBarButtonItem alloc] initWithCustomView:backButton];
        });

        lcs_weakify(reportVC)
        reportVC.reportContentCompletionHandler = ^(BOOL isSuccess, LCDEvent * _Nonnull event) {
            lcs_strongify(reportVC)
            NSString *desc = [NSString stringWithFormat:@"report complete, isSuccess:%d, event:%@", isSuccess, [event toJSONString]];
            LCS_LOG_WITH_TAG(@"【Draw-event】", desc);
            if (isSuccess) {
                [MBProgressHUD showToast:@"举报成功" dismissAfterDelay:2.f];
                [reportVC dismissViewControllerAnimated:YES completion:nil];
            } else {
                if (Reachability.reachabilityForInternetConnection.currentReachabilityStatus == NotReachable) {
                    [MBProgressHUD showToast:@"举报失败，请检查网络" dismissAfterDelay:2.f];
                } else {
                    [MBProgressHUD showToast:@"举报失败，请重试" dismissAfterDelay:2.f];
                }
            }
        };
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:reportVC];
        nc.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:nc animated:YES completion:nil];
    }];
    [vc presentViewController:alertMore animated:YES completion:nil];
}

#pragma mark - LCDDrawVideoViewControllerDelegate
- (void)drawVideoDidClickedErrorButtonRetry:(UIViewController *)viewController {
    LCS_Log(@"LCSCallBack【Draw-event】 retry button click");
}

- (void)drawVideoCloseButtonClicked:(UIViewController *)viewController {
    LCS_Log(@"LCSCallBack【Draw-event】 close button clicked");
}

- (void)drawVideoCurrentVideoChanged:(UIViewController *)viewController event:(LCDEvent *)event {
    NSString *desc = [NSString stringWithFormat:@", currentPageIdx=%@", event.params[@"position"]];
    LCS_COMMON_CALLBACK_LOG(@"【Draw-event】", @"currentPageChanged", desc);
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
- (void)drawVideoDataRefreshCompletion:(NSError *)error {
    NSString *desc = @"new data refresh completion";
    if (error) {
        desc = [desc stringByAppendingFormat:@" with error: %@", error.localizedDescription];
    }
    LCS_LOG_WITH_TAG(@"【Draw-event】", desc);
}

@end
