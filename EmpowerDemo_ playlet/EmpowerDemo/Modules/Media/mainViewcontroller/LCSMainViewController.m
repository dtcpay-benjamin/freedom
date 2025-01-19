//
//  LCSMainViewController.m
//  DJXSamples
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "LCSMainViewController.h"
#import "LCSSettingViewController.h"
#import <RangersAppLog/BDAutoTrack.h>
#import "LCSPlayletMainViewController.h"
#import "LCSStoryMainViewController.h"
#import "LCSLoginViewController.h"
#import "MBProgressHUD+Toast.h"
#import "LCSSmallVideoMainViewController.h"
#if __has_include (<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif
#if __has_include (<PangrowthDJX/DJXSDK.h>)
#import <PangrowthDJX/DJXSDK.h>
#endif
NSNotificationName _Nonnull const kLCSMainVCDidLoadNotification   = @"kLCSMainVCDidLoadNotification";
NSNotificationName _Nonnull const kLCSMainVCAddCellsNotification  = @"kLCSMainVCAddCellsNotification";

#if __has_include (<PangrowthDJX/DJXSDK.h>)
@interface LCSMainViewController () <DJXDrawVideoViewControllerDelegate>
#else
@interface LCSMainViewController ()
#endif

@property (nonatomic, strong) UIViewController *reportReasonViewController;

@end

@implementation LCSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Bytedance Samples";
    
    [self buidVersionLabel];
    [NSNotificationCenter.defaultCenter postNotificationName:kLCSMainVCDidLoadNotification object:nil userInfo:@{@"vc": self}];
}

- (void)buildCells {
    lcs_weakify(self)
    
    NSMutableArray *items = [NSMutableArray array];
    
    LCSActionModel *playletModel = [LCSActionModel plainTitleActionModel:@"短剧" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSPlayletMainViewController *vc = [[LCSPlayletMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [items addObject:@[playletModel]];
    
    LCSActionModel *storyModel = [LCSActionModel plainTitleActionModel:@"短故事" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSStoryMainViewController *vc = [[LCSStoryMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [items addObject:@[storyModel]];
    
    LCSActionModel *videoModel = [LCSActionModel plainTitleActionModel:@"小视频" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSSmallVideoMainViewController *vc = [LCSSmallVideoMainViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [items addObject:@[videoModel]];
    
    LCSActionModel *loginModel = [LCSActionModel plainTitleActionModel:@"登录" cellType:LCSCellType_video action:^{
        LCSLoginViewController *vc = [[LCSLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [items addObject:@[loginModel]];
    
    LCSActionModel *settingModel = [LCSActionModel plainTitleActionModel:@"设置" cellType:LCSCellType_setting action:^{
        lcs_strongify(self)
        LCSSettingViewController *vc = [LCSSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [items addObject:@[settingModel]];

    self.items = items.copy;
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLCSMainVCAddCellsNotification object:nil userInfo:@{
        @"mainVC": self,
        @"itemsArray": self.items
    }];
}

- (void)buidVersionLabel {
    self.versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    self.versionLabel.numberOfLines = 3;
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    
#if __has_include (<PangrowthDJX/DJXSDK.h>)
    self.versionLabel.text = [NSString stringWithFormat:@"DJXSDK：%@\nAppLog：%@", [DJXManager SDKVersion], [BDAutoTrack SDKVersion]];
#endif
#if __has_include (<BUAdSDK/BUAdSDK.h>)
    self.versionLabel.text = [NSString stringWithFormat:@"BUAdSDK：%@\n%@", [BUAdSDKManager SDKVersion], self.versionLabel.text];
#endif
    [self.versionLabel sizeToFit];
    self.versionLabel.lcs_centerX = self.tableView.lcs_width / 2.0;
    self.versionLabel.lcs_bottom = self.tableView.lcs_height - LCS_navBarHeight - LCS_tabBarHeight - self.versionLabel.height - 10;
    self.versionLabel.textColor = [UIColor grayColor];
    [self.tableView addSubview:self.versionLabel];
}

@end
