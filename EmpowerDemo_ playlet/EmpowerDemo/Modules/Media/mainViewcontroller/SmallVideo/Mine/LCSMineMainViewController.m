//
//  LCSMineMainViewController.m
//  LCDSamples
//
//  Created by 崔亚楠 on 2021/9/25.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSMineMainViewController.h"
#import "LCSMeInfoViewController.h"
#import <LCDSDK/LCDSDK.h>
#import "LCSMacros.h"

@interface LCSMineMainViewController ()<LCDAccessUserFollowListViewControllerDelegate,LCDAccessUserLikeListViewControllerDelegate,LCDRequestCallBackProtocol,LCDPlayerCallBackProtocol,LCDUserInteractionCallBackProtocol>

@end

@implementation LCSMineMainViewController

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *mineModel = [LCSActionModel plainTitleActionModel:@"我的（完整版）" cellType:LCSCellType_mine action:^{
        lcs_strongify(self)
        LCDAccessUserCenterViewController *mineVc = [[LCDAccessUserCenterViewController alloc] initWithConfigBuilder:^(LCDAccessUserCenterVCConfig * _Nonnull config) {
            lcs_strongify(self)
            
            config.delegate = self;
            config.viewSize = CGSizeMake(LCSScreenWidth, LCSScreenHeight-LCS_tabBarHeight);
        }];
        
        LCSTabViewController *vc = [LCSTabViewController new];
        vc.mineTabController = mineVc;
        vc.blackStyle = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *meModel = [LCSActionModel plainTitleActionModel:@"我的信息" cellType:LCSCellType_mine action:^{
        lcs_strongify(self)
        LCSMeInfoViewController *vc = [LCSMeInfoViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *likeModel = [LCSActionModel plainTitleActionModel:@"我的喜欢" cellType:LCSCellType_mine action:^{
        lcs_weakify(self)
        LCSTabViewController *vc = [LCSTabViewController new];
        LCDAccessUserLikeListViewController *mineVc = [[LCDAccessUserLikeListViewController alloc] initWithConfigBuilder:^(LCDAccessUserLikeListVConfig * _Nonnull config) {
            lcs_strongify(self)
            config.delegate = self;
            config.viewSize = CGSizeMake(LCSScreenWidth-100, 400);
            config.rootViewController = vc;
        }];
        
        vc.mineTabController = mineVc;
        vc.blackStyle = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    LCSActionModel *followModel = [LCSActionModel plainTitleActionModel:@"我的关注" cellType:LCSCellType_mine action:^{
        lcs_weakify(self)
        LCSTabViewController *vc = [LCSTabViewController new];

        LCDAccessUserFollowListViewController *mineVc = [[LCDAccessUserFollowListViewController alloc] initWithConfigBuilder:^(LCDAccessUserFollowListVCConfig * _Nonnull config) {
            lcs_strongify(self)
            config.delegate = self;
            config.viewSize = CGSizeMake(LCSScreenWidth-100, 400);
            config.rootViewController = vc;
        }];
        
        vc.mineTabController = mineVc;
        vc.blackStyle = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{}];
    }];
    
    self.items = @[@[mineModel],@[meModel,likeModel,followModel]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - LCDAccessUserFollowListViewControllerDelegate

- (void)accessUserFollowListViewControllerScrollViewDidScroll:(UIScrollView *)scrollView {
    LCS_LOG_WITH_TAG(nil, @"follow ScrollViewDidScroll");
}

#pragma mark - LCDAccessUserLikeListViewControllerDelegate
- (void)accessUserLikeListViewControllerScrollViewDidScroll:(UIScrollView *)scrollView {
    LCS_LOG_WITH_TAG(nil, @"like ScrollViewDidScroll");
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

@end
