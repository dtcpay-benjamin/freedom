//
//  SHTSearchViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTSearchViewController.h"
#import "SHTToolsManager.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTSearchBarView.h"
#import "SHTSearchCollectionViewCell.h"
#import "SHTSearchCollectionReusableView.h"
#import "SHTUserDefaults.h"
#import "SHTLeftAlignedFlowLayout.h"
#import "SHTSearchTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "SHTAlertHelper.h"
#import "SHTEmptyPlaceholderView.h"
#import "SHTMBProgressManager.h"
#import "SHTFavoriteManager.h"

@interface SHTSearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, DJXPlayletDetailCellDelegate>

@property (nonatomic, strong) SHTSearchBarView *searchBar; // 搜索框
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SHTEmptyPlaceholderView *emptyView; // 暂无内容
@property (nonatomic, assign) NSInteger currentPage; // 当前搜索请求页
@property (nonatomic, copy) NSString *searchKeys;
@property (nonatomic, assign) BOOL isSearching; // 在搜索中
@property (nonatomic, strong) NSMutableArray *searcheDatas; // 搜索数据
@property (nonatomic, strong) NSMutableArray *historySearcheKeys; // 搜索关键字历史记录
@property (nonatomic, strong) NSArray *popularSearches; // 大家都在搜
@property (nonatomic, assign) NSInteger popularIndex;
@end

@implementation SHTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR;
    [self setupData];
}

#pragma mark - Data

- (void)setupData {
    [self.historySearcheKeys addObjectsFromArray:[SHTUserDefaults objectForKey:HISTORY_SEARCHES_KEY]];
    self.popularIndex = 1;
    [self requestRecommendedData];
}

#pragma mark - Actions

