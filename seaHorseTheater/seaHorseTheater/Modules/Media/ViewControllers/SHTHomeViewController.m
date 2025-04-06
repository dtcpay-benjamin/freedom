//
//  SHTMainViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 1/26/25.
//

#import "SHTHomeViewController.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTFavoriteViewController.h"

@interface SHTHomeViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
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
@property (nonatomic, strong) UIButton *editBtn; //编辑按钮
@property (nonatomic, assign) NSUInteger currentIndex; //当前位置
@property (nonatomic, assign) NSUInteger preIndex; //当前位置
@property (nonatomic, strong) UIView *editBar;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UIButton *deleteButton;
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
    [self setUpEditBar];
}

- (void)setupSegmentedControl {
    self.segmentedBackView = [[UIView alloc] init];
    self.segmentedBackView.backgroundColor = [UIColor clearColor];
    self.segmentedBackView.frame = CGRectMake(0, 0, SHTScreenWidth, SHT_STATUS_BAR_HEIGHT + 40);
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"收藏", @"剧单", @"精选"]];
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
    [self.segmentedBackView addSubview:self.editBtn];
    [self.view bringSubviewToFront:self.segmentedBackView];
}

- (void)setUpSegmentedBackColor:(NSInteger)index {
    if (index == 0) {
        self.segmentedBackView.backgroundColor = [UIColor blackColor];
    } else {
        self.segmentedBackView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setUpEditBar {
    self.editBar.frame = CGRectMake(0, SHTScreenHeight - SHT_tabBarHeight, SHTScreenWidth, SHT_tabBarHeight);
    self.selectAllButton.frame = CGRectMake(80, 0, 80, 50);
    self.deleteButton.frame = CGRectMake(SHTScreenWidth - 80 - 80, 0, 80, 50);
    [self.view addSubview:self.editBar];
    [self.editBar addSubview:self.selectAllButton];
    [self.editBar addSubview:self.deleteButton];
    [self.editBar setHidden:YES];
}

#pragma mark - 编辑按钮点击事件
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
        [self.editBar setHidden:NO];
    } else {
        self.segmentedControl.hidden = NO;
        self.editTitleLabel.hidden = YES;
        [self.pageViewController setViewControllers:@[self.pages[self.preIndex]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        if (!self.selectAllButton.isSelected) {
            [self selectAllAction:self.selectAllButton];
        }
        [self.editBar setHidden:YES];
    }
    [self.favoriteVC editFavorites:sender.isSelected];
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(SHTScreenWidth - 60, SHT_STATUS_BAR_HEIGHT, 40, 40);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"退出" forState:UIControlStateSelected];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_editBtn addTarget:self action:@selector(actionEdtit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UILabel *)editTitleLabel {
    if (!_editTitleLabel) {
        _editTitleLabel = [[UILabel alloc] init];
        _editTitleLabel.frame = CGRectMake(SHTScreenWidth * 0.5 - 20.0, SHT_STATUS_BAR_HEIGHT, 40.0, 40.0);
        _editTitleLabel.textColor = [UIColor whiteColor];
        _editTitleLabel.font = [UIFont systemFontOfSize:18];
        _editTitleLabel.text = @"收藏";
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
        _favoriteVC.selectActionCallBack = ^(_Bool isAllSelect) {
           // 是否全选中
            
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

/// 初始化短剧滑滑流
- (DJXDrawVideoViewController *)playletVC {
    if (!_playletVC) {
        _playletVC = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
            DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
            playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
            playletConfig.freeEpisodesCount = 5;
            playletConfig.unlockEpisodesCountUsingAD = 1;
            config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
            config.viewSize = CGSizeMake(SHTScreenWidth, SHTScreenHeight - SHT_tabBarHeight);
            config.shouldHideTabBarView = YES;
            config.playletConfig = playletConfig;
        }];
    }
    return  _playletVC;
}

- (UIView *)editBar {
    if (!_editBar) {
        _editBar = [[UIView alloc] init];
        _editBar.backgroundColor = [UIColor blackColor];
    }
    return _editBar;
}

- (UIButton *)selectAllButton {
    if (!_selectAllButton) {
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_selectAllButton setTitle:@"取消全选" forState:UIControlStateNormal];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateSelected];
        [_selectAllButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_selectAllButton addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _selectAllButton.selected = YES;
    }
    return _selectAllButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateSelected];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _deleteButton;
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
    if (!self.editBtn.isSelected) {
        self.currentIndex = targetIndex;
    }
    [self slideUnderline:targetIndex];
    [self setUpSegmentedBackColor:targetIndex];
}

#pragma mark - “全选按钮”点击事件
- (void)selectAllAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.deleteButton.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.favoriteVC cancelSelectAllFavoriteData];
    } else {
        [self.favoriteVC selectAllFavoriteData];
    }
}

- (void)deleteAction:(UIButton *)sender {
    // 只有删除按钮是选中状态的时候才可以操作
    if (sender.isSelected) {
        [self.favoriteVC deleteFavoriteData];
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        // 获取当前显示的页面索引
        UIViewController *currentVC = pageViewController.viewControllers.firstObject;
        NSUInteger index = [self.pages indexOfObject:currentVC];
        // 更新 UISegmentedControl 的选中项
        self.segmentedControl.selectedSegmentIndex = index;
        if (!self.editBtn.isSelected) {
            self.currentIndex = index;
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

@end
