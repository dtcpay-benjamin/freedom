//
//  SHTSearchCollectionViewCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import <UIKit/UIKit.h>
#import <PangrowthDJX/DJXSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface SHTSearchCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) DJXPlayletInfoModel *model;

@end

NS_ASSUME_NONNULL_END
