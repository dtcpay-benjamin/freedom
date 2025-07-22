//
//  SHTSearchCollectionViewCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import <UIKit/UIKit.h>
#import <PangrowthDJX/DJXSDK.h>
#import "SHTCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHTSearchCollectionViewCell : SHTCollectionViewCell

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) DJXPlayletInfoModel *model;

@end

NS_ASSUME_NONNULL_END
