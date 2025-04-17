//
//  SHTFavoriteViewController.h
//  seaHorseTheater
//
//  Created by 褚红彪 on 3/16/25.
//

#import <UIKit/UIKit.h>
#import "SHTHomeViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SHTFavoriteViewController : UIViewController
@property(nonatomic, copy) void (^deleteActionCompletion)(void); // 删除完成回调
@property (nonatomic, copy) void (^selectActionCallBack)(bool isAllSelect, bool isSomeSelect); // cell点击操作回调，是否全选
@property (nonatomic, copy) void (^contentDetectionCallBack)(bool isEmpty); // 收藏剧场是否为空回调
@property (nonatomic, copy) void (^goToDramaMarketCallBack)(void); // 去剧场回调
// 编辑收藏
- (void)editFavorites:(BOOL)isEdit;
// 全选收藏数据
- (void)selectAllFavoriteData;
// 取消全选收藏数据
- (void)cancelSelectAllFavoriteData;
// 删除收藏数据
- (void)deleteFavoriteData;

@end

NS_ASSUME_NONNULL_END
