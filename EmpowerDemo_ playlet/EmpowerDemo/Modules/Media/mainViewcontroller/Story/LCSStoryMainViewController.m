//
//  LCSStoryMainViewController.m
//  EmpowerDemo
//
//  Created by admin on 2023/5/23.
//  Copyright © 2023 bytedance. All rights reserved.
//

#import "LCSStoryMainViewController.h"
#import "LCSStoryInterfaceViewController.h"
#import "LCSMiniStoryDemoViewController.h"

@interface LCSStoryMainViewController ()

@end

@implementation LCSStoryMainViewController

- (void)buildCells {
    lcs_weakify(self)
    
#if __has_include (<PangrowthMiniStory/MNManager.h>)
    LCSActionModel *shortStoryInterfaceModel = [LCSActionModel plainTitleActionModel:@"短故事相关API" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSStoryInterfaceViewController *vc = [LCSStoryInterfaceViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    LCSActionModel *shortStoryReaderDemo = [LCSActionModel plainTitleActionModel:@"短故事阅读器" cellType:LCSCellType_video action:^{
        lcs_strongify(self)
        LCSMiniStoryDemoViewController *vc = [LCSMiniStoryDemoViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.items = @[
        @[shortStoryInterfaceModel, shortStoryReaderDemo],
    ];
#endif
}


@end
