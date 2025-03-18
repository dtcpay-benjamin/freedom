//
//  SHTFavoriteViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 3/16/25.
//

#import "SHTFavoriteViewController.h"
@interface SHTFavoriteViewController ()

@end

@implementation SHTFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self requestCollection];
}

// 获取收藏的短剧数据
- (void)requestCollection {
    [[DJXPlayletManager shareInstance] requestCollectionList:0 pageSize:10 success:^(NSArray<DJXPlayletInfoModel *> * _Nonnull playletList, BOOL hasMore) {
        NSLog(@"收藏的短剧信息:%@, 是否还有更多:%d", playletList, hasMore);
    } failure:^(NSError * _Nonnull error) {
            
    }];
}

@end
