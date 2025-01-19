//
//  LCSChannelViewController.m
//  DJXSamples
//
//  Created by iCuiCui on 2020/5/27.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSChannelViewController.h"

typedef void(^LCSPageButtonSelected)(NSInteger currentIndex);

@interface LCSChannelPage()
@property (nonatomic, copy) NSArray *pageArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, copy) LCSPageButtonSelected pageButtonSelected;

- (void)setChannelPageIndex:(NSInteger)index;

@end
@implementation LCSChannelPage

- (instancetype)initWithFrame:(CGRect)frame pageArr:(NSArray *)pageArr {
    self = [super initWithFrame:frame];
    if (self) {
        _pageArr = pageArr;
        _titleArr = [NSMutableArray new];
        [self buidSubViews];
        [self setChannelPageIndex:0];
    }
    return self;
}

- (void)buidSubViews {
    for (int i = 0; i<_pageArr.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(i*CGRectGetWidth(self.bounds)/_pageArr.count, 0, CGRectGetWidth(self.bounds)/_pageArr.count,CGRectGetHeight(self.bounds));
        [titleButton setTitle:_pageArr[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        [_titleArr addObject:titleButton];
    }
}

- (void)didSelectedButton:(UIButton *)btn {
    [self setChannelPageIndex:btn.tag];
    if (self.pageButtonSelected) {
        self.pageButtonSelected(btn.tag);
    }
}

- (void)setChannelPageIndex:(NSInteger)index {
    [_titleArr enumerateObjectsUsingBlock:^(UIButton *titleButton, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            [titleButton setTitleColor:LCS_mainColor forState:UIControlStateNormal];
            titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        } else {
            [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        }
    }];
}

@end

@interface LCSChannelPageChildVC : UIViewController

@end

@implementation LCSChannelPageChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self createTipsLabel]];
}

- (UILabel *)createTipsLabel {
    UILabel *label = [UILabel new];
    label.frame = self.view.bounds;
    label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    label.text = @"业务方自定义页面";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end

static NSInteger const videoPageIndex = 1;//小视频的位置

@interface LCSChannelViewController ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat categoryTop;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LCSChannelPage *channelPage;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *childVCs;
@property (nonatomic, strong) UIViewController *preVC;
@property (nonatomic, assign) NSInteger preIndex;
@end

@implementation LCSChannelViewController

- (instancetype)initWithCategoryTop:(CGFloat)categoryTop {
    if (self = [super init]) {
        _categoryTop = categoryTop;
        _childVCs = [NSMutableDictionary dictionary];
        _preIndex = -1;
    }
    return self;
}

- (instancetype)init {
    return [self initWithCategoryTop:LCS_navBarHeight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buidSubViews];
    self.childVCs = [NSMutableDictionary dictionary];
    [self changeCurrentVCIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)buidSubViews {
    [self.view addSubview:self.channelPage];
    [self.view addSubview:self.scrollView];
}

- (UIViewController *)addControllerWithIndexIfNeeded:(NSInteger)index {
    UIViewController *vc = self.childVCs[@(index)];
    if (!vc) {
        if (index == videoPageIndex) {
            vc = self.categoryController;
        } else {
            vc = [LCSChannelPageChildVC new];
        }
        
        vc.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds) * index, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
        self.childVCs[@(index)] = vc;
    }
    
    if (!self.categoryWillAppear) {
        [self addChildViewController:vc];
    }
    [self.scrollView addSubview:vc.view];
    if (!self.categoryWillAppear) {
        [vc didMoveToParentViewController:self];
    }
    
    return vc;
}

- (void)changeCurrentVCIfNeeded {
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    UIViewController *currentVC = self.childVCs[@(index)];
    if (currentVC == nil || self.preVC != currentVC) {
        currentVC = [self addControllerWithIndexIfNeeded:index];
        
        if (!self.categoryWillDisAppear) {
            [self.preVC willMoveToParentViewController:nil];
        }
        [self.preVC.view removeFromSuperview];
        if (!self.categoryWillDisAppear) {
            [self.preVC removeFromParentViewController];
        }
        self.preVC = currentVC;
    }
}

- (void)_updateDrawViewControllerAppearStatusWithIndex:(NSInteger)index {
    if (self.preIndex != index) {
        if (index == videoPageIndex) {// 主动调用展示和隐藏方法
            if (self.categoryWillAppear) {
                self.categoryWillAppear();
            } else {
                [self.categoryController beginAppearanceTransition:YES animated:NO];
                [self.categoryController endAppearanceTransition];
            }
        } else {
            if (self.preIndex == videoPageIndex) {
                if (self.categoryWillDisAppear) {
                    self.categoryWillDisAppear();
                } else {
                    [self.categoryController beginAppearanceTransition:NO animated:NO];
                    [self.categoryController endAppearanceTransition];
                }
            }
        }
        self.preIndex = index;
    }
}

- (LCSChannelPage *)channelPage {
    if (!_channelPage) {
        _channelPage = [[LCSChannelPage alloc] initWithFrame:CGRectMake(0, self.categoryTop, CGRectGetWidth(self.view.bounds), LCS_CHANNEL_PAGE_HEIGHT) pageArr:@[@"首页",self.categoryName,@"推荐",@"本地"]];
        lcs_weakify(self)
        _channelPage.pageButtonSelected = ^(NSInteger currentIndex) {
            lcs_strongify(self)
            self.scrollView.contentOffset = CGPointMake(self.scrollView.width*currentIndex, 0);
            [self _updateDrawViewControllerAppearStatusWithIndex:currentIndex];
        };
    }
    return _channelPage;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.channelPage.bottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.channelPage.bottom)];
        //取消反弹效果
        _scrollView.bounces = NO;
        //隐藏垂直方向的滑动条也就是滑块
        _scrollView.showsVerticalScrollIndicator = NO;
        //隐藏水平方向的滑动条也就是滑块
        _scrollView.showsHorizontalScrollIndicator = NO;
        //设置原点偏移量
        _scrollView.contentOffset = CGPointMake(0, 0);
        //设置滚动试图的代理
        _scrollView.delegate = self;
        //设置分页效果
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeCurrentVCIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self.channelPage setChannelPageIndex:index];
    [self _updateDrawViewControllerAppearStatusWithIndex:index];
}

@end
