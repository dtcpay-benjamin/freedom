//
//  LCSDrawCustomTopTabViewController.m
//  EmpowerDemo
//
//  Created by yuxr on 2021/12/29.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSDrawCustomTopTabViewController.h"
#import "LCSSwitchSettingCell.h"

@interface LCSDrawCustomTopTabViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *settingCells;

@property (nonatomic) UIButton *enterButton;

@end

@implementation LCSDrawCustomTopTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.drawVCTabOptions = LCDDrawVideoVCTabOptions_recommand | LCDDrawVideoVCTabOptions_following;
    
    self.settingCells = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.lcs_width, 50)];
        
        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 200, 40)];
        enterButton.lcs_centerX = self.tableView.lcs_width / 2;
        [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterButton setBackgroundColor:LCS_mainColor];
        enterButton.clipsToBounds = YES;
        enterButton.layer.cornerRadius = 5;
        [enterButton setTitle:@"进入小视频" forState:UIControlStateNormal];
        [enterButton addTarget:self action:@selector(enterDrawVideo) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:enterButton];
        view;
    });
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    lcs_weakify(self)
    LCSBaseSettingCell *tabTypeSelectCell = [LCSBaseSettingCell new];
    tabTypeSelectCell.titleLabel.text = @"tab类型选择";
    tabTypeSelectCell.subTitleLabel.text = @"推荐+关注(点击修改)";
    tabTypeSelectCell.didSelectCellBlock = ^(LCSBaseSettingCell * _Nonnull cell) {
        lcs_strongify(self)
        UIAlertAction *defaultTabAlertAction = [UIAlertAction actionWithTitle:@"推荐+关注(默认)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.drawVCTabOptions = LCDDrawVideoVCTabOptions_recommand | LCDDrawVideoVCTabOptions_following;
            cell.subTitleLabel.text = @"推荐+关注";
            [cell setNeedsLayout];
        }];
        UIAlertAction *recommandOnlyTabAlertAction = [UIAlertAction actionWithTitle:@"仅推荐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.drawVCTabOptions = LCDDrawVideoVCTabOptions_recommand;
            cell.subTitleLabel.text = @"仅推荐";
            [cell setNeedsLayout];
        }];
        
        UIAlertAction *followingOnlyTabAction = [UIAlertAction actionWithTitle:@"仅关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.drawVCTabOptions = LCDDrawVideoVCTabOptions_following;
            cell.subTitleLabel.text = @"仅关注";
            [cell setNeedsLayout];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择tab类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:defaultTabAlertAction];
        [alertController addAction:recommandOnlyTabAlertAction];
        [alertController addAction:followingOnlyTabAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    LCSSwitchSettingCell *disableFollowingFuncCell = ({
        LCSSwitchSettingCell *cell = [LCSSwitchSettingCell new];
        cell.titleLabel.text = @"禁用关注功能(仅展示推荐tab时有效)";
        cell.swithValueDidChanged = ^(UISwitch * _Nonnull switchView) {
            lcs_strongify(self)
            self.shouldDisableFollowingFunc = switchView.on;
        };
        cell;
    });
    
    LCSSwitchSettingCell *hideTabBarViewCell = ({
        LCSSwitchSettingCell *openConsoleCell = [LCSSwitchSettingCell new];
        openConsoleCell.titleLabel.text = @"隐藏频道tab(仅有1个tab时有效)";
        openConsoleCell.swithValueDidChanged = ^(UISwitch * _Nonnull switchView) {
            lcs_strongify(self)
            self.shouldHideTabBarView = switchView.on;
        };
        openConsoleCell;
    });
    
    [self.settingCells addObject:tabTypeSelectCell];
    [self.settingCells addObject:disableFollowingFuncCell];
    [self.settingCells addObject:hideTabBarViewCell];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.settingCells[indexPath.row];
}

- (void)enterDrawVideo {
    if (self.enterDrawVideoAction) {
        self.enterDrawVideoAction(self);
    }
}

@end
