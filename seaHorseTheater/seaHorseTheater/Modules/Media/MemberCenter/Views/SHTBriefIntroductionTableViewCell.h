//
//  SHTBriefIntroductionTableViewCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/30.
//

#import <UIKit/UIKit.h>
#import "SHTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SHTBriefIntroductionModel;

@interface SHTBriefIntroductionTableViewCell : SHTTableViewCell

@property (nonatomic, strong) SHTBriefIntroductionModel *model;

@end

NS_ASSUME_NONNULL_END
