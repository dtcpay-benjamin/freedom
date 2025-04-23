//
//  SHTMainViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "SHTHomeViewController.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTFavoriteViewController.h"
#import "SHTAlertHelper.h"
#import "SHTDrawVideoCollectView.h"

@interface SHTHomeViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, DJXDrawVideoCellAddSubviewDelegate, DJXPlayletDetailCellDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIViewController *favoriteBgdVC;
@property (nonatomic, strong) SHTFavoriteViewController *favoriteVC; //短剧收藏页
@property (nonatomic, strong) UIViewController *playletTheaterBgdVC;
@property (nonatomic, strong) DJXPlayletAggregatePageViewController *playletTheater; //短剧剧场
@property (nonatomic, strong) DJXDrawVideoViewController *playletVC; //短剧滑滑页
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) UIView *underlineView; //下划线
@property (nonatomic, strong) UIView *segmentedBackView; //标题栏背景
@property (nonatomic, strong) UISegmentedControl *segmentedControl; //标题栏
@property (nonatomic, strong) UILabel *editTitleLabel; //收藏编辑时候的标题栏
@property (nonatomic, strong) UIButton *favoriteEditBtn; //收藏标题栏编辑按钮
@property (nonatomic, strong) UIButton *searchBtn; //搜索按钮
@property (nonatomic, assign) NSUInteger currentIndex; //当前位置
@property (nonatomic, assign) NSUInteger preIndex; //当前位置
@property (nonatomic, strong) UIView *favoriteEditBar; //收藏底部编辑栏
@property (nonatomic, strong) UIButton *favoriteSelectAllButton; //收藏底部是否“全选”按钮
@property (nonatomic, strong) UIButton *favoriteDeleteButton; //收藏底部删除按钮
@property (nonatomic, strong) NSMutableArray *drawVideosArrays; //滑滑流已展示数据数组
@property (nonatomic, strong) NSMutableArray *drawFavoriteArrays; //滑滑流已收藏数据数组
@property (nonatomic, strong) SHTDrawVideoCollectView *currentCollectView; // 滑滑流当前播放短剧的收藏按钮
@end

@implementation SHTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    // 设置底部下划线
    [self setSegmentedControlUnderline];
    [self slideUnderline: self.segmentedControl.selectedSegmentIndex];
}

- (CGFloat)underlineWidth {
    return self.segmentedControl.bounds.size.width / 12.0;
}

