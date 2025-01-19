//
//  LCSVideoCardDislikeView.h
//  EmpowerDemo
//
//  Created by yuxr on 2021/12/17.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCDSDK/LCDSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSVideoCardDislikeView : UIView<LCDVideoCardProviderDislikeView>

@property (nonatomic) UIButton *customMaskView;
@property (nonatomic) UIButton *dislikeBtn;
@property (nonatomic) void (^dislikeActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
