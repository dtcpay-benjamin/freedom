//
//  SHTKaiPingADViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2/4/25.
//

#import "SHTKaiPingADViewController.h"
#import "AppDelegate.h"
#if __has_include (<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif

@interface SHTKaiPingADViewController () <BUSplashAdDelegate>
@property (strong, nonatomic) BUSplashAd *shtSplashAd;

@end

@implementation SHTKaiPingADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildAd];
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
