//
//  SHTFavoritePlayletCell.h
//  seaHorseTheater
//
//  Created by apple on 2025/3/18.
//

#import <UIKit/UIKit.h>
#import <PangrowthDJX/DJXSDK.h>
#import "SHTCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class SHTFavoritePlayletModel;

@interface SHTFavoritePlayletCell : SHTCollectionViewCell
@property (nonatomic, copy) void (^longPressHandler)(void); // 长按回调
@property(nonatomic, strong) DJXPlayletInfoModel *playletinfoModel; // 短剧信息
@property (nonatomic, assign) bool isEdit;
@property (nonatomic, strong) SHTFavoritePlayletModel *favoriteModel;
@end

NS_ASSUME_NONNULL_END
