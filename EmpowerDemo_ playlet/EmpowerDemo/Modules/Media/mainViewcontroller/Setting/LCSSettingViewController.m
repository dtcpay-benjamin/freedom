//
//  LCSSettingViewController.m
//  DJXSamples
//
//  Created by iCuiCui on 2020/4/19.
//  Copyright © 2020 cuiyanan. All rights reserved.
//

#import "LCSSettingViewController.h"
#import "LCSSwitchSettingCell.h"

NSNotificationName _Nonnull const kLCSSettingVCAddCellsNotification = @"kLCSSettingVCAddCellsNotification";

@interface LCSSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *settingCells;

@end

@implementation LCSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSMutableArray *settingCells = [NSMutableArray new];
    lcs_weakify(self)
    LCSSwitchSettingCell *openConsoleCell = ({
        LCSSwitchSettingCell *openConsoleCell = [LCSSwitchSettingCell new];
        openConsoleCell.switchView.on = LCS_LOG_ENABLED;
        openConsoleCell.titleLabel.text = @"open ConsoleLog";
        openConsoleCell.swithValueDidChanged = ^(UISwitch * _Nonnull switchView) {
            LCS_LOG_ENABLED = switchView.on;
        };
        openConsoleCell;
    });
    
    [settingCells addObject:openConsoleCell];
    
    LCSBaseSettingCell *toastTypeSelectCell = [LCSBaseSettingCell new];
    toastTypeSelectCell.titleLabel.text = @"toast类型选择";
    toastTypeSelectCell.subTitleLabel.text = @"点击选择";
    toastTypeSelectCell.didSelectCellBlock = ^(LCSBaseSettingCell * _Nonnull cell) {
        lcs_strongify(self)
        UIAlertAction *defaultToastAlertAction = [UIAlertAction actionWithTitle:@"使用内容SDK toast(默认)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LCS_TOAST_TYPE = LCSDemoToastTypeDefault;
        }];
        UIAlertAction *customToastAlertAction = [UIAlertAction actionWithTitle:@"使用demo自定义toast" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LCS_TOAST_TYPE = LCSDemoToastTypeCustom;
        }];
        
        UIAlertAction *noneToastAlertAction = [UIAlertAction actionWithTitle:@"demo不弹出toast" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LCS_TOAST_TYPE = LCSDemoToastTypeNone;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            LCS_TOAST_TYPE = LCSDemoToastTypeDefault;
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择demo的toast类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:defaultToastAlertAction];
        [alertController addAction:customToastAlertAction];
        [alertController addAction:noneToastAlertAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    [settingCells addObject:toastTypeSelectCell];
    
    self.settingCells = settingCells;
    [self addDebugCells];
    
    [self.tableView reloadData];
}

- (void)addDebugCells {
    [NSNotificationCenter.defaultCenter postNotificationName:kLCSSettingVCAddCellsNotification object:@{
        @"settingVC": self,
        @"cellArray": self.settingCells
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.settingCells[indexPath.row];
}

@end
