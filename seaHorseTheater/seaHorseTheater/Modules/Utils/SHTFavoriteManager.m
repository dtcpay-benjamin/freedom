//
//  SHTFavoriteManager.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 5/5/25.
//

#import "SHTFavoriteManager.h"
#import "SHTDrawVideoCollectView.h"
#import "SHTMBProgressManager.h"
#import "DJXPlayletInfoModel+SHTFavorite.h"

@interface SHTFavoriteManager()

@property (nonatomic, strong) NSMutableArray *drawVideosArrays; //滑滑流已展示数据数组
@property (nonatomic, strong) SHTDrawVideoCollectView *currentCollectView; // 滑滑流当前播放短剧的收藏按钮
@property (nonatomic, strong) SHTDrawVideoCollectView *videoDetailscurrentCollectView; // 视频详情当前播放短剧的收藏按钮

@end

@implementation SHTFavoriteManager

+ (instancetype)sharedInstance {
    static SHTFavoriteManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *)drawVideosArrays {
    if (!_drawVideosArrays) {
        _drawVideosArrays = [[NSMutableArray alloc] init];
    }
    return _drawVideosArrays;
}

- (NSMutableArray *)drawFavoriteArrays {
    if (!_drawFavoriteArrays) {
        _drawFavoriteArrays = [[NSMutableArray alloc] init];
    }
    return _drawFavoriteArrays;
}

// 滑滑流数据是否添加到数组过，如果有则添加
- (void)drawVideosAddDrawPlayletInfo:(DJXPlayletInfoModel *)playletInfoModel {
    if ([self isAddToDrawVideos:playletInfoModel]) {
        [self.drawVideosArrays addObject:playletInfoModel];
    }
}

// 是否要添加到数组
- (BOOL)isAddToDrawVideos:(DJXPlayletInfoModel *)playletInfoModel {
    BOOL isAdd = YES;
    for (DJXPlayletInfoModel *model in self.drawVideosArrays) {
        if (model.shortplay_id == playletInfoModel.shortplay_id) {
            isAdd = NO;
        }
    }
    return isAdd;
}

// 添加收藏短剧到数组
- (void)addDrawPlayletInfoToFavorites:(DJXPlayletInfoModel *)playletInfoModel {
    if ([self isAddToFavorites:playletInfoModel]) {
        [self.drawFavoriteArrays addObject:playletInfoModel];
    }
}

// 从收藏数组删除收藏短剧
- (void)deleteDrawPlayletInfoFromFavorites:(DJXPlayletInfoModel *)playletInfoModel {
    DJXPlayletInfoModel *tempModel;
    for (DJXPlayletInfoModel *model in self.drawFavoriteArrays) {
        if (model.shortplay_id == playletInfoModel.shortplay_id) {
            tempModel = model;
        }
    }
    if (tempModel) {
        [self.drawFavoriteArrays removeObject:tempModel];
    }
    NSLog(@"收藏短剧数组内容:%@", self.drawFavoriteArrays);
}


// 是否要添加到收藏数组
- (BOOL)isAddToFavorites:(DJXPlayletInfoModel *)playletInfoModel {
    BOOL isAdd = YES;
    for (DJXPlayletInfoModel *model in self.drawFavoriteArrays) {
        if (model.shortplay_id == playletInfoModel.shortplay_id) {
            isAdd = NO;
        }
    }
    return isAdd;
}

// 从收藏数组删除已删除的收藏数据
- (void)deleteFavorites:(NSArray *)deleteArray {
    BOOL isCurrent = NO;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (DJXPlayletInfoModel *model in deleteArray) {
        if (self.currentCollectView.playletInfoModel.shortplay_id == model.shortplay_id) {
            isCurrent = YES;
        }
        for (DJXPlayletInfoModel *favorite in self.drawFavoriteArrays) {
            if (favorite.shortplay_id == model.shortplay_id) {
                [tempArray addObject:favorite];
            }
        }
    }
    if (isCurrent == YES) {
        [self.currentCollectView setStatus:0];
    }
    [self.drawFavoriteArrays removeObjectsInArray:tempArray];
}

