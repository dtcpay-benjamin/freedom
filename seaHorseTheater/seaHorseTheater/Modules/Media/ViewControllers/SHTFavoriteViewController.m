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

@interface SHTFavoriteViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

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
        weakSelf.currentPage = 0;
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
    NSInteger pageSize = 10;
        [[DJXPlayletManager shareInstance] requestCollectionList:self.currentPage pageSize:pageSize success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
            NSLog(@"获取收藏短剧列表:%@, 是否还有更多:%d", playletList, hasMore);
            // 刷新 or 加载更多
            if (self.currentPage == 0) {
                self.dataSource = playletList;
            } else {
                self.dataSource = [self.dataSource arrayByAddingObjectsFromArray:playletList];
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
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"获取收藏短剧列表报错error:%@", error);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[SHTFavoritePlayletCell class] forCellWithReuseIdentifier:@"SHTFavoritePlayletCell"];
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.view addSubview:self.collectionView];
    [self setupRefresh];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTFavoritePlayletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTFavoritePlayletCell" forIndexPath:indexPath];
    DJXPlayletInfoModel *model = self.dataSource[indexPath.item];
    cell.playletinfoModel = model;
    return cell;
}

#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalSpacing = 10 * 4;
    CGFloat width = (self.view.bounds.size.width - totalSpacing) / 3;
    return CGSizeMake(width, width * (16.0 / 9.0) + 45.0);
}

@end
