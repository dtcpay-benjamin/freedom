//
//  SHTKaiPingADViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2/4/25.
//

#import "SHTKaiPingADViewController.h"
#import "AppDelegate.h"
#import <BUAdSDK/BUAdSDK.h>
#import "SHTAlertHelper.h"
#import <Reachability/Reachability.h>
#import "SHTMBProgressManager.h"
#import "SHTToolsManager.h"
@interface SHTKaiPingADViewController () <BUSplashAdDelegate>

@property (nonatomic, strong) BUSplashAd *shtSplashAd;

@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, assign) NetworkStatus networkStatus;

@end

@implementation SHTKaiPingADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachability startNotifier];
    [self checkInitialNetworkStatus];
}

- (void)checkInitialNetworkStatus {
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    self.networkStatus = status;
    switch (status) {
        case NotReachable:
            [self setupNetwork];
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            [self loadInitialPage];
            break;
    }
}

- (void)setupNetwork {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SHTAlertHelper showAlertWithTitle:@"提示" message:@"当前网络不可用，请检查设置" cancelBtnText:nil confirmBtnText:@"去设置" inController:self cancelAction:nil confirmAction:^{
            if (self.networkStatus != NotReachable) {
                [SHTMBProgressManager showText:self.view withText:@"刚才已通过系统弹窗设置" andSubText:nil isBottom:NO];
            } else {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
                }
            }
        }];
    });
}

- (void)networkChanged:(NSNotification *)note {
    Reachability *reach = [note object];
    self.networkStatus = [reach currentReachabilityStatus];
    if (self.networkStatus != NotReachable) {
        UIViewController *topVC = [SHTToolsManager getTopViewController];
        if ([topVC isKindOfClass:[UIAlertController class]]) {
            UIAlertController *alert = (UIAlertController *)topVC;
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
        [self loadInitialPage];
    }
}

- (void)loadInitialPage {
    // 设置广告位
    [self buildAd];
    // 加载广告
    [self loadAdData];
}

// 创建广告对象
- (void)buildAd {
    BUAdSlot *slot = [[BUAdSlot alloc]init];
    slot.ID = @"890787307"; // 代码位
    self.shtSplashAd = [[BUSplashAd alloc] initWithSlot:slot adSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    self.shtSplashAd.delegate = self;
}

// 触发广告加载
- (void)loadAdData {
    [self.shtSplashAd loadAdData];
}

- (void)loadHome {
    AppDelegate *applicationShare = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [applicationShare setupPangrowthSDK];
}

#pragma mark - BUSplashAdDelegate
- (void)splashAdLoadSuccess:(nonnull BUSplashAd *)splashAd {
    NSLog(@"开屏广告加载成功-shtSplashAd:%@", splashAd);
    [splashAd showSplashViewInRootViewController:self];
}

- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error {
    NSLog(@"开屏广告加载失败-shtSplashAd:%@, error:%@", splashAd, error);
    [self loadHome];
}

// 广告点击
- (void)splashAdDidClick:(BUSplashAd *)splashAd {
    [self loadHome];
}

// 广告播放控制器关闭(跳过或者播放完成)
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd {
    NSLog(@"广告关闭1");
    [self loadHome];
}

@end
