//
//  LCSTabViewController.h
//  DJXSamples
//
//  Created by iCuiCui on 2020/7/29.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSTabViewController : UIViewController

@property (nonatomic, strong) UIViewController *firstTabController;

@property (nonatomic, assign) NSString *tabName;
@property (nonatomic, strong) UIViewController *tabController;

@property (nonatomic, strong) UIViewController *mineTabController;

@property (nonatomic, assign) BOOL blackStyle;

- (void)selectedTabController;
- (void)selectedfirstController;

@end

NS_ASSUME_NONNULL_END
