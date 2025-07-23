//
//  SHTMnieViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2/25/25.
//

#import "SHTMineViewController.h"
#import "SHTDeviceIDManager.h"
#import "SHTStringFormatter.h"
#import "SHTMemberCenterViewController.h"
#import "SHTRouteUtil.h"
#import <Masonry/Masonry.h>
#import "SHTMineHeaderCell.h"
#import "SHTMineModel.h"
#import "SHTOpenMemberAccountCell.h"

@interface SHTMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *membershipID; // 用户ID
@property (nonatomic, strong) UITableView *tableView; // 列表
@property (nonatomic, copy) NSMutableArray *configDataArray; // 列表配置

@end

@implementation SHTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTUIColorFromRGB(160.0, 96.0, 95.0);
    NSLog(@"Member Ship ID:%@", self.membershipID);
    // TODO:test
    //    [self addTestButton];
    [self setupDatas];
    [self addSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addSubViewsLayouts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

// 添加测试按钮
- (void)addTestButton {
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(SHTScreenWidth * 0.5 - 100, SHTScreenHeight * 0.5 - 30, 200, 60);
    [testBtn setTitle:@"test-去会员中心" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    testBtn.titleLabel.font = SHTUIFontBold(25);
    [testBtn addTarget:self action:@selector(actionTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)setupDatas {
    SHTMineModel *mineModel = [[SHTMineModel alloc] init];
    mineModel.mineType = SHTMineTypeHeader;
    mineModel.uniqueIdentifier = self.membershipID;
    [self.configDataArray addObject:mineModel];
    
    SHTMineModel *mineModel1 = [[SHTMineModel alloc] init];
    mineModel1.mineType = SHTMineTypeMemberGuidance;
    mineModel1.title = @"会员时长";
    mineModel1.subTitle = @"会员解锁全部短剧";
    [self.configDataArray addObject:mineModel1];
    
    SHTMineModel *mineModel2 = [[SHTMineModel alloc] init];
    mineModel2.mineType = SHTMineTypeCommon;
    mineModel2.title = @"充值记录";
    [self.configDataArray addObject:mineModel2];
    
    SHTMineModel *mineModel3 = [[SHTMineModel alloc] init];
    mineModel3.mineType = SHTMineTypeCommon;
    mineModel3.title = @"联系我们";
    [self.configDataArray addObject:mineModel3];
    
    SHTMineModel *mineModel4 = [[SHTMineModel alloc] init];
    mineModel4.mineType = SHTMineTypeCommon;
    mineModel4.title = @"建议反馈";
    [self.configDataArray addObject:mineModel4];
    
    SHTMineModel *mineModel5 = [[SHTMineModel alloc] init];
    mineModel5.mineType = SHTMineTypeCommon;
    mineModel5.title = @"用户协议";
    [self.configDataArray addObject:mineModel5];
    
    SHTMineModel *mineModel6 = [[SHTMineModel alloc] init];
    mineModel6.mineType = SHTMineTypeCommon;
    mineModel6.title = @"隐私政策";
    [self.configDataArray addObject:mineModel6];
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (void)addSubViewsLayouts {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
}

#pragma mark - actions

// test
- (void)actionTest:(UIButton *)sender {
    [SHTRouteUtil pushFrom:self to:[[SHTMemberCenterViewController alloc] init]];
}

#pragma mark - 懒加载
- (NSString *)membershipID {
    if (!_membershipID) {
        _membershipID = [SHTStringFormatter formatString:[SHTDeviceIDManager getDeviceID] fromStart:NO length:12 caseOption:StringCaseOptionLowercase];
    }
    return _membershipID;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 90.0;
        _tableView.backgroundColor = SHTUIColorFromRGB(160.0, 96.0, 95.0);
        [_tableView registerClass:[SHTMineHeaderCell class] forCellReuseIdentifier:@"SHTMineHeaderCell"];
        [_tableView registerClass:[SHTOpenMemberAccountCell class] forCellReuseIdentifier:@"SHTMineHeaderCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (NSMutableArray *)configDataArray {
    if (!_configDataArray) {
        _configDataArray = [[NSMutableArray alloc] init];
    }
    return _configDataArray;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 140.0;
    } else if (indexPath.row == 1) {
        return 200.0;
    } else {
        return 90.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHTMineModel *model = self.configDataArray[indexPath.row];
    if (indexPath.row == 0) {
        SHTMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTMineHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.model = model;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

@end