// 根据搜索关键词获取短剧数据
- (void)requestSearchData {
    [[DJXPlayletManager shareInstance] requestCategoryPlayletLisWithSearchWord:self.searchKeys isFuzzy:YES page:self.currentPage num:10 success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
        NSLog(@"搜索关键词:%@, 获取搜索短剧列表:%@, 是否还有更多:%d", self.searchKeys, playletList, hasMore);
        if (playletList.count > 0) {
            // 刷新 or 加载更多
            if (self.currentPage == 1) {
                [self.searcheDatas removeAllObjects];
            }
            [self.searcheDatas addObjectsFromArray:playletList];
            [self.tableView reloadData];
            // 结束刷新状态
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (hasMore) {
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                // 如果没有更多了，显示“已经全部加载完毕”
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.collectionView.hidden = YES;
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.collectionView.hidden = YES;
            self.emptyView.hidden = NO;
            self.tableView.hidden = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取搜索短剧列表报错error:%@", error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.collectionView.hidden = NO;
        self.emptyView.hidden = YES;
        self.tableView.hidden = YES;
    }];
}

// 获取推荐(大家都在搜)短剧数据
- (void)requestRecommendedData {
    if (self.popularIndex == 1) {
        [SHTMBProgressManager showHUD:self.view];
    }
    [[DJXPlayletManager shareInstance] requestRecommendedPlayletListPage:self.popularIndex num:5 success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, NSDictionary<NSString *,NSObject *> * _Nonnull info) {
        NSLog(@"获取推荐(大家都在搜)短剧数据:%@, 信息:%@", playletList, info);
        self.popularSearches = playletList;
        if (self.popularSearches.count > 0) {
            if (self.popularIndex == 1) {
                [SHTMBProgressManager hideHUD:self.view];
                [self.searchBar.textField becomeFirstResponder];
                [self.collectionView reloadData];
                [self setupGestureRecognizer];

            } else {
                if (self.historySearcheKeys.count > 0) {
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                } else {
                    [self.collectionView reloadData];
                }
            }
            self.tableView.hidden = YES;
            self.emptyView.hidden = YES;
            self.collectionView.hidden = NO;
        } else {
            [SHTMBProgressManager hideHUD:self.view];
            if (self.popularSearches.count == 0 && self.historySearcheKeys.count == 0) {
                self.tableView.hidden = YES;
                self.emptyView.hidden = NO;
                self.collectionView.hidden = YES;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取推荐(大家都在搜)短剧数据报错error:%@", error);
        if (self.popularIndex == 1) {
            [SHTMBProgressManager hideHUD:self.view];
        }
        if (self.popularSearches.count == 0 && self.historySearcheKeys.count == 0) {
            self.tableView.hidden = YES;
            self.emptyView.hidden = NO;
            self.collectionView.hidden = YES;
        }
    }];
}

// 设置收起键盘手势
- (void)setupGestureRecognizer {
    // 添加点击手势隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO; // 允许点击事件继续传递给子视图（如按钮等）
    [self.view addGestureRecognizer:tapGesture];
    // 滑动手势隐藏键盘
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - 懒加载

- (NSMutableArray *)searcheDatas {
    if (!_searcheDatas) {
        _searcheDatas = [[NSMutableArray alloc] init];
    }
    return _searcheDatas;
}

- (NSMutableArray *)historySearcheKeys {
    if (!_historySearcheKeys) {
        _historySearcheKeys = [[NSMutableArray alloc] init];
    }
    return _historySearcheKeys;
}

- (SHTSearchBarView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[SHTSearchBarView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 60)];
        __weak typeof(self) weakSelf = self;
        _searchBar.onBackTapped = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.isSearching) {
                strongSelf.searchBar.textField.text = nil;
                strongSelf.tableView.hidden = YES;
                strongSelf.emptyView.hidden = YES;
                strongSelf.collectionView.hidden = NO;
                strongSelf.isSearching = NO;
                [strongSelf.searchBar.textField becomeFirstResponder];
            } else {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }
        };
        _searchBar.onSearchTapped = ^(NSString *keyword) {
            NSLog(@"搜索关键词：%@", keyword); // 进行搜索操作
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.searchKeys = keyword;
            strongSelf.currentPage = 1;
            [strongSelf requestSearchData];
            if ([strongSelf.historySearcheKeys containsObject:keyword]) {
                [strongSelf.historySearcheKeys removeObject:keyword];

            }
            [strongSelf.historySearcheKeys insertObject:keyword atIndex:0];
            [SHTUserDefaults setObject:strongSelf.historySearcheKeys forKey:HISTORY_SEARCHES_KEY];
            if (strongSelf.collectionView.numberOfSections > 1) {
                [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } else {
                [strongSelf.collectionView reloadData];
            }
            strongSelf.isSearching = YES;
        };
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SHTLeftAlignedFlowLayout *layout = [[SHTLeftAlignedFlowLayout alloc] init];
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        layout.sectionInset = UIEdgeInsetsMake(20.0, 24.0, 20.0, 12.0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame) + 20.0, self.view.frame.size.width, self.view.frame.size.height - 100.0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SHTSearchCollectionReusableView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"SHTSearchCollectionReusableView"];
        [_collectionView registerClass:[SHTSearchCollectionViewCell class] forCellWithReuseIdentifier:@"SHTSearchCollectionViewCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame) + 20.0, self.view.frame.size.width, self.view.frame.size.height - 100.0) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 130.0;
        _tableView.backgroundColor = SHT_BACK_COLOR;
        [_tableView registerClass:[SHTSearchTableViewCell class] forCellReuseIdentifier:@"SHTSearchTableViewCell"];
        __weak typeof(self) weakSelf = self;
        // 下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.currentPage = 1;
            [strongSelf requestSearchData];
        }];
        // 上拉加载更多
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.currentPage++;
            [strongSelf requestSearchData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SHTEmptyPlaceholderView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SHTEmptyPlaceholderView alloc] init];
        __weak typeof(self) weakSelf = self;
        _emptyView = [[SHTEmptyPlaceholderView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame) + 20.0, self.view.frame.size.width, self.view.frame.size.height)
                                                          imageName:@"noRelevantData"
                                                                                     message:@"暂无相关内容"
                                                        buttonTitle:nil
                                                                                 actionBlock:nil];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

