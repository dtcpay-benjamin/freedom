//
//  SHTSearchViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/4/25.
//

#import "SHTSearchViewController.h"
#import "SHTSearchBarView.h"
#import "SHTSearchCollectionViewCell.h"

@interface SHTSearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)SHTSearchBarView *searchBar; // 搜索框
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *historySearches;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *popularSearchGroups;
@property (nonatomic, strong) NSArray<NSString *> *popularSearches;
@property (nonatomic, assign) NSInteger popularIndex;

@end

@implementation SHTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_SEARCH_BACK_COLOR; // 浅灰背景
    [self setupSearchBar];
    [self setupCollectionView];
    [self setupData];
    [self setupGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar.textField becomeFirstResponder];
}

#pragma mark - UI

// 设置搜索栏
- (void)setupSearchBar {
    self.searchBar = [[SHTSearchBarView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 60)];
    __weak typeof(self) weakSelf = self;
    self.searchBar.onBackTapped = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.searchBar.onSearchTapped = ^(NSString *keyword) {
        NSLog(@"搜索关键词：%@", keyword); // 进行搜索操作
    };
    [self.view addSubview:self.searchBar];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[SHTSearchCollectionViewCell class] forCellWithReuseIdentifier:@"SHTSearchCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Data

- (void)setupData {
    self.historySearches = [NSMutableArray arrayWithArray:@[@"好吧我们", @"如果", @"陈好", @"快快", @"哈哈哈", @"绿丝带"]];
    self.popularSearchGroups = @[ @[@"野蛮女友美又飒", @"盲刃", @"庶女成凰"],
                                   @[@"新生从分手开始", @"我在女尊王朝当卧底"] ];
    self.popularIndex = 0;
    self.popularSearches = self.popularSearchGroups[self.popularIndex];
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

#pragma mark - actions

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return MIN(self.historySearches.count, 9); // 限制三行，假设每行 3 个
    return self.popularSearches.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTSearchCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.text = self.historySearches[indexPath.item];
    } else {
        cell.text = self.popularSearches[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = indexPath.section == 0 ? self.historySearches[indexPath.item] : self.popularSearches[indexPath.item];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return CGSizeMake(size.width + 20, 30);
}

#pragma mark - 删除历史记录

- (void)clearAllHistory {
    [self.historySearches removeAllObjects];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - 换一换

- (void)changePopular {
    self.popularIndex = (self.popularIndex + 1) % self.popularSearchGroups.count;
    self.popularSearches = self.popularSearchGroups[self.popularIndex];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}
@end
