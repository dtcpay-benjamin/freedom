//
//  LCSDrawCustomTopTabViewController.h
//  EmpowerDemo
//
//  Created by yuxr on 2021/12/29.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCDSDK/LCDSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSDrawCustomTopTabViewController : UIViewController

@property (nonatomic) LCDDrawVideoVCTabOptions drawVCTabOptions;
@property (nonatomic) BOOL shouldDisableFollowingFunc;
@property (nonatomic) BOOL shouldHideTabBarView;

@property (nonatomic) void(^enterDrawVideoAction)(LCSDrawCustomTopTabViewController *vc);

@end

NS_ASSUME_NONNULL_END
