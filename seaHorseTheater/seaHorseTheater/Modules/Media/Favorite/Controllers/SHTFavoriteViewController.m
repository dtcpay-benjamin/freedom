//
//  SHTFavoriteViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 3/16/25.
//

#import "SHTFavoriteViewController.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTFavoritePlayletCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SHTEmptyPlaceholderView.h"
#import "SHTToolsManager.h"
#import "SHTFavoriteManager.h"
#import "DJXPlayletInfoModel+SHTFavorite.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SHTFavoriteViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DJXPlayletDetailCellDelegate>

@property (nonatomic, assign) NSInteger currentPage; // 当前请求页
@property (nonatomic, assign) BOOL hasMore; // 是否还有更多
@property (nonatomic, strong) UICollectionView *collectionView; // 收藏列表
@property (nonatomic, strong) SHTEmptyPlaceholderView *emptyView; // 暂无内容
@property (nonatomic, strong) NSMutableArray *dataSource; // 短剧数据组
@property (nonatomic, assign) bool isEdit; // 是否在编辑
@property (nonatomic, assign) bool isAllSelect; // 编辑-全选
@property (nonatomic, assign) bool isFirstLoad; // 是否第一次加载

@end

@implementation SHTFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"CollectionDataRefresh"
                                               object:nil];
    [self configCollectionView];
    self.isFirstLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstLoad == YES) {
        self.currentPage = 1;
        [self requestCollection:nil];
        self.isFirstLoad = NO;
    }
    [self checkEmpty];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CollectionDataRefresh" object:nil];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentPage = 1;
        [strongSelf requestCollection:nil];
    }];
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentPage++;
        [strongSelf requestCollection:nil];
    }];
}

// 重新加载数据
- (void)reloadData:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    self.currentPage = 1;
    [self requestCollection:userInfo];
}

// 获取收藏的短剧数据
- (void)requestCollection:(NSDictionary *)userInfo {
    BOOL isCheckEmpty = YES;
    BOOL isFavorite = NO;
    __block DJXPlayletInfoModel *playletInfo = nil;
    if (userInfo) {
        isCheckEmpty = [userInfo[@"isCheckEmpty"] boolValue];
        isFavorite = [userInfo[@"isFavorite"] boolValue];
        playletInfo = userInfo[@"playletInfo"];
    }
    if (playletInfo) {
        if (isFavorite) {
            if (self.selectActionCallBack) {
                self.selectActionCallBack(NO, NO);
            }
            [self downloadCoverImageForPlayletInfo:playletInfo];
            playletInfo.isSelected = self.isAllSelect;
            [self.dataSource insertObject:playletInfo atIndex:0];
            if ([[SHTFavoriteManager sharedInstance] isAddToFavorites:playletInfo]) {
                [[SHTFavoriteManager sharedInstance].drawFavoriteArrays addObject:playletInfo];
            }
        } else {
            DJXPlayletInfoModel *tempModel = nil;
            for (int i = 0; i < self.dataSource.count; i++) {
                DJXPlayletInfoModel *model = self.dataSource[i];
                if (playletInfo.shortplay_id == model.shortplay_id) {
                    tempModel = model;
                    break;;
                }
            }
            [self.dataSource removeObject:tempModel];
        }
        [self.collectionView reloadData];
    } else {
        NSInteger pageSize = 6;
        [[DJXPlayletManager shareInstance] requestCollectionList:self.currentPage pageSize:pageSize success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
            NSLog(@"获取收藏短剧列表:%@, 是否还有更多:%d", playletList, hasMore);
            // 刷新 or 加载更多
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
                [self selectAllAssignment];
            }
            [self downloadCoverImagesForPlayletList:playletList];
            [self.dataSource addObjectsFromArray:playletList];
            for (DJXPlayletInfoModel *model in playletList) {
                model.isFromFavorite = YES;
                model.isSelected = self.isAllSelect;
                if ([[SHTFavoriteManager sharedInstance] isAddToFavorites:model]) {
                    [[SHTFavoriteManager sharedInstance].drawFavoriteArrays addObject:model];
                }
            }
            self.hasMore = hasMore;
            [self.collectionView reloadData];
            // 结束刷新状态
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
            if (hasMore) {
                [self.collectionView.mj_footer resetNoMoreData];
            } else {
                // 如果没有更多了，显示“已经全部加载完毕”
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if (isCheckEmpty) {
                [self checkEmpty];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"获取收藏短剧列表报错error:%@", error);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }];
    }
}

