//
//  LCSBaseSettingCell.h
//  DJXSamples
//
//  Created by yuxr on 2020/8/18.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSBaseSettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, copy) void(^didSelectCellBlock)(LCSBaseSettingCell *cell);

@end

NS_ASSUME_NONNULL_END
