//
//  LCSSmallVideoMainViewController.m
//  Samples
//
//  Created by yuxr on 2020/9/6.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSSmallVideoMainViewController.h"
#import "LCSDrawMainViewController.h"
#import <LCDSDK/LCDDrawVideoViewController.h>
#import "LCSGridMainViewController.h"
#import "LCSWaterfallViewController.h"
#import "LCSVideoSingleCardViewController.h"
#import "LCSNewsVideoSingleCardViewController.h"
#import "LCSVideoCardViewController.h"
#import "LCSCustomSizeVideoCardViewController.h"
#import "LCSHotNewsViewController.h"
#import "LCSMineMainViewController.h"
#import "LCSSamllVideoWatchVideoVC.h"
#import "LCSSmallVideoSettingViewController.h"
#import <LCDSDK/LCDSDK.h>

@interface LCSSmallVideoMainViewController ()

@end

@implementation LCSSmallVideoMainViewController

- (void)buildCells {
    lcs_weakify(self)
    LCSActionModel *drawVideoModel = [LCSActionModel plainTitleActionModel:@"沉浸式" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSDrawMainViewController *vc = [LCSDrawMainViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *gridVideoModel = [LCSActionModel plainTitleActionModel:@"宫格" cellType:LCSCellType_grid action:^{
        lcs_strongify(self)
        LCSGridMainViewController *vc = [LCSGridMainViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    LCSActionModel *waterfallModel = [LCSActionModel plainTitleActionModel:@"双feed" cellType:LCSCellType_grid action:^{
        lcs_strongify(self)
        LCSWaterfallViewController *vc = [LCSWaterfallViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *singleCardModel = [LCSActionModel plainTitleActionModel:@"小视频单卡片" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSVideoSingleCardViewController *vc = [LCSVideoSingleCardViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *singleCardFeedModel = [LCSActionModel plainTitleActionModel:@"小视频单卡片（信息流）" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSNewsVideoSingleCardViewController *vc = [LCSNewsVideoSingleCardViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *videoCardListModel = [LCSActionModel plainTitleActionModel:@"小视频1.4图卡片" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSVideoCardViewController *vc = [LCSVideoCardViewController new];
        vc.videoCardType = LCDVideoCardTypeDefault;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *videoCardList_2_4_Model = [LCSActionModel plainTitleActionModel:@"小视频2.4图卡片" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSVideoCardViewController *vc = [LCSVideoCardViewController new];
        vc.videoCardType = LCDVideoCardType2_4;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *videoCardList_2_4_customModel = [LCSActionModel plainTitleActionModel:@"小视频2.4图卡片(自定义高度)" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSCustomSizeVideoCardViewController *vc = [LCSCustomSizeVideoCardViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *hotNewsModel = [LCSActionModel plainTitleActionModel:@"热门推荐" cellType:LCSCellType_videoCard action:^{
        lcs_strongify(self)
        LCSHotNewsViewController *vc = [LCSHotNewsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *mineModel = [LCSActionModel plainTitleActionModel:@"我的" cellType:LCSCellType_mine action:^{
        lcs_strongify(self)
        LCSMineMainViewController *vc = [LCSMineMainViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *settingModel = [LCSActionModel plainTitleActionModel:@"小视频设置" cellType:LCSCellType_setting action:^{
        lcs_strongify(self)
        LCSSmallVideoSettingViewController *vc = [LCSSmallVideoSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *control_mode = [LCSActionModel plainTitleActionModel:@"体验一起看视频" cellType:LCSCellType_video action:^{
        LCSSamllVideoWatchVideoVC *vc = [[LCSSamllVideoWatchVideoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.items = @[
        @[drawVideoModel],
        @[gridVideoModel],
        @[waterfallModel],
        @[control_mode],
        @[singleCardModel,
          singleCardFeedModel],
        @[videoCardListModel,
          videoCardList_2_4_Model,
          videoCardList_2_4_customModel],
        @[hotNewsModel],
        @[mineModel],
        @[settingModel]
    ];
}


@end
