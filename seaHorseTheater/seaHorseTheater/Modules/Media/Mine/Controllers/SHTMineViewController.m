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
#import "SHTOthersCell.h"
#import "SHTRechargeRecordsViewController.h"
#import "SHTServiceAgreementViewController.h"
#import "SHTPrivacyPolicyViewController.h"

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

- (void)setupDatas {
    SHTMineModel *mineModel = [[SHTMineModel alloc] init];
    mineModel.mineType = SHTMineTypeHeader;
    mineModel.uniqueIdentifier = self.membershipID;
    [self.configDataArray addObject:mineModel];
    
    SHTMineModel *mineModel1 = [[SHTMineModel alloc] init];
    mineModel1.mineType = SHTMineTypeMemberGuidance;
    mineModel1.title = @"会员时长";
    mineModel1.subTitle = @"会员解锁全部短剧";
    mineModel1.otherTitle = @"开通会员";
    [self.configDataArray addObject:mineModel1];
    
    NSMutableArray *othersArray = [[NSMutableArray alloc] init];
    SHTMineModel *mineModel2 = [[SHTMineModel alloc] init];
    mineModel2.uniqueIdentifier = @"czjl";
    mineModel2.mineType = SHTMineTypeCommon;
    mineModel2.title = @"充值记录";
    [othersArray addObject:mineModel2];
    
    SHTMineModel *mineModel3 = [[SHTMineModel alloc] init];
    mineModel3.uniqueIdentifier = @"fxapp";
    mineModel3.mineType = SHTMineTypeCommon;
    mineModel3.title = @"分享APP";
    [othersArray addObject:mineModel3];
    
    SHTMineModel *mineModel4 = [[SHTMineModel alloc] init];
    mineModel4.uniqueIdentifier = @"qwpf";
    mineModel4.mineType = SHTMineTypeCommon;
    mineModel4.title = @"前往评分";
    [othersArray addObject:mineModel4];
    
    SHTMineModel *mineModel5 = [[SHTMineModel alloc] init];
    mineModel5.uniqueIdentifier = @"yhxy";
    mineModel5.mineType = SHTMineTypeCommon;
    mineModel5.title = @"用户协议";
    [othersArray addObject:mineModel5];
    
    SHTMineModel *mineModel6 = [[SHTMineModel alloc] init];
    mineModel6.uniqueIdentifier = @"yszc";
    mineModel6.mineType = SHTMineTypeCommon;
    mineModel6.title = @"隐私政策";
    [othersArray addObject:mineModel6];
    [self.configDataArray addObject:othersArray];
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

- (void)shareAppAction {
    NSString *appURLString = @"https://apps.apple.com/app/id1234567890"; // 替换为你的 App ID
    NSURL *appURL = [NSURL URLWithString:appURLString];
    NSString *title = @"推荐你使用这款 App！";
    NSArray *itemsToShare = @[title, appURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    // 适配 iPad（防止 crash）
    activityVC.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityVC animated:YES completion:nil];
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
        [_tableView registerClass:[SHTOpenMemberAccountCell class] forCellReuseIdentifier:@"SHTOpenMemberAccountCell"];
        [_tableView registerClass:[SHTOthersCell class] forCellReuseIdentifier:@"SHTOthersCell"];
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
        return 202.0;
    } else {
        return 320.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        SHTMineModel *model = self.configDataArray[indexPath.row];
        SHTMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTMineHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1) {
        SHTMineModel *model = self.configDataArray[indexPath.row];
        SHTOpenMemberAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTOpenMemberAccountCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.model = model;
        cell.openMemberAccountTapped = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [SHTRouteUtil pushFrom:strongSelf to:[[SHTMemberCenterViewController alloc] init]];
        };
        return cell;
    } else {
        NSMutableArray *others = self.configDataArray[indexPath.row];
        SHTOthersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTOthersCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.datasArray = others;
        cell.enterNextTapped = ^(NSString * _Nonnull id) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([id isEqualToString:@"czjl"]) {
                    // 充值记录
                    [SHTRouteUtil pushFrom:strongSelf to:[[SHTRechargeRecordsViewController alloc] init]];
                } else if ([id isEqualToString:@"fxapp"]) {
                    // 分享APP
                    [strongSelf shareAppAction];
                } else if ([id isEqualToString:@"qwpf"]) {
                    // 前往评分
                    
                } else if ([id isEqualToString:@"yhxy"]) {
                    // 用户协议
                    SHTServiceAgreementViewController *serviceAgreementVC = [[SHTServiceAgreementViewController alloc] init];
                    [serviceAgreementVC loadMainBundleHtml:@"membershipServiceAgreement"];
                    [SHTRouteUtil pushFrom:strongSelf to:serviceAgreementVC];
                } else if ([id isEqualToString:@"yszc"]) {
                    // 隐私政策
                    SHTPrivacyPolicyViewController *privacyPolicyVC = [[SHTPrivacyPolicyViewController alloc] init];
                    [privacyPolicyVC loadMainBundleHtml:@"privacyPolicy"];
                    [SHTRouteUtil pushFrom:strongSelf to:privacyPolicyVC];
                }
            });
        };
        return cell;
    }
}

@end