- (void)initConfig {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pages = @[self.favoriteBgdVC, self.playletTheaterBgdVC, self.playletVC];
    [self.pageViewController setViewControllers:@[self.pages[2]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.favoriteBgdVC addChildViewController:self.favoriteVC];
    [self.favoriteBgdVC.view addSubview:self.favoriteVC.view];
    self.favoriteVC.view.frame = CGRectMake(0, SHT_STATUS_BAR_HEIGHT + 40, SHTScreenWidth, SHTScreenHeight - (SHT_STATUS_BAR_HEIGHT + 40) - SHT_tabBarHeight);
    [self.favoriteVC didMoveToParentViewController:self.favoriteBgdVC];
    
    [self.playletTheaterBgdVC addChildViewController:self.playletTheater];
    [self.playletTheaterBgdVC.view addSubview:self.playletTheater.view];
    self.playletTheater.view.frame = CGRectMake(0, SHT_STATUS_BAR_HEIGHT + 40, SHTScreenWidth, SHTScreenHeight - (SHT_STATUS_BAR_HEIGHT + 40) - SHT_tabBarHeight);
    [self.playletTheater didMoveToParentViewController:self.playletTheaterBgdVC];
    
    [self setupSegmentedControl];
    [self setUpfavoriteEditBar];
}

- (void)setupSegmentedControl {
    self.segmentedBackView = [[UIView alloc] init];
    self.segmentedBackView.backgroundColor = [UIColor clearColor];
    self.segmentedBackView.frame = CGRectMake(0, 0, SHTScreenWidth, SHT_STATUS_BAR_HEIGHT + 40);
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"在追", @"剧场", @"精选"]];
    self.segmentedControl.frame = CGRectMake(80, SHT_STATUS_BAR_HEIGHT, SHTScreenWidth - 160, 40);
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    // 设置选中的字体颜色为白色
    NSDictionary *selectedAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
    };
    [self.segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    // 设置未选中项的字体颜色，带透明度
    if (@available(iOS 14.0, *)) {
        NSDictionary *unselectedAttributes = @{
            NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSTrackingAttributeName: @0.6 // 设置未选中项字体透明度
        };
        [self.segmentedControl setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        // 设置未选中项的字体颜色，带透明度
        NSDictionary *unselectedAttributes = @{
            NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
            NSFontAttributeName: [UIFont systemFontOfSize:18] // 设置未选中项字体透明度
        };
        [self.segmentedControl setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    }
    [self.segmentedControl setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[[UIImage alloc] init] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.segmentedControl.tintColor = [UIColor clearColor];
    self.segmentedControl.selectedSegmentIndex = 2;
    self.currentIndex = 2;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedBackView];
    [self.segmentedBackView addSubview:self.segmentedControl];
    [self.segmentedBackView addSubview:self.editTitleLabel];
    [self.segmentedBackView addSubview:self.favoriteEditBtn];
    [self.segmentedBackView addSubview:self.searchBtn];
    self.favoriteEditBtn.hidden = YES;
    self.searchBtn.hidden = NO;
    [self.view bringSubviewToFront:self.segmentedBackView];
}

- (void)setUpfavoriteEditBar {
    self.favoriteEditBar.frame = CGRectMake(0, SHTScreenHeight - SHT_tabBarHeight, SHTScreenWidth, SHT_tabBarHeight);
    self.favoriteSelectAllButton.frame = CGRectMake(80, 0, 80, 50);
    self.favoriteDeleteButton.frame = CGRectMake(SHTScreenWidth - 80 - 80, 0, 80, 50);
    [self.view addSubview:self.favoriteEditBar];
    [self.favoriteEditBar addSubview:self.favoriteSelectAllButton];
    [self.favoriteEditBar addSubview:self.favoriteDeleteButton];
    [self.favoriteEditBar setHidden:YES];
}

#pragma mark - 懒加载

- (UIButton *)favoriteEditBtn {
    if (!_favoriteEditBtn) {
        _favoriteEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favoriteEditBtn.frame = CGRectMake(SHTScreenWidth - 60, SHT_STATUS_BAR_HEIGHT, 40, 40);
        [_favoriteEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_favoriteEditBtn setTitle:@"退出" forState:UIControlStateSelected];
        [_favoriteEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_favoriteEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _favoriteEditBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_favoriteEditBtn addTarget:self action:@selector(actionEdtit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favoriteEditBtn;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(SHTScreenWidth - 60, SHT_STATUS_BAR_HEIGHT, 40, 40);
        [_searchBtn setImage:[UIImage imageNamed:@"search_larger"] forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"search_larger"] forState:UIControlStateSelected];
        [_searchBtn addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UILabel *)editTitleLabel {
    if (!_editTitleLabel) {
        _editTitleLabel = [[UILabel alloc] init];
        _editTitleLabel.frame = CGRectMake(SHTScreenWidth * 0.5 - 20.0, SHT_STATUS_BAR_HEIGHT, 40.0, 40.0);
        _editTitleLabel.textColor = [UIColor whiteColor];
        _editTitleLabel.font = [UIFont systemFontOfSize:18];
        _editTitleLabel.text = @"在追";
        _editTitleLabel.hidden = YES;
    }
    return _editTitleLabel;
}

// 设置下划线
- (void)setSegmentedControlUnderline {
    if (![self.segmentedControl.subviews containsObject:self.underlineView]) {
        self.underlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.underlineWidth, 2)];
        self.underlineView.backgroundColor = [UIColor whiteColor];
        [self.segmentedControl addSubview:self.underlineView];
    }
}

- (void)slideUnderline:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x = (2 * index + 1) * self.underlineWidth * 2;
        self.underlineView.center = CGPointMake(x, self.segmentedControl.frame.size.height - 1);
    }];
}

- (UIViewController *)favoriteBgdVC {
    if (!_favoriteBgdVC) {
        _favoriteBgdVC = [[UIViewController alloc] init];
    }
    return _favoriteBgdVC;
}
/// 初始化收藏页
- (SHTFavoriteViewController *)favoriteVC {
    if (!_favoriteVC) {
        _favoriteVC = [[SHTFavoriteViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        _favoriteVC.selectActionCallBack = ^(bool isAllSelect, bool isSomeSelect) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
           // 是否全选中
           strongSelf.favoriteSelectAllButton.selected = isAllSelect;
            strongSelf.favoriteDeleteButton.selected = isSomeSelect;
        };
        
        _favoriteVC.contentDetectionCallBack = ^(bool isEmpty) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (isEmpty) {
                // 没有收藏数据则隐藏编辑按钮
                strongSelf.favoriteEditBtn.hidden = YES;
                if (strongSelf.favoriteEditBtn.isSelected) {
                    [strongSelf actionEdtit:strongSelf.favoriteEditBtn];
                }
            } else {
                strongSelf.favoriteEditBtn.hidden = NO;
            }
        };
        
        _favoriteVC.goToDramaMarketCallBack = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
            [strongSelf.pageViewController setViewControllers:@[strongSelf.pages[2]]
                                              direction:direction
                                               animated:YES
                                             completion:nil];
            [UIView animateWithDuration:0.25 animations:^{
                strongSelf.segmentedControl.selectedSegmentIndex = 2;
                [strongSelf slideUnderline:2];
                [strongSelf setUpSegmentedBackColor:2];
            }];
        };
        
        _favoriteVC.deleteActionCompletion = ^(NSArray *deleteArray){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf deleteFavorites:deleteArray];
        };
        
        _favoriteVC.cellLongPressHandler = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf actionEdtit:strongSelf.favoriteEditBtn];
        };
    }
    return _favoriteVC;
}

