//
//  SHTSearchTableViewCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/29.
//

#import <UIKit/UIKit.h>
#import <PangrowthDJX/DJXSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTSearchTableViewCell : UITableViewCell

@property(nonatomic, strong) DJXPlayletInfoModel *playletinfoModel; // 短剧信息

@end

NS_ASSUME_NONNULL_END
