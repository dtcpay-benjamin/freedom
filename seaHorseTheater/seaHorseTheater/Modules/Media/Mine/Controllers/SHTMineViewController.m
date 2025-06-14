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

@interface SHTMineViewController ()

@property(nonatomic, strong)NSString *membershipID;

@end

@implementation SHTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR;
    NSLog(@"Member Ship ID:%@", self.membershipID);
    
    // TODO:test
    [self addTestButton];
}

// 添加测试按钮
- (void)addTestButton {
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(SHTScreenWidth * 0.5 - 100, SHTScreenHeight * 0.5 - 30, 200, 60);
    [testBtn setTitle:@"test-去会员中心" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    testBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [testBtn addTarget:self action:@selector(actionTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
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
@end
