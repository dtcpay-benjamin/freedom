//
//  SHTGoogleKaiPingADViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/9/4.
//

#import "SHTGoogleKaiPingADViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AppDelegate.h"
#import "SHTAlertHelper.h"
#import <Reachability/Reachability.h>
#import "SHTMBProgressManager.h"
#import "SHTToolsManager.h"

@interface SHTGoogleKaiPingADViewController ()<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADAppOpenAd *appOpenAd;

@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, assign) NetworkStatus networkStatus;

@end

@implementation SHTGoogleKaiPingADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitialPage];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachability startNotifier];
    [self checkInitialNetworkStatus];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)loadInitialPage {
    [GADAppOpenAd loadWithAdUnitID:@"ca-app-pub-3564965271276647/2495037793" request:[GADRequest request] completionHandler:^(GADAppOpenAd * _Nullable appOpenAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"开屏广告加载失败: %@", error);
            [self loadHome];
            return;
        }
        self.appOpenAd = appOpenAd;
        self.appOpenAd.fullScreenContentDelegate = self;
        [self.appOpenAd presentFromRootViewController:nil];
    }];
}

- (void)showAdIfAvailableFrom:(UIViewController *)rootVC {
    if (self.appOpenAd) {
        [self.appOpenAd presentFromRootViewController:nil];
    } else {
        NSLog(@"开屏广告未准备好");
    }
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
        [SHTAlertHelper showAlertWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"networkSettingsTip", nil) cancelBtnText:nil confirmBtnText:NSLocalizedString(@"goToSettings", nil) inController:self cancelAction:nil confirmAction:^{
            if (self.networkStatus != NotReachable) {
                [SHTMBProgressManager showText:self.view withText:NSLocalizedString(@"settingCompletionReminder", nil) andSubText:nil isBottom:NO];
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

- (void)loadHome {
    AppDelegate *applicationShare = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [applicationShare setupPangrowthSDK];
}

#pragma mark - GADFullScreenContentDelegate
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self loadHome];
}

@end
