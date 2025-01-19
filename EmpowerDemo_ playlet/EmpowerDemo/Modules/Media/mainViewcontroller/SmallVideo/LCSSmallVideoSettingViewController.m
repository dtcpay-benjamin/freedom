//
//  LCSSmallVideoSettingViewController.m
//  EmpowerDemo
//
//  Created by yuxr on 2021/12/16.
//  Copyright © 2021 bytedance. All rights reserved.
//

#import "LCSSmallVideoSettingViewController.h"
#import "LCSSwitchSettingCell.h"

NSString *const kLCSSmallVideoSettingKey_customVideoCardDislike = @"customVideoCardDislike";

NSUserDefaults *lcsGetSmallVideoSettings() {
    static NSUserDefaults *smallVideoSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smallVideoSettings = [[NSUserDefaults alloc] initWithSuiteName:@"LCSSmallVideoSetting"];
    });
    return smallVideoSettings;
}

@interface LCSSmallVideoSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *settingCells;

@end

@implementation LCSSmallVideoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    lcs_weakify(self)
    NSMutableArray *settingCells = [NSMutableArray arrayWithArray:@[
        ({
        LCSSwitchSettingCell *switchCell = [LCSSwitchSettingCell new];
        switchCell.switchView.on = [lcsGetSmallVideoSettings() boolForKey:kLCSSmallVideoSettingKey_customVideoCardDislike];
        switchCell.titleLabel.text = @"自定义小视频1.4/2.4 dislike";
        switchCell.swithValueDidChanged = ^(UISwitch * _Nonnull switchView) {
            [lcsGetSmallVideoSettings() setBool:switchView.on forKey:kLCSSmallVideoSettingKey_customVideoCardDislike];
        };
        switchCell;  }),
        
        ({
        LCSBaseSettingCell *baseCell = [LCSBaseSettingCell new];
        baseCell.titleLabel.text = @"清除设置";
        baseCell.didSelectCellBlock = ^(LCSBaseSettingCell * _Nonnull cell) {
            lcs_strongify(self)
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                lcs_strongify(self)
                [lcsGetSmallVideoSettings() removePersistentDomainForName:@"LCSSmallVideoSetting"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要清除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:okAlertAction];
            [alertController addAction:cancelAlertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        };
        baseCell;  })
    ]];
    self.settingCells = settingCells;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.settingCells[indexPath.row];
}

@end