- (void)downloadCoverImageForPlayletInfo:(DJXPlayletInfoModel *)playletInfo {
    NSURL *url = [NSURL URLWithString:playletInfo.cover_image];
    [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image,
                                                          NSData * _Nullable data,
                                                          NSError * _Nullable error,
                                                          SDImageCacheType cacheType,
                                                          BOOL finished,
                                                          NSURL * _Nullable imageURL) {
        if (image) {
            playletInfo.coverImage = image; // 存到分类属性
            NSLog(@"封面下载成功: %@", imageURL);
        } else {
            NSLog(@"封面下载失败: %@, error: %@", imageURL, error);
        }
    }];
}

- (void)downloadCoverImagesForPlayletList:(NSArray<DJXPlayletInfoModel *> *)playletList {
    for (DJXPlayletInfoModel *model in playletList) {
        if (model.cover_image.length == 0) {
            NSLog(@"model.cover_image 为空，跳过");
            continue;
        }
        
        NSURL *url = [NSURL URLWithString:model.cover_image];
        [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image,
                                                              NSData * _Nullable data,
                                                              NSError * _Nullable error,
                                                              SDImageCacheType cacheType,
                                                              BOOL finished,
                                                              NSURL * _Nullable imageURL) {
            if (image) {
                model.coverImage = image; // 存到分类属性
                NSLog(@"封面下载成功: %@", imageURL);
            } else {
                NSLog(@"封面下载失败: %@, error: %@", imageURL, error);
            }
        }];
    }
}

- (void)checkEmpty {
    bool isEmpty = NO;
    if (self.dataSource.count == 0) {
        self.collectionView.hidden = YES;
        self.emptyView.hidden = NO;
        isEmpty = YES;
    } else {
        self.collectionView.hidden = NO;
        self.emptyView.hidden = YES;
    }
    if (self.contentDetectionCallBack) {
        self.contentDetectionCallBack(isEmpty);
    }
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2.5, SHTScreenWidth, SHTScreenHeight - (SHT_STATUS_BAR_HEIGHT + 40) - SHT_tabBarHeight - 2.5) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[SHTFavoritePlayletCell class] forCellWithReuseIdentifier:@"SHTFavoritePlayletCell"];
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.view addSubview:self.collectionView];
    [self setupRefresh];
}

- (SHTEmptyPlaceholderView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SHTEmptyPlaceholderView alloc] init];
        __weak typeof(self) weakSelf = self;
        _emptyView = [[SHTEmptyPlaceholderView alloc] initWithFrame:self.view.bounds
                                                          imageName:@"noData"
                                                                                     message:@"暂无内容"
                                                                                 buttonTitle:@"去看剧"
                                                                                 actionBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 去看剧
            if (strongSelf.goToDramaMarketCallBack) {
                strongSelf.goToDramaMarketCallBack();
            }
        }];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)editFavorites:(BOOL)isEdit {
    self.isEdit = isEdit;
    if (!isEdit) {
        for (DJXPlayletInfoModel *model in self.dataSource) {
            model.isSelected = NO;
        }
        [self.tabBarController.tabBar setHidden:NO];
    } else {
        [self.tabBarController.tabBar setHidden:YES];
    }
    [self.collectionView reloadData];
}

- (void)selectAllFavoriteData {
    for (DJXPlayletInfoModel *model in self.dataSource) {
        model.isSelected = YES;
    }
    self.isAllSelect = YES;
    [self.collectionView reloadData];
}

- (void)cancelSelectAllFavoriteData {
    for (DJXPlayletInfoModel *model in self.dataSource) {
        model.isSelected = NO;
    }
    self.isAllSelect = NO;
    [self.collectionView reloadData];
}

- (void)deleteFavoriteData {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataSource.count; i++) {
        DJXPlayletInfoModel *infoModel = self.dataSource[i];
        if (infoModel.isSelected == YES) {
            [tempArray addObject:infoModel];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self requestDeleteFavoritesInBatches:tempArray maxConcurrent:6 completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.hasMore) {
            [strongSelf reloadData:nil];
        } else {
            [strongSelf.dataSource removeObjectsInArray:tempArray];
            [strongSelf.collectionView reloadData];
            // 重置是否全选的状态
            [strongSelf selectAllAssignment];
            [strongSelf checkEmpty];
        }
        if (strongSelf.deleteActionCompletion) {
            strongSelf.deleteActionCompletion(tempArray);
        }
    }];

}

