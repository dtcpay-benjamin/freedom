//
//  SHTMemberCenterViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 6/14/25.
//

#import "SHTMemberCenterViewController.h"
#import "SHTMemberSelectionCell.h"
#import "SHTMemberModel.h"
#import "SHTMemberImmediatelyCell.h"
#import "SHTBriefIntroductionTableViewCell.h"
#import "SHTPremiumFeaturesTableViewCell.h"
#import "SHTBriefIntroductionModel.h"
#import "SHTStringFormatter.h"
#import "SHTDeviceIDManager.h"
#import "SHTKindReminderTableViewCell.h"
#import "SHTToolsManager.h"
#import "SHTServiceAgreementViewController.h"
#import "SHTRouteUtil.h"

@interface SHTMemberCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SHTBriefIntroductionModel *briefIntroductionModel;
@property (nonatomic, copy) NSMutableArray *memberTypesArray;
@property (nonatomic, copy) NSArray *premiumFeaturesArray; // 用户特权数据
@property (nonatomic, strong) SHTMemberModel *selectMemberModel; // 选中的会员类型
@property (nonatomic, assign) BOOL isServiceAgreementReaded; // 是否已经阅读会员服务协议
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
    self.briefIntroductionModel = [SHTBriefIntroductionModel modelWithTitle:[NSString stringWithFormat:@"海马剧友 %@", [SHTStringFormatter formatString:[SHTDeviceIDManager getDeviceID] fromStart:NO length:12 caseOption:StringCaseOptionLowercase]] activateVip:NO];
    SHTMemberModel *model = [SHTMemberModel modelWithMemberType:SHTMemberTypeWeeklySubscription amount:1 originalAmount:12 currency:@"¥"];
    [self.memberTypesArray addObject:model];
    SHTMemberModel *model1 = [SHTMemberModel modelWithMemberType:SHTMemberTypeMonthlySubscription amount:9.9 originalAmount:39 currency:@"¥"];
    [self.memberTypesArray addObject:model1];
    SHTMemberModel *model2 = [SHTMemberModel modelWithMemberType:SHTMemberTypeAnnualSubscription amount:49 originalAmount:299 currency:@"¥"];
    [self.memberTypesArray addObject:model2];
    
    self.premiumFeaturesArray = @[
      @{
        @"featuresImage": @"unlimitedStreaming",
        @"title": @"无限片源",
        @"subTitle": @"新剧抢先看"
       },
      
      @{
          @"featuresImage": @"AdFree",
          @"title": @"免广告",
          @"subTitle": @"看剧无广告"
       },
      
      @{
          @"featuresImage": @"moreBenefits",
          @"title": @"更多特权",
          @"subTitle": @"敬请期待"
       }
    ];
}

- (void)adjustUI {
    [self.tableView reloadData];
}

// 开通会员
- (void)subscribeMember {
    
}

// 跳转会员服务协议详情
- (void)jumpMembershipServiceAgreement {
    SHTServiceAgreementViewController *serviceAgreementVC = [[SHTServiceAgreementViewController alloc] init];
    [serviceAgreementVC loadMainBundleHtml:@"membershipServiceAgreement"];
    [SHTRouteUtil pushFrom:self to:serviceAgreementVC];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = SHT_BACK_COLOR_DARK;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[SHTBriefIntroductionTableViewCell class] forCellReuseIdentifier:@"SHTBriefIntroductionTableViewCell"];
        [_tableView registerClass:[SHTPremiumFeaturesTableViewCell class] forCellReuseIdentifier:@"SHTPremiumFeaturesTableViewCell"];
        [_tableView registerClass:[SHTMemberSelectionCell class] forCellReuseIdentifier:@"SHTMemberSelectionCell"];
        [_tableView registerClass:[SHTMemberImmediatelyCell class] forCellReuseIdentifier:@"SHTMemberImmediatelyCell"];
        [_tableView registerClass:[SHTKindReminderTableViewCell class] forCellReuseIdentifier:@"SHTKindReminderTableViewCell"];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 102.0;
    } else if (indexPath.row == 1) {
        return 175.0;
    } else if (indexPath.row == 2) {
        return 183.0;
    } else if (indexPath.row == 3) {
        return 114.0;
    } else {
        return 197.0;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SHTBriefIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTBriefIntroductionTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.briefIntroductionModel;
        return cell;
    } else if (indexPath.row == 1) {
        SHTPremiumFeaturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTPremiumFeaturesTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.datas = self.premiumFeaturesArray;
        return cell;
    } else if (indexPath.row == 2) {
        SHTMemberSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTMemberSelectionCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.datas = [self.memberTypesArray mutableCopy];
        __weak typeof(self) weakSelf = self;
        cell.memberSelectionTapped = ^(SHTMemberModel * _Nonnull model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 选择会员类型
            strongSelf.selectMemberModel = model;
        };
        return cell;
    } else if (indexPath.row == 3) {
        SHTMemberImmediatelyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTMemberImmediatelyCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        cell.memberImmediatelyOnTapped = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 开通会员
            [strongSelf subscribeMember];
        };
        cell.radioOnTapped = ^(BOOL isSelected) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 已经阅读会员服务协议
            strongSelf.isServiceAgreementReaded = isSelected;
        };
        cell.serviceAgreementOnTapped = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 跳转会员服务协议详情
            [strongSelf jumpMembershipServiceAgreement];
        };
        return cell;
    } else {
        SHTKindReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTKindReminderTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = SHT_BACK_COLOR_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = [SHTToolsManager serializationFromJson:[[NSBundle mainBundle] pathForResource:@"kindReminder" ofType:@"json"]];
        NSString *content = dic[@"membership_notice"];
        cell.content = content;
        return cell;
    }
}

@end