/// 初始化短剧剧场页
- (UIViewController *)playletTheaterBgdVC {
    if (!_playletTheaterBgdVC) {
        _playletTheaterBgdVC = [[UIViewController alloc] init];
    }
    return _playletTheaterBgdVC;
}

- (UIViewController *)playletTheater {
    if (!_playletTheater) {
        _playletTheater = [[DJXPlayletAggregatePageViewController alloc] initWithConfigBuilder:^(DJXPlayletAggregatePageVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
            playletConfig.freeEpisodesCount = 10;
            playletConfig.unlockEpisodesCountUsingAD = 5;
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            config.playletConfig = playletConfig;
            config.isShowNavigationItemTitle = NO;
            config.isShowNavigationItemBackButton = NO;
        }];
    }
    return _playletTheater;
}

#pragma mark - 初始化短剧滑滑流

- (DJXDrawVideoViewController *)playletVC {
    if (!_playletVC) {
        _playletVC = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 5;
            playletConfig.unlockEpisodesCountUsingAD = 1;
            playletConfig.hideLikeIcon = YES;
            playletConfig.hideCollectIcon = YES;
            playletConfig.customViewDelegate = self;
            
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(SHTScreenWidth, SHTScreenHeight - SHT_tabBarHeight);
            config.shouldHideTabBarView = YES;
            config.playletConfig = playletConfig;
            config.hideLikeIcon = YES;
            // 隐藏收藏按钮,用自定义的
            config.hideCollectIcon = YES;
            config.drawVideoCellAddSubviewDelegate = self;
        }];
    }
    return  _playletVC;
}
    
- (UIView *)favoriteEditBar {
    if (!_favoriteEditBar) {
        _favoriteEditBar = [[UIView alloc] init];
        _favoriteEditBar.backgroundColor = [UIColor blackColor];
    }
    return _favoriteEditBar;
}

- (UIButton *)favoriteSelectAllButton {
    if (!_favoriteSelectAllButton) {
        _favoriteSelectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favoriteSelectAllButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_favoriteSelectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_favoriteSelectAllButton setTitle:@"取消全选" forState:UIControlStateSelected];
        [_favoriteSelectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_favoriteSelectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_favoriteSelectAllButton addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        _favoriteSelectAllButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _favoriteSelectAllButton;
}

- (UIButton *)favoriteDeleteButton {
    if (!_favoriteDeleteButton) {
        _favoriteDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favoriteDeleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_favoriteDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_favoriteDeleteButton setTitle:@"删除" forState:UIControlStateSelected];
        [_favoriteDeleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_favoriteDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_favoriteDeleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _favoriteDeleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _favoriteDeleteButton;
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

- (void)segmentChanged:(UISegmentedControl *)sender {
    UIViewController *currentVC = self.pageViewController.viewControllers.firstObject;
    NSUInteger currentIndex = [self.pages indexOfObject:currentVC];
    NSUInteger targetIndex = sender.selectedSegmentIndex;
    if (targetIndex == currentIndex) {
        return; // 如果点击的就是当前页，直接 return，不切换
    }
    
    UIPageViewControllerNavigationDirection direction = (targetIndex < currentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[self.pages[targetIndex]]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
    if (!self.favoriteEditBtn.isSelected) {
        self.currentIndex = targetIndex;
    }
    [self slideUnderline:targetIndex];
    [self setUpSegmentedBackColor:targetIndex];
    if (targetIndex != 0) {
        self.favoriteEditBtn.hidden = YES;
        self.searchBtn.hidden = NO;
    } else {
        self.searchBtn.hidden = YES;
    }
}

- (void)setUpSegmentedBackColor:(NSInteger)index {
    if (index == 0) {
        self.segmentedBackView.backgroundColor = [UIColor blackColor];
    } else {
        self.segmentedBackView.backgroundColor = [UIColor clearColor];
    }
}

// 编辑按钮点击事件
- (void)actionEdtit:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.preIndex = self.currentIndex;
        self.segmentedControl.hidden = YES;
        self.editTitleLabel.hidden = NO;
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:nil];
        [self.favoriteEditBar setHidden:NO];
        [self enablePageControllerSliding:NO];
    } else {
        self.segmentedControl.hidden = NO;
        self.editTitleLabel.hidden = YES;
        [self.pageViewController setViewControllers:@[self.pages[self.preIndex]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        self.favoriteSelectAllButton.selected = NO;
        self.favoriteDeleteButton.selected = NO;
        [self.favoriteVC cancelSelectAllFavoriteData];
        [self.favoriteEditBar setHidden:YES];
        [self enablePageControllerSliding:YES];
    }
    [self.favoriteVC editFavorites:sender.isSelected];
}

// 搜索按钮点击事件
- (void)actionSearch:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSLog(@"搜索按钮点击~~~");
}

#pragma mark - 禁止或启动UIPageViewController滑动

- (void)enablePageControllerSliding:(BOOL)enable{
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.scrollEnabled = enable; //设置是否滑动
            break;
        }
    }
}

