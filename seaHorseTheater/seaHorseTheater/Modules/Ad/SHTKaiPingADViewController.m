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

@interface SHTKaiPingADViewController () <BUSplashAdDelegate>
@property (strong, nonatomic) BUSplashAd *shtSplashAd;

@end

@implementation SHTKaiPingADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInitialPage)
                                                 name:@"NetworkRestored"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupNetwork)
                                                 name:@"NotNetwork"
                                               object:nil];
    [self buildAd];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)loadInitialPage {
    // 重载开屏广告
    [self loadAdData];
}

- (void)setupNetwork {
    [self loadAdData];
//    [SHTAlertHelper showAlertWithTitle:@"提示" message:@"当前网络不可用，请检查设置" cancelBtnText:nil confirmBtnText:@"去设置" inController:self cancelAction:nil confirmAction:^{
//        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
//            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
//        }
//    }];
}

#pragma mark - BUSplashAdDelegate
- (void)splashAdLoadSuccess:(nonnull BUSplashAd *)splashAd {
    NSLog(@"开屏广告加载成功-shtSplashAd:%@", splashAd);
    [splashAd showSplashViewInRootViewController:self];
}

- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error {
    NSLog(@"开屏广告加载失败-shtSplashAd:%@, error:%@", splashAd, error);

}

// 广告点击
- (void)splashAdDidClick:(BUSplashAd *)splashAd {
    AppDelegate *applicationShare = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [applicationShare setupPangrowthSDK];
}

// 广告播放控制器关闭(跳过或者播放完成)
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd {
    NSLog(@"广告关闭1");
    AppDelegate *applicationShare = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [applicationShare setupPangrowthSDK];
}

@end