// 为播放页(滑滑流与详情)自定义收藏按钮
- (UIView *)setCollectView:(UITableViewCell *)cell {
    // 自定义收藏按钮
    SHTDrawVideoCollectView *collectView = [[SHTDrawVideoCollectView alloc] init];
    collectView.backgroundColor = [UIColor clearColor];
    NSLog(@"cell重用标识符:%@", cell.reuseIdentifier);
    return collectView;
}

// 为自定义收藏按钮设置frame
- (void)setCollectViewFrame:(UITableViewCell *)cell layoutSubviews:(UIView *)subview {
    subview.frame = CGRectMake(0.0, 80.0, 40.0, 56.0);
    Class viewClass = NSClassFromString(@"DJXDrawSideInteractArea");
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:viewClass]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 136.0);
            [view addSubview:subview];
            break;
        }
    }
}

// 自定义收藏按钮数据更新
- (void)collectViewUpdateSubview:(UIView *)subview withData:(DJXPlayletInfoModel *)playletInfoModel andIsDraw:(BOOL)IsDraw {
    __block SHTDrawVideoCollectView *collectView = (SHTDrawVideoCollectView *)subview;
    collectView.playletInfoModel = playletInfoModel;
    NSInteger favoriteState = playletInfoModel.favorite_state;
    if (IsDraw) {
        if (![self isAddToFavorites:playletInfoModel]) {
            favoriteState = 1;
        }
    } else {
        if ([self isAddToFavorites:playletInfoModel]) {
            favoriteState = 0;
        } else {
            favoriteState = 1;
        }
    }
    [collectView setStatus:favoriteState];
    [self drawVideosAddDrawPlayletInfo:playletInfoModel];
    if (IsDraw) {
        self.currentCollectView = collectView;
    } else {
        self.videoDetailscurrentCollectView = collectView;
    }
    NSLog(@"当前短剧:(%@)-id:%ld-收藏状态:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id, (long)playletInfoModel.favorite_state);
    __weak typeof(self) weakSelf = self;
    __weak typeof(collectView) weakCollectView = collectView;
    collectView.collectActionCallBack = ^(BOOL isCollect) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakCollectView) strongCollectView = weakCollectView;
        if (isCollect) {
            // 收藏短剧
            [[DJXPlayletManager shareInstance] collectShortplay:playletInfoModel.shortplay_id success:^{
                NSLog(@"短剧:(%@)收藏成功-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
                [strongSelf addDrawPlayletInfoToFavorites:playletInfoModel];
                [strongCollectView setStatus:1];
                if (!IsDraw) {
                    [self.currentCollectView setStatus:1];
                }
                [SHTMBProgressManager showText:nil withText:@"已追剧，可在【追剧】查看" andSubText:nil isBottom:NO];
                [self postFavoriteNotification:YES playletInfo:playletInfoModel];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"短剧:(%@)收藏失败-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
            }];
        } else {
            // 取消收藏短剧
            [[DJXPlayletManager shareInstance] cancelCollectShortplay:playletInfoModel.shortplay_id success:^{
                NSLog(@"短剧:(%@)取消收藏成功-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
                [strongSelf deleteDrawPlayletInfoFromFavorites:playletInfoModel];
                [strongCollectView setStatus:0];
                if (!IsDraw && (self.currentCollectView.playletInfoModel.shortplay_id == playletInfoModel.shortplay_id)) {
                    [self.currentCollectView setStatus:0];
                }
                [self postFavoriteNotification:NO playletInfo:playletInfoModel];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"短剧:(%@)取消收藏失败-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
            }];
        }
    };
}

- (void)postFavoriteNotification:(BOOL)isFavorite  playletInfo:(DJXPlayletInfoModel *)playletInfoModel {
    NSMutableDictionary *userInfo = [@{@"isCheckEmpty": @(NO), @"isFavorite": @(isFavorite)} mutableCopy];
    if (playletInfoModel.isFromFavorite) {
        [userInfo setObject:playletInfoModel forKey:@"playletInfo"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectionDataRefresh" object:nil userInfo:userInfo];
}

@end
