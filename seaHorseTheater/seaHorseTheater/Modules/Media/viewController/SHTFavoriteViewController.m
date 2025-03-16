//
//  SHTFavoriteViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 3/16/25.
//

#import "SHTFavoriteViewController.h"
#import <PangrowthDJX/DJXSDK.h>
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
            
    } failure:^(NSError * _Nonnull error) {
            
    }];
}

@end