#pragma mark - “全选按钮”点击事件
- (void)selectAllAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.favoriteDeleteButton.selected = sender.isSelected;
    if (sender.isSelected) {
        [self.favoriteVC selectAllFavoriteData];
    } else {
        [self.favoriteVC cancelSelectAllFavoriteData];
    }
}

- (void)deleteAction:(UIButton *)sender {
    // 只有删除按钮是选中状态的时候才可以操作
    if (sender.isSelected) {
        [SHTAlertHelper showAlertWithTitle:@"提示"
                                   message:@"确认要删除收藏记录吗？"
                             cancelBtnText:nil
                            confirmBtnText:nil
                             inController:nil
                              cancelAction:nil confirmAction:^{
            [self.favoriteVC deleteFavoriteData];
            self.favoriteSelectAllButton.selected = NO;
            self.favoriteDeleteButton.selected = NO;
        }];
    }
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
    
#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        // 获取当前显示的页面索引
        UIViewController *currentVC = pageViewController.viewControllers.firstObject;
        NSUInteger index = [self.pages indexOfObject:currentVC];
        // 更新 UISegmentedControl 的选中项
        self.segmentedControl.selectedSegmentIndex = index;
        if (!self.favoriteEditBtn.isSelected) {
            self.currentIndex = index;
        }
        if (index != 0) {
            self.favoriteEditBtn.hidden = YES;
            self.searchBtn.hidden = NO;
        } else {
            self.searchBtn.hidden = YES;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self slideUnderline:index];
            [self setUpSegmentedBackColor:index];
        }];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index == 0) return nil;
    return self.pages[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index == self.pages.count - 1) return nil;
    return self.pages[index + 1];
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
    }
    NSLog(@"当前短剧:(%@)-id:%ld-收藏状态:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id, (long)playletInfoModel.favorite_state);
    __weak typeof(self) weakSelf = self;
    collectView.collectActionCallBack = ^(BOOL isCollect) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isCollect) {
            // 收藏短剧
            [[DJXPlayletManager shareInstance] collectShortplay:playletInfoModel.shortplay_id success:^{
                NSLog(@"短剧:(%@)收藏成功-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
                [strongSelf addDrawPlayletInfoToFavorites:playletInfoModel];
                [collectView setStatus:1];
                if (!IsDraw) {
                    [self.currentCollectView setStatus:1];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"短剧:(%@)收藏失败-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
            }];
        } else {
            // 取消收藏短剧
            [[DJXPlayletManager shareInstance] cancelCollectShortplay:playletInfoModel.shortplay_id success:^{
                NSLog(@"短剧:(%@)取消收藏成功-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
                [strongSelf deleteDrawPlayletInfoFromFavorites:playletInfoModel];
                [collectView setStatus:0];
                if (!IsDraw) {
                    [self.currentCollectView setStatus:0];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"短剧:(%@)取消收藏失败-id:%ld", playletInfoModel.title, (long)playletInfoModel.shortplay_id);
            }];
        }
    };
}

#pragma mark - DJXDrawVideoCellAddSubviewDelegate

- (UIView *)djx_drawVideoCellSubview:(UITableViewCell *)cell {
    return [self setCollectView:cell];
}

- (void)djx_drawVideoCell:(UITableViewCell *)cell layoutSubviews:(UIView *)subview {
    [self setCollectViewFrame:cell layoutSubviews:subview];
}

- (void)djx_drawVideoCell:(UITableViewCell *)cell updateSubview:(UIView *)subview withData:(DJXPlayletInfoModel *)playletInfoModel {
    [self collectViewUpdateSubview:subview withData:playletInfoModel andIsDraw:YES];
}

#pragma mark - DJXPlayletDetailCellDelegate

- (UIView *)djx_playletDetailCellCustomView:(UITableViewCell *)cell {
    return [self setCollectView:cell];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView {
    [self setCollectViewFrame:cell layoutSubviews:customView];
}

- (void)djx_playletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(DJXPlayletInfoModel *)playletInfo {
    [self collectViewUpdateSubview:customView withData:playletInfo andIsDraw:NO];
}

@end
