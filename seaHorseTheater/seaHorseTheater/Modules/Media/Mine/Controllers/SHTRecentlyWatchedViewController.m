//
//  SHTRecentlyWatchedViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/28.
//

#import "SHTRecentlyWatchedViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <PangrowthDJX/DJXSDK.h>
#import "DJXPlayletInfoModel+SHTFavorite.h"
#import "SHTRecentWatchCell.h"
#import "Masonry.h"
#import "SHTToolsManager.h"
#import "SHTFavoriteManager.h"

@interface SHTRecentlyWatchedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DJXPlayletDetailCellDelegate>

@property (nonatomic, assign) NSInteger currentPage; // 当前请求页

@property (nonatomic, assign) bool isFirstLoad; // 是否第一次加载

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<DJXPlayletInfoModel *> *dataSource;

@end

@implementation SHTRecentlyWatchedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR_DARK;
    self.title = NSLocalizedString(@"recently_watched", nil);
    [self setUpViews];
    [self setUpLayoutSubViews];
    [self setupRefresh];
    self.isFirstLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstLoad == YES) {
        self.currentPage = 1;
        [self loadData];
        self.isFirstLoad = NO;
    }
}

- (void)setUpViews {
    [self.view addSubview:self.collectionView];
}

- (void)setUpLayoutSubViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentPage = 1;
        [strongSelf loadData];
    }];
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentPage++;
        [strongSelf loadData];
    }];
}

- (void)loadData {
    NSInteger pageSize = 6;
    [[DJXPlayletManager shareInstance] requestPlayletHistoryListWithPage:self.currentPage num:pageSize success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList) {
        NSLog(@"获取最近观看短剧列表:%@", playletList);
        // 结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (playletList.count > 0) {
            // 刷新 or 加载更多
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
            }
            [SHTToolsManager downloadCoverImagesForPlayletList:playletList];
            [self.dataSource addObjectsFromArray:playletList];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer resetNoMoreData];
        } else {
            // 如果没有更多了，显示“已经全部加载完毕”
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取最近观看短剧列表报错error:%@", error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.view.bounds.size.width - 30) / 2, 200);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SHTRecentWatchCell class] forCellWithReuseIdentifier:@"SHTRecentWatchCell"];
    }
    return _collectionView;
}


#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTRecentWatchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTRecentWatchCell" forIndexPath:indexPath];
    DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
    [SHTToolsManager enterPlayer:model fromVC:self];
}

#pragma mark - DJXPlayletDetailCellDelegate

- (UIView *)djx_playletDetailCellCustomView:(UITableViewCell *)cell {
    return [[SHTFavoriteManager sharedInstance] setCollectView:cell];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView {
    [[SHTFavoriteManager sharedInstance] setCollectViewFrame:cell layoutSubviews:customView];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(DJXPlayletInfoModel *)playletInfo {
//    if (!playletInfo.isFromFavorite) {
//        playletInfo.isFromFavorite = YES;
//    }
    [[SHTFavoriteManager sharedInstance] collectViewUpdateSubview:customView withData:playletInfo andIsDraw:NO];
}

@end
