//
//  LCSMainViewController.h
//  DJXSamples
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSBaseActionTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName _Nonnull const kLCSMainVCDidLoadNotification;
FOUNDATION_EXPORT NSNotificationName _Nonnull const kLCSMainVCAddCellsNotification;

@interface LCSMainViewController : LCSBaseActionTableViewController

@property (nonatomic, strong) UILabel *versionLabel;

@end

NS_ASSUME_NONNULL_END
