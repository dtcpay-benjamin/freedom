//
//  LCSSwitchSettingCell.h
//  DJXSamples
//
//  Created by yuxr on 2020/8/18.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSBaseSettingCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSSwitchSettingCell : LCSBaseSettingCell

@property (nonatomic) UISwitch *switchView;
@property (nonatomic) void (^swithValueDidChanged)(UISwitch *switchView);

@end

NS_ASSUME_NONNULL_END
