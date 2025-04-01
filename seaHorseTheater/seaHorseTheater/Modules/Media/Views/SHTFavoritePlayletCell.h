//
//  SHTFavoritePlayletCell.h
//  seaHorseTheater
//
//  Created by apple on 2025/3/18.
//

#import <UIKit/UIKit.h>
#import <PangrowthDJX/DJXSDK.h>

NS_ASSUME_NONNULL_BEGIN
@class SHTFavoritePlayletModel;

@interface SHTFavoritePlayletCell : UICollectionViewCell
@property(nonatomic, strong)DJXPlayletInfoModel *playletinfoModel;
@property (nonatomic, assign) bool isEdit;
@property (nonatomic, strong) SHTFavoritePlayletModel *favoriteModel;
@end

NS_ASSUME_NONNULL_END