#pragma mark - actions

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.historySearcheKeys.count > 0) {
        if (self.popularSearches.count > 0) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (self.historySearcheKeys.count > 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SHTSearchCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:@"SHTSearchCollectionReusableView"
                                                                                                forIndexPath:indexPath];
            if (indexPath.section == 0) {
                header.title = NSLocalizedString(@"search_history", nil);
                header.actionImage = [UIImage imageNamed:@"ico-del-grey"];
                header.actionTitle = @"";
            } else {
                header.title = NSLocalizedString(@"trending_searches", nil);
                header.actionImage = [UIImage imageNamed:@"ico-swap-grey"];
                header.actionTitle = NSLocalizedString(@"swap", nil);
            }
            __weak typeof(self) weakSelf = self;
            header.onTapped = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (indexPath.section == 0) {
                    [SHTAlertHelper showAlertWithTitle:NSLocalizedString(@"search_delete_title", nil)
                                               message:NSLocalizedString(@"search_delete_message", nil)
                                         cancelBtnText:NSLocalizedString(@"maybe_later", nil)
                                        confirmBtnText:NSLocalizedString(@"confirm", nil)
                                          inController:nil
                                          cancelAction:nil confirmAction:^{
                        NSLog(@"历史搜索-删除");
                        [strongSelf clearAllHistory];
                    }];
                } else {
                    NSLog(@"大家都在搜-换一换");
                    [strongSelf changePopular];
                }
            };
            return header;
        }
    } else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SHTSearchCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:@"SHTSearchCollectionReusableView"
                                                                                                forIndexPath:indexPath];
            header.title = NSLocalizedString(@"trending_searches", nil);
            header.actionImage = [UIImage imageNamed:@"ico-swap-grey"];
            header.actionTitle = NSLocalizedString(@"swap", nil);
            __weak typeof(self) weakSelf = self;
            header.onTapped = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSLog(@"大家都在搜-换一换");
                [strongSelf changePopular];
            };
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 32);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.historySearcheKeys.count > 0) {
        // 限定16条记录展示
        if (section == 0) return MIN(self.historySearcheKeys.count, 16);
        return MIN(self.popularSearches.count, 16);
    } else {
        return MIN(self.popularSearches.count, 16);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historySearcheKeys.count > 0) {
        SHTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTSearchCollectionViewCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.text = self.historySearcheKeys[indexPath.item];
        } else {
            cell.model = self.popularSearches[indexPath.item];
        }
        return cell;
    } else {
        SHTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTSearchCollectionViewCell" forIndexPath:indexPath];
        cell.model = self.popularSearches[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historySearcheKeys.count > 0) {
        if (indexPath.section == 0) {
            NSString *keys = self.historySearcheKeys[indexPath.item];
            self.searchBar.textField.text = keys;
            self.searchKeys = keys;
            self.currentPage = 1;
            [self requestSearchData];
            [self.historySearcheKeys removeObject:keys];
            [self.historySearcheKeys insertObject:keys atIndex:0];
            [SHTUserDefaults setObject:self.historySearcheKeys forKey:HISTORY_SEARCHES_KEY];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            self.isSearching = YES;
        } else {
            [SHTToolsManager enterPlayer:self.popularSearches[indexPath.item] fromVC:self];
        }
    } else {
        [SHTToolsManager enterPlayer:self.popularSearches[indexPath.item] fromVC:self];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
    if (self.historySearcheKeys.count > 0) {
        if (indexPath.section == 0) {
            text = self.historySearcheKeys[indexPath.item];
        } else {
            DJXPlayletInfoModel *model = self.popularSearches[indexPath.item];
            text = model.title;
        }
    } else {
        DJXPlayletInfoModel *model = self.popularSearches[indexPath.item];
        text = model.title;
    }
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: SHTUIFontSystem(14)}];
    return CGSizeMake(size.width + 20, 30);
}

#pragma mark - 删除历史记录

- (void)clearAllHistory {
    [self.historySearcheKeys removeAllObjects];
    [SHTUserDefaults removeObjectForKey:HISTORY_SEARCHES_KEY];
    [self.collectionView reloadData];
}

#pragma mark - 换一换

- (void)changePopular {
    self.popularIndex++;
    [self requestRecommendedData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searcheDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat imgViewWidth = 85.0;
    CGFloat imgViewHeight = imgViewWidth * (16.0 / 9.0); // 默认 16:9 比例
    return imgViewHeight + 20.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DJXPlayletInfoModel *model = self.searcheDatas[indexPath.item];
    SHTSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTSearchTableViewCell" forIndexPath:indexPath];
    cell.playletinfoModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SHTToolsManager enterPlayer:self.searcheDatas[indexPath.item] fromVC:self];
    // 取消选中效果（有动画）
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DJXPlayletDetailCellDelegate

- (UIView *)djx_playletDetailCellCustomView:(UITableViewCell *)cell {
    return [[SHTFavoriteManager sharedInstance] setCollectView:cell];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView {
    [[SHTFavoriteManager sharedInstance] setCollectViewFrame:cell layoutSubviews:customView];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(DJXPlayletInfoModel *)playletInfo {
    [[SHTFavoriteManager sharedInstance] collectViewUpdateSubview:customView withData:playletInfo andIsDraw:NO];
}

@end
