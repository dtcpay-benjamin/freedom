//
//  DJXPlayletInfoModel+SHTFavorite.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/8/14.
//

#import <PangrowthDJX/PangrowthDJX.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJXPlayletInfoModel (Favorite)

@property (nonatomic, strong) UIImage *coverImage; // 封面图

@property (nonatomic, assign) BOOL isSelected; // 是否选中

@property (nonatomic, assign) BOOL isFromFavorite; // 是否来自收藏页

@end

NS_ASSUME_NONNULL_END
