//
//  BUDActionCellView.h
//  BUAdSDKDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCSTabViewController.h"
#import "LCSChannelViewController.h"

typedef NS_ENUM(NSInteger, LCSCellType) {
    LCSCellType_video             = 1,       // video
    LCSCellType_setting,                     // setting
    LCSCellType_grid,                        // grid
    LCSCellType_feedExplor,                  // feedExplor
    LCSCellType_videoCard,                   // videoCard
    LCSCellType_feedPraised,                 // 信息流点赞列表
    LCSCellType_feedFavorit,                 // 信息流收藏列表
    LCSCellType_push,                        // push
    LCSCellType_live,                        // 直播
    LCSCellType_bind,                        // 绑定抖音
    LCSCellType_unbind,                      // 解除绑定
    LCSCellType_mine,                        // 我的
    LCSCellType_shortPlay,                    // 短剧
    LCSCellType_story,                        // 短故事
};

typedef NS_ENUM(NSUInteger, LCSCellContainerVCType) {
    LCSCellContainerVCTypeSingle,
    LCSCellContainerVCTypeCustomRefresh,
    LCSCellContainerVCTypeStay,
    LCSCellContainerVCTypeTab,
    LCSCellContainerVCTypeChannel,
    LCSCellContainerVCTypeCustomTopView,
    LCSCellContainerVCTypeBanner,
    LCSCellContainerVCTypeRoundCorner
};

@interface LCSActionModel : NSObject
+ (instancetype)plainTitleActionModel:(NSString *)title cellType:(LCSCellType)type action:(dispatch_block_t)action;

+ (instancetype)plainTitleActionModel:(NSString *)title cellType:(LCSCellType)cellType containerVCType:(LCSCellContainerVCType)containerVCType rootVC:(UIViewController *)rootVC modelVCBuilder:(UIViewController *(^)(__kindof UIViewController *parentVC))modelVCBuilder;
@end

@interface LCSActionCellView : UITableViewCell
- (void)configWithModel:(LCSActionModel *)model;
- (void)execute;
@end
