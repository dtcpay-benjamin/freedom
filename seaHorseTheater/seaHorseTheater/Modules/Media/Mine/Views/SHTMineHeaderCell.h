//
//  SHTMineHeaderCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/22.
//

#import <UIKit/UIKit.h>
#import "SHTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SHTMineModel;

@interface SHTMineHeaderCell : SHTTableViewCell

@property(nonatomic, strong) SHTMineModel *model; // 数据模型

@end

NS_ASSUME_NONNULL_END
