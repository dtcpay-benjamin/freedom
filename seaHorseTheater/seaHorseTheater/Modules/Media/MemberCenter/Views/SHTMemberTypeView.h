//
//  SHTMemberTypeView.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SHTMemberModel;

@interface SHTMemberTypeView : UIView

@property(nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) void (^onTapped)(void); // 点击回调

@property(nonatomic, strong) SHTMemberModel *model; // 数据模型

- (void)setupUnselectedColor;

- (void)setupSelectedColor;

@end

NS_ASSUME_NONNULL_END
