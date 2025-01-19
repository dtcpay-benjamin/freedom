//
//  LCSPlayletCardDemoViewController.h
//  EmpowerDemo
//
//  Created by admin on 2023/5/30.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSPlayletCardDemoViewController : UIViewController

@property (nonatomic) NSInteger skit_id;

@property (nonatomic) BOOL autoplay;

@property (nonatomic) BOOL mute;

@property (nonatomic) BOOL loop;

@property (nonatomic) BOOL hideUI;

@property (nonatomic) BOOL hidePlayButton;

@property (nonatomic) BOOL hideMuteButton;

@property (nonatomic) CGFloat cardWith;

@end

NS_ASSUME_NONNULL_END
