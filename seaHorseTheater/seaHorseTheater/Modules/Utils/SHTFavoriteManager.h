//
//  SHTFavoriteManager.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 5/5/25.
//

#import <Foundation/Foundation.h>
#import <PangrowthDJX/DJXSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTFavoriteManager : NSObject

@property (nonatomic, strong) NSMutableArray *drawFavoriteArrays; //已收藏数据数组

// 单例
+ (instancetype)sharedInstance;

// 为播放页(滑滑流与详情)自定义收藏按钮
- (UIView *)setCollectView:(UITableViewCell *)cell;

// 为自定义收藏按钮设置frame
- (void)setCollectViewFrame:(UITableViewCell *)cell layoutSubviews:(UIView *)subview;

// 自定义收藏按钮数据更新
- (void)collectViewUpdateSubview:(UIView *)subview withData:(DJXPlayletInfoModel *)playletInfoModel andIsDraw:(BOOL)IsDraw;

// 是否要添加到收藏数组
- (BOOL)isAddToFavorites:(DJXPlayletInfoModel *)playletInfoModel;

// 从收藏数组删除已删除的收藏数据
- (void)deleteFavorites:(NSArray *)deleteArray;

@end

NS_ASSUME_NONNULL_END