#pragma mark - 删除收藏短剧请求
- (void)requestDeleteFavoritesInBatches:(NSArray<DJXPlayletInfoModel *> *)favoriteDatas
                        maxConcurrent:(NSInteger)maxConcurrent
                           completion:(void (^)(void))completion {
    
    if (favoriteDatas.count == 0) {
        if (completion) completion();
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });

    // 分片处理，每次取 maxConcurrent 条
    NSUInteger total = favoriteDatas.count;
    __block NSUInteger currentIndex = 0;

    void (^processNextBatch)(void);
    __block void (^__weak weakProcessNextBatch)(void);
    weakProcessNextBatch = processNextBatch = ^{
        __block void (^__strong strongProcessNextBatch)(void) = weakProcessNextBatch;
        if (currentIndex >= total) {
            // 所有批次处理完毕
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (completion) completion();
            });
            return;
        }

        NSUInteger batchEnd = MIN(currentIndex + maxConcurrent, total);
        NSArray *batch = [favoriteDatas subarrayWithRange:NSMakeRange(currentIndex, batchEnd - currentIndex)];
        currentIndex = batchEnd;

        // 并发删除当前 batch
        dispatch_group_t group = dispatch_group_create();
        for (DJXPlayletInfoModel *infoModel in batch) {
            dispatch_group_enter(group);
            [[DJXPlayletManager shareInstance] cancelCollectShortplay:infoModel.shortplay_id success:^{
                NSLog(@"✅ 删除成功：%ld", (long)infoModel.shortplay_id);
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                NSLog(@"❌ 删除失败：%ld 错误：%@", (long)infoModel.shortplay_id, error);
                dispatch_group_leave(group);
            }];
        }

        // 等当前 batch 完成后处理下一个 batch
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"🚩 当前批次完成，处理下一批...");
            strongProcessNextBatch(); // 调用下一批
        });
    };

    processNextBatch(); // 启动第一个批次
}

// 是否是全选的检测与赋值
- (void)selectAllAssignment {
    bool isAllSelect = YES;
    bool isSomeSelect = NO;
    if (self.dataSource.count > 0) {
        for (int i = 0; i < self.dataSource.count; i++) {
            DJXPlayletInfoModel *favoritePlayletModel = self.dataSource[i];
            if (!favoritePlayletModel.isSelected) {
                isAllSelect = NO;
            }
            if (favoritePlayletModel.isSelected) {
                isSomeSelect = YES;
            }
        }
    } else {
        isAllSelect = NO;
    }
    self.isAllSelect = isAllSelect;
    if (self.selectActionCallBack) {
        self.selectActionCallBack(isAllSelect, isSomeSelect);
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTFavoritePlayletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTFavoritePlayletCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.longPressHandler = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.cellLongPressHandler) {
            strongSelf.cellLongPressHandler();
        }
    };
    DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
    cell.playletinfoModel = model;
    cell.isEdit = self.isEdit;
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        DJXPlayletInfoModel *favoritePlayletModel = self.dataSource[indexPath.item];
        favoritePlayletModel.isSelected = !favoritePlayletModel.isSelected;
        [self selectAllAssignment];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
        [SHTToolsManager enterPlayer:model fromVC:self];
    }
}


#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalSpacing = 10 * 4;
    CGFloat width = (self.view.bounds.size.width - totalSpacing) / 3;
    return CGSizeMake(width, width * (16.0 / 9.0) + 45.0);
}

#pragma mark - DJXPlayletDetailCellDelegate

- (UIView *)djx_playletDetailCellCustomView:(UITableViewCell *)cell {
    return [[SHTFavoriteManager sharedInstance] setCollectView:cell];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView {
    [[SHTFavoriteManager sharedInstance] setCollectViewFrame:cell layoutSubviews:customView];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(DJXPlayletInfoModel *)playletInfo {
    if (!playletInfo.isFromFavorite) {
        playletInfo.isFromFavorite = YES;
    }
    [[SHTFavoriteManager sharedInstance] collectViewUpdateSubview:customView withData:playletInfo andIsDraw:NO];
}

@end
