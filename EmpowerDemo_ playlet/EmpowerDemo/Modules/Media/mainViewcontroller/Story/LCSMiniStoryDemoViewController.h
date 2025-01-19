//
//  LCSMiniStoryDemoViewController.h
//  EmpowerDemo
//
//  Created by admin on 2023/12/8.
//  Copyright © 2023 bytedance. All rights reserved.
//
#if __has_include (<PangrowthMiniStory/MNManager.h>)
#import <UIKit/UIKit.h>
#import <PangrowthMiniStory/MNStoryManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSCustomRewardEntryView : UIView <MNStoryRewardADEntryViewProtocol>

@property (nonatomic) UIButton *myButton;

@end

@interface LCSMiniStoryDemoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
#endif
