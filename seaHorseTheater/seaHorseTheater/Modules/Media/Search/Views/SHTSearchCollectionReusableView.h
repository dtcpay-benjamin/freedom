//
//  SHTSearchCollectionReusableView.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTSearchCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) void (^onTapped)(void); // 按钮点击回调
@property(nonatomic, copy) NSString *title; // 标题
@property(nonatomic, strong) UIImage *actionImage; // 响应事件图标
@property(nonatomic, copy) NSString *actionTitle; // 响应事件标题

@end

NS_ASSUME_NONNULL_END
