//
//  SHTSearchViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTSearchViewController.h"
#import "SHTSearchBarView.h"
#import "SHTSearchCollectionViewCell.h"
#import "SHTSearchCollectionReusableView.h"
#import "SHTUserDefaults.h"

@interface SHTSearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)SHTSearchBarView *searchBar; // 搜索框
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *historySearches;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *popularSearchGroups;
@property (nonatomic, strong) NSArray<NSString *> *popularSearches;
@property (nonatomic, assign) NSInteger popularIndex;

@end

@implementation SHTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_SEARCH_BACK_COLOR; // 浅灰背景
    [self setupData];
    [self setupSearchBar];
    [self setupCollectionView];
    [self setupGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SHTUserDefaults setObject:self.historySearches forKey:HISTORY_SEARCHES_KEY];
}
#pragma mark - UI

// 设置搜索栏
- (void)setupSearchBar {
    self.searchBar = [[SHTSearchBarView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 60)];
    __weak typeof(self) weakSelf = self;
    self.searchBar.onBackTapped = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.searchBar.onSearchTapped = ^(NSString *keyword) {
        NSLog(@"搜索关键词：%@", keyword);// 进行搜索操作
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.historySearches addObject:keyword];
        if (strongSelf.collectionView.numberOfSections > 1) {
            [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            [strongSelf.collectionView reloadData];
        }
    };
    [self.view addSubview:self.searchBar];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    layout.minimumLineSpacing = 12.0;
    layout.minimumInteritemSpacing = 12.0;
    layout.sectionInset = UIEdgeInsetsMake(20.0, 24.0, 20.0, 12.0);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame) + 20.0, self.view.frame.size.width, self.view.frame.size.height - 100.0) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[SHTSearchCollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"SHTSearchCollectionReusableView"];
    [self.collectionView registerClass:[SHTSearchCollectionViewCell class] forCellWithReuseIdentifier:@"SHTSearchCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Data

- (void)setupData {
    [self.historySearches addObjectsFromArray:[SHTUserDefaults objectForKey:HISTORY_SEARCHES_KEY]];
    self.popularSearchGroups = @[ @[@"野蛮女友美又飒", @"盲刃", @"庶女成凰"],
                                   @[@"jik", @"sccff"], @[@"qdcac", @"pnnc", @"qccxx"],
                                  @[@"wssxxx", @"onncnddds"] ];
    self.popularIndex = 0;
    self.popularSearches = self.popularSearchGroups[self.popularIndex];
    [self.collectionView reloadData];
}

// 设置收起键盘手势
- (void)setupGestureRecognizer {
    // 添加点击手势隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    tapGesture.cancelsTouchesInView = NO; // 允许点击事件继续传递给子视图（如按钮等）
    [self.view addGestureRecognizer:tapGesture];
    // 滑动手势隐藏键盘
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - 懒加载

- (NSMutableArray *)historySearches {
    if (!_historySearches) {
        _historySearches = [[NSMutableArray alloc] init];
    }
    return _historySearches;
}


#pragma mark - actions

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.historySearches.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (self.historySearches.count > 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SHTSearchCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:@"SHTSearchCollectionReusableView"
                                                                                                forIndexPath:indexPath];
            if (indexPath.section == 0) {
                header.title = @"历史搜索";
                header.actionImage = [UIImage imageNamed:@"ico-del-grey"];
                header.actionTitle = @"";
            } else {
                header.title = @"大家都在搜";
                header.actionImage = [UIImage imageNamed:@"ico-swap-grey"];
                header.actionTitle = @"换一换";
            }
            header.onTapped = ^{
                if (indexPath.section == 0) {
                    NSLog(@"历史搜索-删除");
                    [self clearAllHistory];
                } else {
                    NSLog(@"大家都在搜-换一换");
                    [self changePopular];
                }
            };
            return header;
        }
    } else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SHTSearchCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:@"SHTSearchCollectionReusableView"
                                                                                                forIndexPath:indexPath];
            header.title = @"大家都在搜";
            header.actionImage = [UIImage imageNamed:@"ico-swap-grey"];
            header.actionTitle = @"换一换";
            header.onTapped = ^{
                NSLog(@"大家都在搜-换一换");
                [self changePopular];
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
    if (self.historySearches.count > 0) {
        // 限定16条记录展示
        if (section == 0) return MIN(self.historySearches.count, 16);
        return MIN(self.popularSearches.count, 16);
    } else {
        return MIN(self.popularSearches.count, 16);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historySearches.count > 0) {
        SHTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTSearchCollectionViewCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.text = self.historySearches[indexPath.item];
        } else {
            cell.text = self.popularSearches[indexPath.item];
        }
        return cell;
    } else {
        SHTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTSearchCollectionViewCell" forIndexPath:indexPath];
        cell.text = self.popularSearches[indexPath.item];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.historySearches.count > 0 ? (indexPath.section == 0 ? self.historySearches[indexPath.item] : self.popularSearches[indexPath.item]) : self.popularSearches[indexPath.item];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return CGSizeMake(size.width + 20, 30);
}

#pragma mark - 删除历史记录

- (void)clearAllHistory {
    [self.historySearches removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - 换一换

- (void)changePopular {
    self.popularIndex = (self.popularIndex + 1) % self.popularSearchGroups.count;
    self.popularSearches = self.popularSearchGroups[self.popularIndex];
    if (self.historySearches.count > 0) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } else {
        [self.collectionView reloadData];
    }
}
@end
