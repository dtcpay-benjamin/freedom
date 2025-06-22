//
//  SHTMemberCenterViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberCenterViewController.h"
#import "SHTMemberSelectionCell.h"
#import "SHTMemberModel.h"

@interface SHTMemberCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *memberTypesArray;

@end

@implementation SHTMemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR_DARK;
    self.title = @"会员中心";
    [self setupDatas];
    [self adjustUI];
}

#pragma mark - functions

- (void)setupDatas {
    SHTMemberModel *model = [SHTMemberModel modelWithMemberType:SHTMemberTypeWeeklySubscription amount:1 originalAmount:12 currency:@"¥"];
    [self.memberTypesArray addObject:model];
    SHTMemberModel *model1 = [SHTMemberModel modelWithMemberType:SHTMemberTypeMonthlySubscription amount:9.9 originalAmount:39 currency:@"¥"];
    [self.memberTypesArray addObject:model1];
    SHTMemberModel *model2 = [SHTMemberModel modelWithMemberType:SHTMemberTypeAnnualSubscription amount:49 originalAmount:299 currency:@"¥"];
    [self.memberTypesArray addObject:model2];
}

- (void)adjustUI {
    [self.tableView reloadData];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = SHT_BACK_COLOR_DARK;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 300.0;
        [_tableView registerClass:[SHTMemberSelectionCell class] forCellReuseIdentifier:@"SHTMemberSelectionCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)memberTypesArray {
    if (!_memberTypesArray) {
        _memberTypesArray = [[NSMutableArray alloc] init];
    }
    return _memberTypesArray;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200.0;
    } else if (indexPath.row == 1) {
        return 183.0;
    } else if (indexPath.row == 2) {
        return 200.0;
    } else {
        return 200.0;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        return cell;
    } else if (indexPath.row == 1) {
        SHTMemberSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTMemberSelectionCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.datas = [self.memberTypesArray mutableCopy];
        return cell;
    } else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        return cell;
    }
}

@end
