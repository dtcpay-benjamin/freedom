//
//  SHTSearchBarView.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTSearchBarView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void (^onBackTapped)(void); // 返回回调
@property (nonatomic, copy) void (^onSearchTapped)(NSString *searchKey); // 搜索回调

@end

NS_ASSUME_NONNULL_END
