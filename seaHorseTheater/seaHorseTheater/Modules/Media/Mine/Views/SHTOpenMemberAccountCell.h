//
//  SHTOpenMemberAccountTableViewCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 7/23/25.
//

#import "SHTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class SHTMineModel;

@interface SHTOpenMemberAccountCell : SHTTableViewCell

@property (nonatomic, strong) void (^openMemberAccountTapped)(void); // 开通会员点击回调
@property (nonatomic, strong) SHTMineModel *model;

@end

NS_ASSUME_NONNULL_END
