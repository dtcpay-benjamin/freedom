//
//  SHTOthersCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/25.
//

#import "SHTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHTOthersCell : SHTTableViewCell

@property (nonatomic, strong) void (^enterNextTapped)(NSString *id); // 进入下一页面点击回调
@property (nonatomic, copy) NSMutableArray *datasArray;

@end

NS_ASSUME_NONNULL_END
