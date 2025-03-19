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
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
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
    [self setupSegmentedControl];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pages = @[[self configFavoriteVC], [self configPlayletTheater], [self configPlayletVC]];
    
    [self.pageViewController setViewControllers:@[self.pages[2]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)setupSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"收藏", @"剧单", @"精选"]];
    self.segmentedControl.frame = CGRectMake(0, 0, SHTScreenWidth, 40);
    self.segmentedControl.backgroundColor = [UIColor redColor];
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
    // 设置背景色
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    [self.segmentedControl setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[[UIImage alloc] init] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.segmentedControl.tintColor = [UIColor clearColor];
    self.segmentedControl.selectedSegmentIndex = 2;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
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

/// 初始化短剧剧场页
- (nonnull UIViewController *)configPlayletTheater {
    DJXPlayletAggregatePageViewController *vc = [[DJXPlayletAggregatePageViewController alloc] initWithConfigBuilder:^(DJXPlayletAggregatePageVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [DJXPlayletConfig new];
        playletConfig.freeEpisodesCount = 10;
        playletConfig.unlockEpisodesCountUsingAD = 5;
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        config.playletConfig = playletConfig;
        config.isShowNavigationItemTitle = NO;
        config.isShowNavigationItemBackButton = NO;
    }];
    return vc;
}

/// 初始化短剧滑滑流
- (nonnull UIViewController *)configPlayletVC {
    DJXDrawVideoViewController *smallVideoVC = [[DJXDrawVideoViewController alloc] initWithConfigBuilder:^(DJXDrawVideoVCConfig * _Nonnull config) {
        DJXPlayletConfig *playletConfig = [[DJXPlayletConfig alloc] init];
        playletConfig.playletUnlockADMode = DJXPlayletUnlockADMode_Common;
        playletConfig.freeEpisodesCount = 5;
        playletConfig.unlockEpisodesCountUsingAD = 2;
        
        config.drawVCTabOptions = DJXDrawVideoVCTabOptions_playlet_feed;
        config.viewSize = CGSizeMake(SHTScreenWidth, SHTScreenHeight - SHT_tabBarHeight);
        config.shouldHideTabBarView = YES;
        config.playletConfig = playletConfig;
    }];
    return smallVideoVC;
}

/// 初始化收藏页
- (nonnull UIViewController *)configFavoriteVC {
    SHTFavoriteViewController *vc = [[SHTFavoriteViewController alloc] init];
    return vc;
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    UIPageViewControllerNavigationDirection direction = (sender.selectedSegmentIndex == 0) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[self.pages[sender.selectedSegmentIndex]]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
    [self slideUnderline:sender.selectedSegmentIndex];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        // 获取当前显示的页面索引
        UIViewController *currentVC = pageViewController.viewControllers.firstObject;
        NSUInteger index = [self.pages indexOfObject:currentVC];
        // 更新 UISegmentedControl 的选中项
        self.segmentedControl.selectedSegmentIndex = index;
        [self slideUnderline:index];
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
