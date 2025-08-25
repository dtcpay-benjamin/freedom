//
//  SHTRecentlyWatchedViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/28.
//

#import "SHTRecentlyWatchedViewController.h"
#import <PangrowthDJX/DJXSDK.h>
#import "SHTRecentWatchCell.h"
#import "Masonry.h"

@interface SHTRecentlyWatchedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<DJXPlayletInfoModel *> *playletList;

@end

@implementation SHTRecentlyWatchedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR_DARK;
    self.title = NSLocalizedString(@"recently_watched", nil);
    [self setUpViews];
    [self setUpLayoutSubViews];
    [self loadData];
}

- (void)setUpViews {
    [self.view addSubview:self.collectionView];
}

- (void)setUpLayoutSubViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    
}

#pragma mark - 懒加载

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

@end
