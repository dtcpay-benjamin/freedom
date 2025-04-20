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
#import "SHTFavoritePlayletModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SHTEmptyPlaceholderView.h"

@interface SHTFavoriteViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentPage; // 当前请求页
@property (nonatomic, assign) BOOL hasMore; // 是否还有更多
@property (nonatomic, strong) UICollectionView *collectionView; // 收藏列表
@property (nonatomic, strong) SHTEmptyPlaceholderView *emptyView; // 空数据站位
@property (nonatomic, strong) NSMutableArray *dataSource; // 短剧数据组
@property (nonatomic, strong) NSMutableArray *favoriteDataSource; // 选中短剧记录数据组
@property (nonatomic, assign) bool isEdit; // 是否在编辑
@property (nonatomic, assign) bool isAllSelect; // 编辑-全选

@end

@implementation SHTFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf requestCollection];
    }];
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestCollection];
    }];
}

// 获取收藏的短剧数据
- (void)requestCollection {
    NSInteger pageSize = 6;
    [[DJXPlayletManager shareInstance] requestCollectionList:self.currentPage pageSize:pageSize success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
        NSLog(@"获取收藏短剧列表:%@, 是否还有更多:%d", playletList, hasMore);
        NSArray *shortplayIdArray = [playletList valueForKey:@"shortplay_id"];
        NSLog(@"收藏短剧id列表:%@", shortplayIdArray);
        // 刷新 or 加载更多
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            [self.favoriteDataSource removeAllObjects];
            [self selectAllAssignment];
        }
        [self.dataSource addObjectsFromArray:playletList];
        for (int i = 0; i < playletList.count; i++) {
            SHTFavoritePlayletModel *favoritePlayletModel = [[SHTFavoritePlayletModel alloc] init];
            favoritePlayletModel.isSelected = self.isAllSelect;
            [self.favoriteDataSource addObject:favoritePlayletModel];
        }
        self.hasMore = hasMore;
        [self.collectionView reloadData];
        
        // 结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        // 如果没有更多了，显示“没有更多数据”
        if (playletList.count == 0 || !playletList) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer resetNoMoreData];
        }
        [self checkEmpty];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取收藏短剧列表报错error:%@", error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SHTScreenWidth, SHTScreenHeight - (SHT_STATUS_BAR_HEIGHT + 40) - SHT_tabBarHeight) collectionViewLayout:layout];
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
                                                          imageName:nil
                                                                                     message:@"暂无内容"
                                                                                 buttonTitle:@"去剧场"
                                                                                 actionBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 去剧场
            if (strongSelf.goToDramaMarketCallBack) {
                strongSelf.goToDramaMarketCallBack();
            }
        }];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)enterPlayer:(DJXPlayletInfoModel *)infoModel {
    DJXDrawVideoViewController *vc = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
        playletConfig.skitId = infoModel.shortplay_id;
        playletConfig.episode = infoModel.current_episode;
        playletConfig.playStartTime = (CGFloat)infoModel.action_time;
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 5;
        playletConfig.unlockEpisodesCountUsingAD = 1;
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet;
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)editFavorites:(BOOL)isEdit {
    self.isEdit = isEdit;
    if (!isEdit) {
        for (SHTFavoritePlayletModel *model in self.favoriteDataSource) {
            model.isSelected = NO;
        }
        [self.tabBarController.tabBar setHidden:NO];
    } else {
        [self.tabBarController.tabBar setHidden:YES];
    }
    [self.collectionView reloadData];
}

- (void)selectAllFavoriteData {
    for (SHTFavoritePlayletModel *model in self.favoriteDataSource) {
        model.isSelected = YES;
    }
    self.isAllSelect = YES;
    [self.collectionView reloadData];
}

- (void)cancelSelectAllFavoriteData {
    for (SHTFavoritePlayletModel *model in self.favoriteDataSource) {
        model.isSelected = NO;
    }
    self.isAllSelect = NO;
    [self.collectionView reloadData];
}

- (void)deleteFavoriteData {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.favoriteDataSource.count; i++) {
        SHTFavoritePlayletModel *model = self.favoriteDataSource[i];
        if (model.isSelected == YES) {
            DJXPlayletInfoModel *infoModel = self.dataSource[i];
            [tempArray addObject:infoModel];
            [tempArray1 addObject:model];
        }
    }
    [self.dataSource removeObjectsInArray:tempArray];
    [self.favoriteDataSource removeObjectsInArray:tempArray1];
    [self.collectionView reloadData];
    [self requestDeleteFavoritesInBatches:tempArray maxConcurrent:6 completion:^{
        // 重置是否全选的状态
        [self selectAllAssignment];
        [self checkEmpty];
        if (self.deleteActionCompletion) {
            self.deleteActionCompletion(tempArray);
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
    if (self.favoriteDataSource.count > 0) {
        for (int i = 0; i < self.favoriteDataSource.count; i++) {
            SHTFavoritePlayletModel *favoritePlayletModel = self.favoriteDataSource[i];
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

- (NSMutableArray *)favoriteDataSource {
    if (!_favoriteDataSource) {
        _favoriteDataSource = [[NSMutableArray alloc] init];
    }
    return _favoriteDataSource;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTFavoritePlayletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTFavoritePlayletCell" forIndexPath:indexPath];
    DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
    SHTFavoritePlayletModel *favoritePlayletModel = self.favoriteDataSource[indexPath.item];
    cell.playletinfoModel = model;
    cell.isEdit = self.isEdit;
    cell.favoriteModel = favoritePlayletModel;
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        SHTFavoritePlayletModel *favoritePlayletModel = self.favoriteDataSource[indexPath.item];
        favoritePlayletModel.isSelected = !favoritePlayletModel.isSelected;
        [self selectAllAssignment];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
        [self enterPlayer:model];
    }
}


#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalSpacing = 10 * 4;
    CGFloat width = (self.view.bounds.size.width - totalSpacing) / 3;
    return CGSizeMake(width, width * (16.0 / 9.0) + 45.0);
}

@end
