//
//  SHTMemberCenterViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberCenterViewController.h"
#import "SHTMemberSelectionCell.h"

@interface SHTMemberCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHTMemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR;
    self.title = @"会员中心";
    
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 300.0;
        [_tableView registerClass:[SHTMemberSelectionCell class] forCellReuseIdentifier:@"SHTMemberSelectionCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

@end
