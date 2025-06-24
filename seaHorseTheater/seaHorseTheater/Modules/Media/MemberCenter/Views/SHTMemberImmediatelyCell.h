//
//  SHTMemberImmediatelyCell.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTMemberImmediatelyCell : UITableViewCell

@property (nonatomic, strong) void (^memberImmediatelyOnTapped)(void); // 开通会员点击回调

@property (nonatomic, strong) void (^radioOnTapped)(BOOL isSelected); // 已阅读会员服务协议点击回调

@property (nonatomic, strong) void (^serviceAgreementOnTapped)(void); // 会员服务协议点击回调

@end

NS_ASSUME_NONNULL_END
