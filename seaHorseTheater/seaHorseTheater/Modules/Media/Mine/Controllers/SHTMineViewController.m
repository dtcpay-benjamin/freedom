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

@interface SHTMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSString *membershipID;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR;
    NSLog(@"Member Ship ID:%@", self.membershipID);
    // TODO:test
    //    [self addTestButton];
    [self addSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addSubViewsLayouts];
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
        _tableView.backgroundColor = SHT_BACK_COLOR;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
