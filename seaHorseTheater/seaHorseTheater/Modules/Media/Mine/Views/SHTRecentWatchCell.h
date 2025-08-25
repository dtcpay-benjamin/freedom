//
//  SHTRecentWatchCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/25.
//

#import "SHTCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class DJXPlayletInfoModel;

@interface SHTRecentWatchCell : SHTCollectionViewCell

@property (nonatomic, strong)DJXPlayletInfoModel *model;

@end

NS_ASSUME_NONNULL_END
